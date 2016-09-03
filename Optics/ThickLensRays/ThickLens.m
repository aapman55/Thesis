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
        
        leftRefractionBorders;  % List of refractionBorders created with the left elements
        rightRefractionBorders; % List of refractionBorders created with the right elements
        midSectionRefractionBorders;
    end
    
    methods
        function obj = ThickLens(height, xlocation, leftRadius, rightRadius, midSectionThickness)
            amountOfPiecesPerCurve = 50;
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
                leftSegments.y = [height/2, -height/2];
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
                distToCenter = sqrt(leftRadius^2 - (0.5*height)^2) - 0.5*midSectionThickness;
                
                leftSegments.x = leftSegments.x + distToCenter;
            end
            
            obj.leftSegments = leftSegments;
            
            if (isinf(rightRadius))
                leftSegments.x = (xlocation - 0.5*midSectionThickness) * ones(2,1);
                leftSegments.y = [height/2, -height/2];
            else
                % Calculate the angle that matches the height
                theta = asind(height/2/rightRadius);
                
                % Use this theta to build up a lens containing amountOfPiecesPerCurve pieces
                THETA = linspace(-theta, theta, amountOfPiecesPerCurve);
                rightSegments.x =  rightRadius.*cosd(THETA);
                rightSegments.y = rightRadius.*sind(THETA);
                
                % move the xcoordinates to the left with 0.5 midsection
                % width and sqrt(R^2-height^2)
                distToCenter = sqrt(rightRadius^2 - (0.5*height)^2) - 0.5*midSectionThickness;
                
                rightSegments.x = rightSegments.x - distToCenter;
            end
            
            obj.rightSegments = rightSegments;
            
            % Test plotting
            plot(leftSegments.x, leftSegments.y);
            hold on
            axis image
            plot(rightSegments.x, rightSegments.y);
            plot([- 0.5*midSectionThickness, 0.5*midSectionThickness],[height/2 height/2])
            plot([- 0.5*midSectionThickness, 0.5*midSectionThickness],[-height/2 -height/2])
        end
    end
    
end

