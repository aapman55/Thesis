%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
%
% THICKLENS This class represents a thicklens. The lightRay refractions are
% done using snellius law.
%
classdef ThickLens < handle   
    
    properties(SetAccess = private)
        height;                 % Height of the lens
        leftRadius;             % The radius of the left circle of the lens
        rightRadius;            % The radius of the right circle of the lens
        midSectionThickness;    % This indicates the thickness of the non spherical section between the 2 circle radii
        leftSegments;           % This stores all the segments of the left circle
        rightSegments;          % This stores all the segments of the right circle
        
        leftSegmentsOriginal;   % This stores all the segments of the left circle (unoriented)
        rightSegmentsOriginal;  % This stores all the segments of the right circle (unoriented)
        
        amountOfPiecesPerCurve = 200;
        
        maxThickness;           % The constructor sets the maximumthickness of the lens
        
        nLens = 1.5;            % Standard value of index of refraction of the Lens
        nMedium = 1;            % Standard value of index of refraction in which the lens is staying
        
        leftRefractionBorders;  % List of refractionBorders created with the left elements
        rightRefractionBorders; % List of refractionBorders created with the right elements
        midSectionRefractionBorders;
        
        lightRayList = [];      % Initialise an empty array with lightRay objects
        outGoingRayList = [];   % Initialise an empty array with lightRay objects for rays leaving the lens
        totalRays;              % This array contains the calculated arrays
        
    end
    
    methods
        %% ==================================
        % Constructor
        % ===================================
        function obj = ThickLens(height, leftRadius, rightRadius, midSectionThickness)

            
            obj.totalRays = struct('x',[],'y',[]);
            % Save input data
            obj.height = height;
            obj.leftRadius = leftRadius;
            obj.rightRadius = rightRadius;
            obj.midSectionThickness = midSectionThickness;
            
            % The x-location represents the center of the midsection, which
            % has no curvature. So if the midsection thickness is 0. The
            % x-location represents the border between the 2 curved
            % surfaces. When the radius has value inf, this case will be
            % caught by making a straight line.
            if (isinf(leftRadius))
                leftSegments.x = ( - 0.5*midSectionThickness) * ones(2,1);
                leftSegments.y = [-height/2; height/2];
            else
                % Calculate the angle that matches the height
                theta = asind(height/2/leftRadius);
                
                % Use this theta to build up a lens containing amountOfPiecesPerCurve pieces
                THETA = linspace(-theta, theta, obj.amountOfPiecesPerCurve);
                % A minus sign to bring the curvature to the left
                leftSegments.x =  - leftRadius.*cosd(THETA);
                leftSegments.y = leftRadius.*sind(THETA);
                
                % move the xcoordinates to the left with 0.5 midsection
                % width and sqrt(R^2-height^2)
                distToCenter =  sqrt(leftRadius^2 - (0.5*height)^2) - 0.5*midSectionThickness;
                
                leftSegments.x = leftSegments.x + distToCenter;
            end
            
            obj.leftSegments = leftSegments;
            obj.leftSegmentsOriginal = leftSegments;
            
            if (isinf(rightRadius))
                rightSegments.x = ( 0.5*midSectionThickness) * ones(2,1);
                rightSegments.y = [height/2, -height/2];
            else
                % Calculate the angle that matches the height
                theta = asind(height/2/rightRadius);
                
                % Use this theta to build up a lens containing amountOfPiecesPerCurve pieces
                THETA = linspace(theta, -theta, obj.amountOfPiecesPerCurve);
                rightSegments.x =  rightRadius.*cosd(THETA);
                rightSegments.y = rightRadius.*sind(THETA);
                
                % move the xcoordinates to the left with 0.5 midsection
                % width and sqrt(R^2-height^2)
                distToCenter =   sqrt(rightRadius^2 - (0.5*height)^2) - 0.5*midSectionThickness;
                
                rightSegments.x = rightSegments.x - distToCenter;
            end
            
            obj.rightSegments = rightSegments;
            obj.rightSegmentsOriginal = rightSegments;
            
            % Create the refraction borders
            obj.createRefractionBorders();     
            
            % Postprocessing for some properties
            obj.maxThickness = max(obj.rightSegments.x) -  min(obj.leftSegments.x);
            
        end
        
        %% ==================================
        % Lens Re-orientation methods
        % ===================================
        function translateX(obj, amount)
           % update the left segments
           obj.leftSegments.x = obj.leftSegments.x + amount;
           
           % Update the right segments
           obj.rightSegments.x = obj.rightSegments.x + amount;
           
           % Recompute geometry
           obj.createRefractionBorders();
        end
        
        function translateY(obj, amount)
           % update the left segments
           obj.leftSegments.y = obj.leftSegments.y + amount;
           
           % Update the right segments
           obj.rightSegments.y = obj.rightSegments.y + amount;
           
           % Recompute geometry
           obj.createRefractionBorders();
        end
        
        function rotate(obj, deg)
            % update the left segments  
            x = obj.leftSegments.x;
            y = obj.leftSegments.y;
            obj.leftSegments.x = cosd(deg).*x - sind(deg).*y;
            obj.leftSegments.y = sind(deg).*x + cosd(deg).*y;
            
            % update the right segments
            x = obj.rightSegments.x;
            y = obj.rightSegments.y;
            obj.rightSegments.x = cosd(deg).*x - sind(deg).*y;
            obj.rightSegments.y = sind(deg).*x + cosd(deg).*y;
            
           % Recompute geometry
           obj.createRefractionBorders();
        end        
        
        function resetOrientation(obj)
           obj.leftSegments = obj.leftSegmentsOriginal;
           obj.rightSegments = obj.rightSegmentsOriginal;
          % Recompute geometry
           obj.createRefractionBorders();
        end
        
        %% ==================================
        % Core Features
        % ===================================
        function addLightRay(obj, lightRay)
            % Checks if the lightRay is really a LightRay object
            if (~isa(lightRay, 'LightRay'))
                error('Your input must be a LightRay object!');
            end
           
            % Compute the ray trajectory
            try
                [refractedRay, rayTrajectory] = obj.computeLightRay(lightRay);
            catch e
               warning(e.message); 
               return; 
            end
            
            % This is just for convenience purposes. The lightray will be
            % calculated and stored anyways.
            obj.lightRayList = [obj.lightRayList, lightRay];
            
            % Add to totalRays
            obj.totalRays.x = [obj.totalRays.x; rayTrajectory.x];

            obj.totalRays.y = [obj.totalRays.y; rayTrajectory.y];
                                            
            % Add secondRay to the list of outgoing lightRays
            obj.outGoingRayList = [obj.outGoingRayList ; refractedRay];
        end        
        
        % This function computes the trajectory of the lightray. As output
        % it has the final refracted lightray and also the complete
        % trajectory from beginpoint to somewhere behind the lens.
        function [refractedRay, rayTrajectory] = computeLightRay(obj, lightRay)
            % Checks if the lightRay is really a LightRay object
            if (~isa(lightRay, 'LightRay'))
                error('Your input must be a LightRay object!');
            end
            
            % Check if the light ray is not on top of the lens in x
            % direction. 
            position = obj.whichSideOfTheBorder(lightRay.beginpoint);
            
            % Determine whether the lightray is on the left or right
            isInsideLeft = sum(position.left==-1) == length(position.left);
            isInsideRight = sum(position.right==-1) == length(position.right);
            
            if(isInsideLeft && isInsideRight)
                error('Please put the lightray in front of one of the two surfaces!')
            end
            
            % Case when the lightray is on the left
            if (isInsideRight)
                % Refraction border encountered first
                firstRFBorders = obj.leftRefractionBorders;
                % Refraction border encountered second
                secondRFBorders = obj.rightRefractionBorders;
            % Case when the lightray is on the right
            else
                % Refraction border encountered first
                firstRFBorders = obj.rightRefractionBorders;
                % Refraction border encountered second
                secondRFBorders = obj.leftRefractionBorders;
            end
            
            % First refract with the first encountered curvature
            for i=1:length(firstRFBorders)
               firstRay = firstRFBorders(i).refractRay(lightRay);
               if (~isa(firstRay, 'LightRay'))
                   continue;
               end
               break;                   
            end
            % If there is no collision point found isnan(firstRay).
            % Then give warning and exit without adding ray.
            if(~isa(firstRay, 'LightRay'))
                error('No intersection of lightRay with Lens!');                 
            end

            % Continue with the second encounterd curved surface
            for i=1:length(secondRFBorders)
               secondRay = secondRFBorders(i).refractRay(firstRay);
               if (~isa(secondRay, 'LightRay'))
                   continue;
               end
               break;                   
            end

            % If there is no collision point found isnan(secondRay).
            % Then give warning and exit without adding ray.
            if(~isa(secondRay, 'LightRay'))
                error('No intersection of lightRay with Lens!');                  
            end

            % Calculate the last point

            lastpoint = secondRay.beginpoint + 2.5*obj.height*secondRay.direction;


            % Add to totalRays
            rayTrajectory.x = [lightRay.beginpoint.x,...
                               firstRay.beginpoint.x,...
                               secondRay.beginpoint.x,...
                               lastpoint.x];

            rayTrajectory.y = [lightRay.beginpoint.y,...
                               firstRay.beginpoint.y,...
                               secondRay.beginpoint.y,...
                               lastpoint.y];            
                           
           % Assign value of secondRay to refractedRAy
           refractedRay = secondRay;
        end
        
        %% ==================================
        % Visualisations
        % ===================================
                
        %Plots the refraction Borders using different Colors (At least
        %since matlab 2014)
        function h = showRefractionBorders(obj)
            h = figure();
            hold on            
            for i = 1:length( obj.leftRefractionBorders)
                obj.leftRefractionBorders(i).draw(); 
            end
            
            for i = 1:length( obj.rightRefractionBorders)
                obj.rightRefractionBorders(i).draw(); 
            end
            
            for i = 1:length( obj.midSectionRefractionBorders)
                obj.midSectionRefractionBorders(i).draw(); 
            end
            axis image;
        end
        
        % Draw the lens using the standard blue color
        function h = draw(obj, createFig)
            % Standard blue color
            StdBlue = lines(1);
            
            % If a new figure is requested
            if(exist('createFig','var') && createFig)
                h = figure();
                xlabel('Horizontal/Optical axis [mm]')
                ylabel('Vertical axis [mm]')
            else
                h = 0;
            end
            
            hold on            
            for i = 1:length( obj.leftRefractionBorders)
                obj.leftRefractionBorders(i).drawMono(StdBlue); 
            end
            
            for i = 1:length( obj.rightRefractionBorders)
                obj.rightRefractionBorders(i).drawMono(StdBlue); 
            end
            
            for i = 1:length( obj.midSectionRefractionBorders)
                obj.midSectionRefractionBorders(i).drawMono(StdBlue); 
            end
            axis image;
        end
        
        % Draw all the light rays in obj.totalRays. These light rays have
        % been added with the function addLightRay.
        function h = drawRays(obj, createFig)
            % If a new figure is requested
            if(exist('createFig','var') && createFig)
                h = obj.draw(createFig);
            else
                h = 0;
                obj.draw();
            end
           
           linecolors = lines(2);
           for i=1:size(obj.totalRays.x,1)
                plot(obj.totalRays.x(i,:), obj.totalRays.y(i,:), 'color', linecolors(1,:))
           end
        end       
        
        %% ==================================
        % Collision detection
        % ===================================
        
        function output = whichSideOfTheBorder(obj, vector)
           %  This function determines for all the Refraction Borders
           %  whether a point is on the side in which the normals are
           %  pointing. As results 3 arrays will be provided, corresponding
           %  to Left, Middle, Right. Wach array contains entries that
           %  say 1, 0 or -1.
           
           % Simple check to see if the input vector really is a vector of
           % class Vector2d
           if (~isa(vector , 'Vector2d'))
               error('The input should be a Vector2d object!')
           end
           
           % Initialise vectors
           output.left = zeros(size(obj.leftRefractionBorders));
           output.middle = zeros(size(obj.midSectionRefractionBorders));
           output.right = zeros(size(obj.rightRefractionBorders));
           
           % Loop over the left borders
           for i=1:length(obj.leftRefractionBorders)
               output.left(i) = obj.leftRefractionBorders(i).determineSide(vector);
           end
           
           % Loop over the middle borders
           for i=1:length(obj.midSectionRefractionBorders)
               output.middle(i) = obj.midSectionRefractionBorders(i).determineSide(vector);
           end
           
          % Loop over the right borders
           for i=1:length(obj.rightRefractionBorders)
               output.right(i) = obj.rightRefractionBorders(i).determineSide(vector);
           end
        end
        
        function out = isInsideLens(obj, vector)
        % This function determines whether a point is outside the lens.

        % No need for vector class checking, will be done in the called
        % function.
           outcome = obj.whichSideOfTheBorder(vector);           
           
           out =    sum(outcome.left==-1) == length(outcome.left) &&...
                    sum(outcome.middle==-1) == length(outcome.middle) &&...
                    sum(outcome.right==-1) == length(outcome.right);
        end
        
        %% ==================================
        % Setters
        % ===================================
        function setMedium(obj, nMedium)
           % Defines the index of refraction of the medium the lens is in.
           obj.nMedium = nMedium; 
        end
        
        function setLensMaterial(obj, nLens)
            % Define the index of refraction of the lens.
            obj.nLens = nLens;
        end
        
        function setAmtPiecesPerCurve(obj, amtPiecesPerCurve)
           % Sets how many pieces each curved surface consists of.
           obj.amountOfPiecesPerCurve = amtPiecesPerCurve; 
        end
        
    end
    
    %% private helper methods
    methods(Access = private)
        function createRefractionBorders(obj)
            % Create the RefractionBorders
            obj.leftRefractionBorders = RefractionBorder.empty(length(obj.leftSegments.x)-1,0);
            obj.rightRefractionBorders = RefractionBorder.empty(length(obj.rightSegments.x)-1,0);
            obj.midSectionRefractionBorders = RefractionBorder.empty(2,0);
            
            for i = 1:length(obj.leftSegments.x)-1
               obj.leftRefractionBorders(i) = RefractionBorder( Vector2d(obj.leftSegments.x(i), obj.leftSegments.y(i)),...
                                                                Vector2d(obj.leftSegments.x(i+1), obj.leftSegments.y(i+1)),...
                                                                obj.nMedium,...
                                                                obj.nLens);
            end
            
            for i = 1:length(obj.rightSegments.x)-1
               obj.rightRefractionBorders(i) = RefractionBorder( Vector2d(obj.rightSegments.x(i), obj.rightSegments.y(i)),...
                                                                Vector2d(obj.rightSegments.x(i+1), obj.rightSegments.y(i+1)),...
                                                                obj.nMedium,...
                                                                obj.nLens);
            end
            
            obj.midSectionRefractionBorders(1) = RefractionBorder( Vector2d(obj.leftSegments.x(end), obj.leftSegments.y(end)),...
                                                                   Vector2d(obj.rightSegments.x(1), obj.rightSegments.y(1)),...                                                                
                                                                   obj.nMedium,...
                                                                   obj.nLens);
                                                            
            obj.midSectionRefractionBorders(2) = RefractionBorder( Vector2d(obj.rightSegments.x(end), obj.rightSegments.y(end)),...
                                                                Vector2d(obj.leftSegments.x(1), obj.leftSegments.y(1)),...
                                                                obj.nMedium,...
                                                                obj.nLens);          
        end
        
        %% ==================================
        % property calculators
        % ===================================
        
        % Calculates the principal planes (with the unoriented lens)
        function calcPrinciplePlanes(obj)
            
            % Left to right ray
            direction = Vector2d(1,0);
            leftToRightRay = LightRay(Vector2d(-10*obj.maxThickness,0), direction.rotate(10));
            [refractedRay, lrPath] = obj.computeLightRay(leftToRightRay);
            
            leftIntersect = refractedRay.intersectLightRay(leftToRightRay);
            
            obj.draw(true)
            hold on
            plot(lrPath.x, lrPath.y)
            scatter(leftIntersect.x, leftIntersect.y)
        end
    end
    
end

