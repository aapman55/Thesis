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
    
    properties
        height;                 % Height of the lens
        xlocation;              % The x-location of the lens
        leftRadius;             % The radius of the left circle of the lens
        rightRadius;            % The radius of the right circle of the lens
        midSectionThickness;    % This indicates the thickness of the non spherical section between the 2 circle radii
        leftSegments;           % This stores all the segments of the left circle
        rightSegments;          % This stores all the segments of the right circle
        
        nLens = 1.5;            % Standard value of index of refraction of the Lens
        nMedium = 1;            % Standard value of index of refraction in which the lens is staying
        
        leftRefractionBorders;  % List of refractionBorders created with the left elements
        rightRefractionBorders; % List of refractionBorders created with the right elements
        midSectionRefractionBorders;
        
        lightRayList = [];      % Initialise an empty array with lightRay objects
        totalRays;              % This array contains the calculated arrays
        
    end
    
    methods
        function obj = ThickLens(height, xlocation, leftRadius, rightRadius, midSectionThickness)
            amountOfPiecesPerCurve = 500;
            
            obj.totalRays = struct('x',[],'y',[]);
            % Save input data
            obj.height = height;
            obj.xlocation = xlocation;
            obj.leftRadius = leftRadius;
            obj.rightRadius = rightRadius;
            obj.midSectionThickness = midSectionThickness;
            
            % The x-location represents the center of the midsection, which
            % has no curvature. So if the midsection thickness is 0. The
            % x-location represents the border between the 2 curved
            % surfaces. When the radius has value inf, this case will be
            % caught by making a straight line.
            if (isinf(leftRadius))
                leftSegments.x = (xlocation - 0.5*midSectionThickness) * ones(2,1);
                leftSegments.y = [-height/2, height/2];
            else
                % Calculate the angle that matches the height
                theta = asind(height/2/leftRadius);
                
                % Use this theta to build up a lens containing amountOfPiecesPerCurve pieces
                THETA = linspace(-theta, theta, amountOfPiecesPerCurve);
                % A minus sign to bring the curvature to the left
                leftSegments.x =  - leftRadius.*cosd(THETA);
                leftSegments.y = leftRadius.*sind(THETA);
                
                % move the xcoordinates to the left with 0.5 midsection
                % width and sqrt(R^2-height^2)
                distToCenter = xlocation + sqrt(leftRadius^2 - (0.5*height)^2) - 0.5*midSectionThickness;
                
                leftSegments.x = leftSegments.x + distToCenter;
            end
            
            obj.leftSegments = leftSegments;
            
            if (isinf(rightRadius))
                rightSegments.x = (xlocation + 0.5*midSectionThickness) * ones(2,1);
                rightSegments.y = [height/2, -height/2];
            else
                % Calculate the angle that matches the height
                theta = asind(height/2/rightRadius);
                
                % Use this theta to build up a lens containing amountOfPiecesPerCurve pieces
                THETA = linspace(theta, -theta, amountOfPiecesPerCurve);
                rightSegments.x =  rightRadius.*cosd(THETA);
                rightSegments.y = rightRadius.*sind(THETA);
                
                % move the xcoordinates to the left with 0.5 midsection
                % width and sqrt(R^2-height^2)
                distToCenter =  - xlocation +  sqrt(rightRadius^2 - (0.5*height)^2) - 0.5*midSectionThickness;
                
                rightSegments.x = rightSegments.x - distToCenter;
            end
            
            obj.rightSegments = rightSegments;
            
            % Create the RefractionBorders
            obj.leftRefractionBorders = RefractionBorder.empty(length(leftSegments.x)-1,0);
            obj.rightRefractionBorders = RefractionBorder.empty(length(rightSegments.x)-1,0);
            obj.midSectionRefractionBorders = RefractionBorder.empty(2,0);
            
            for i = 1:length(leftSegments.x)-1
               obj.leftRefractionBorders(i) = RefractionBorder( Vector2d(leftSegments.x(i), leftSegments.y(i)),...
                                                                Vector2d(leftSegments.x(i+1), leftSegments.y(i+1)),...
                                                                obj.nMedium,...
                                                                obj.nLens);
            end
            
            for i = 1:length(rightSegments.x)-1
               obj.rightRefractionBorders(i) = RefractionBorder( Vector2d(rightSegments.x(i), rightSegments.y(i)),...
                                                                Vector2d(rightSegments.x(i+1), rightSegments.y(i+1)),...
                                                                obj.nMedium,...
                                                                obj.nLens);
            end
            
            obj.midSectionRefractionBorders(1) = RefractionBorder( Vector2d(xlocation-midSectionThickness/2, height/2),...
                                                                Vector2d(xlocation+midSectionThickness/2, height/2),...
                                                                obj.nMedium,...
                                                                obj.nLens);
                                                            
            obj.midSectionRefractionBorders(2) = RefractionBorder( Vector2d(xlocation-midSectionThickness/2, -height/2),...
                                                                    Vector2d(xlocation+midSectionThickness/2, -height/2),...
                                                                    obj.nLens,...
                                                                    obj.nMedium);            
        end
        
        function setMedium(obj, nMedium)
           obj.nMedium = nMedium; 
        end
        
        function setLensMaterial(obj, nLens)
            obj.nLens = nLens;
        end
        
        function addLightRay(obj, lightRay)
            % Checks if the lightRay is really a LightRay object
            if (~isa(lightRay, 'LightRay'))
                error('Your input must be a LightRay object!');
            end
            
            % This is just for convenience purposes. The lightray will be
            % calculated and stored anyways.
            obj.lightRayList = [obj.lightRayList, lightRay];
            
            % Determine which side of the lens your light ray is from
            minX = min(obj.leftSegments.x);
            maxX = max(obj.rightSegments.x);
            
            % Check if the light ray is not on top of the lens in x
            % direction. 
            if(lightRay.beginpoint.x > minX && lightRay.beginpoint.x < maxX)
                error('Please put the lightray on the left or right side of the lens!')
            end
            
            % Case when the lightray is on the left
            if (lightRay.beginpoint.x < minX)
                % First refract with the left curvature
                for i=1:length(obj.leftRefractionBorders)
                   firstRay = obj.leftRefractionBorders(i).refractRay(lightRay);
                   if (~isa(firstRay, 'LightRay'))
                       continue;
                   end
                   break;                   
                end
                % If there is no collision point found isnan(firstRay).
                % Then give warning and exit without adding ray.
                if(~isa(firstRay, 'LightRay'))
                    warning('No intersection of lightRay with Lens!');  
                    return
                end
                
                % Continue with the right curved surface
                for i=1:length(obj.rightRefractionBorders)
                   secondRay = obj.rightRefractionBorders(i).refractRay(firstRay);
                   if (~isa(secondRay, 'LightRay'))
                       continue;
                   end
                   break;                   
                end
                
                % If there is no collision point found isnan(secondRay).
                % Then give warning and exit without adding ray.
                if(~isa(secondRay, 'LightRay'))
                    warning('No intersection of lightRay with Lens!');  
                    return
                end
                
                % Calculate the last point

                lastpoint = secondRay.beginpoint + 2.5*obj.height*secondRay.direction;

                
                % Add to totalRays
                obj.totalRays.x = [obj.totalRays.x; lightRay.beginpoint.x,...
                                                    firstRay.beginpoint.x,...
                                                    secondRay.beginpoint.x,...
                                                    lastpoint.x];
                                                
                obj.totalRays.y = [obj.totalRays.y; lightRay.beginpoint.y,...
                                                    firstRay.beginpoint.y,...
                                                    secondRay.beginpoint.y,...
                                                    lastpoint.y];
            end
        end
        
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
        function h = draw(obj)
            % Standard blue color
            StdBlue = lines(1);
            
            h = figure();
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
        
        function h = drawRays(obj)
           h = obj.draw();
           
           for i=1:size(obj.totalRays.x,1)
                plot(obj.totalRays.x(i,:), obj.totalRays.y(i,:), 'color', lines(1))
           end
        end
        
        function maxThickness = maxThickness(obj)
            maxThickness = max(obj.rightSegments.x) -  min(obj.leftSegments.x);
        end
    end
    
end

