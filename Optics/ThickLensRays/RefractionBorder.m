%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
%
%REFRACTIONBORDER This class represents the border between 2 materials
%with different index of refractions. This border has a location in
%space. A calculation function is available to put in a lightray and
%get the refracted lightray. 
%
% This class is specifically made to perform as a differential element
% of a lens, to simulate the thick lens.
%
%
%           n1
%                  ^ unit normal
%                  |
%      X------------------------X
%   beginpoint               endpoint
%
%         n2
%
classdef RefractionBorder < handle
    
    properties
        beginpoint;     % This is a vector 2d object indicating the begin point of this border
        endpoint;       % This is a vector 2d object indicating the end point of this border
        unitNormal;     % This is a vector 2d object, calculated while initialising. It represents the unit normal of the border.
        n1;             % The index of refraction at the left side of the border
        n2;             % The index of refraction at the right side of the border
    end
    
    methods
        % Constructor
        function obj = RefractionBorder(beginpoint, endpoint, n1, n2)
            % Check integrity of the inputs
            if (~isa(beginpoint , 'Vector2d') || ~isa(endpoint,'Vector2d'))
                error('Beginpoint and Endpoint need to be Vector2d objects!')
            end
            
            if (length(n1)~=1 || length(n2)~=1)
                error('The index of refractions can not be arrays!')
            end
            
            if (~isa(n1,'double') || ~isa(n2,'double'))
                error('The index of refraction needs to be a number');
            end
            
           obj. beginpoint = beginpoint;
           obj.endpoint = endpoint;
           obj.n1 = n1;
           obj.n2 = n2;
           
           % Now calculate the unit normal
           tempVector = endpoint - beginpoint;
           obj.unitNormal = tempVector.createUnitNormal();
        end
        
        % Draw the border
        function draw(obj)
            plot([obj.beginpoint.x, obj.endpoint.x],[obj.beginpoint.y, obj.endpoint.y] )
        end
        
        % function to check if a lightray hits this refractionBorder
        function collisionPoint = hasCollision(obj, lightRay)
            % Checks if the lightRay is really a LightRay object
            if (~isa(lightRay, 'LightRay'))
                error('Your input must be a LightRay object!');
            end            
            
            % Check for paralellism
            tempV = obj.endpoint - obj.beginpoint;
            if (abs(tempV.dot(lightRay.direction)) == 1)
                collisionPoint = Vector2d(nan,nan);
                return
            end
            
           % Calculate  intersection point
           % shorten notation
           x1 = obj.beginpoint.x;
           y1 = obj.beginpoint.y;
           
           x2 = obj.endpoint.x;
           y2 = obj.endpoint.y;
           
           x3 = lightRay.beginpoint.x;
           y3 = lightRay.beginpoint.y;
           
           x4 = x3 + lightRay.direction.x;
           y4 = y3 + lightRay.direction.y;
           
           Px = ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
           Py = ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
           
           % Determine whether the intersection is on the refraction border
           if ((Px < obj.beginpoint.x && Px < obj.endpoint.x) || (Px > obj.beginpoint.x && Px > obj.endpoint.x))
               collisionPoint = Vector2d(nan,nan);
               return
           end
           
           if ((Py < obj.beginpoint.y && Py < obj.endpoint.y) || (Py > obj.beginpoint.y && Py > obj.endpoint.y))
               collisionPoint = Vector2d(nan,nan);
               return
           end
           
           % Return intersection
           collisionPoint = Vector2d(Px,Py);
        end
    end
    
end

