%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
%
% LightRay To be used with RefractionBorder
%
classdef LightRay < handle   
    
    properties
        beginpoint;     % Vector2d object to indicate the beginpoint
        direction;      % Vector2d object to indicate the direction
    end
    
    methods
        function obj = LightRay(beginpoint, direction)
            % Check integrity of the inputs
            if (~isa(beginpoint , 'Vector2d') || ~isa(direction,'Vector2d'))
                error('Beginpoint and Endpoint need to be Vector2d objects!')
            end
            
           obj.beginpoint = beginpoint;
           obj.direction = direction.normalise();
        end
                
        function intersection = intersectLightRay(obj, otherLightRay)
            % Computes the intersection point between 2 lightrays
            
            % Checks if the input is a lighray
            if (~isa(otherLightRay, 'LightRay'))
                error('Your input must be a LightRay object!');
            end
            
           % Calculate  intersection point
           % shorten notation
           x1 = obj.beginpoint.x;
           y1 = obj.beginpoint.y;
           
           x2 = x1+ obj.direction.x;
           y2 = y1+ obj.direction.y;
           
           x3 = otherLightRay.beginpoint.x;
           y3 = otherLightRay.beginpoint.y;
           
           x4 = x3 + otherLightRay.direction.x;
           y4 = y3 + otherLightRay.direction.y;
           
           Px = ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
           Py = ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
           
           intersection.x = Px;
           intersection.y = Py;
        end
        
        %% ==================================
        % Operator overloading
        % ===================================
        function out = eq(a,b)
            
            % Checks if the input is a lighray
            if (~isa(a, 'LightRay') || ~isa(b, 'LightRay'))
                error('Only lightray objects can be compared!');
            end
            
            out = (a.beginpoint == b.beginpoint && a.direction == b.direction);
        end
    end
    
end

