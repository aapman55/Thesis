%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
%
% Vector2d - A 2d vector with lot of functions typical for vectors
%
classdef Vector2d < handle  
    
    properties
        x;      % The x-coordinate
        y;      % The y-coordinate
        gl = Geom();
    end
    
    methods
        function obj = Vector2d(x, y)
           obj.x = x;
           obj.y = y;
        end
        
        % Normalises the vector
        function newVector =  normalise(obj)
           totalLength =  norm([obj.x, obj.y]);
           tempX = obj.x/totalLength;
           tempY = obj.y/totalLength;
           newVector = Vector2d(tempX, tempY);
        end
        
        % Rotate a vector
        function newVector = rotate(obj, deg)
            [tempX,tempY, ~] = obj.gl.rotateZ(obj.x, obj.y, 0, deg);
            newVector = Vector2d(tempX, tempY);
        end
        
        % Creates a unit vector perpendicular to current one
        function newVector = createUnitNormal(obj)
            newVector = obj.rotate(90);
            % normalise vector
            newVector = newVector.normalise();
        end
        
        % dot-product
        function outcome = dot(obj, otherVector)
            % Check whether otherVector' is an instance of the class Vector2d 
           if(~isa(otherVector, 'Vector2d'))
               error('Only Vector2d objects can be added together!');
           end
           
           outcome = obj.x*otherVector.x + obj.y*otherVector.y;
        end        
        
        % Compute the angle between 2 vectors
        function angle = calculateAngle(obj, otherVector)
           % Check whether otherVector' is an instance of the class Vector2d 
           if(~isa(otherVector, 'Vector2d'))
               error('Only Vector2d objects can be added together!');
           end
           
            % Normalise vectors
            v1 = obj.normalise();
            v2 = otherVector.normalise();
            
            angle = acosd(v1.dot(v2));
        end
        
        % ==========================
        % Operator overloading
        % ==========================
        
        function newVector = plus(obj, otherVector)
           % Check whether otherVector' is an instance of the class Vector2d 
           if(~isa(otherVector, 'Vector2d'))
               error('Only Vector2d objects can be added together!');
           end
           
           % Create a new vector with the addition of the components of the
           % vectors.
           newVector = Vector2d(obj.x + otherVector.x, obj.y + otherVector.y);
        end
        
        function newVector = minus(obj, otherVector)
           % Check whether otherVector' is an instance of the class Vector2d 
           if(~isa(otherVector, 'Vector2d'))
               error('Only Vector2d objects can be added together!');
           end
           
           % Create a new vector with the addition of the components of the
           % vectors.
           newVector = Vector2d(obj.x - otherVector.x, obj.y - otherVector.y);
        end
        
        function newVector = uminus(obj)
           newVector = Vector2d(-obj.x, -obj.y); 
        end
        
        function newVector = mtimes(obj, obj2)
            % Check if you are multiplying a number.
           if(~(isa(obj2, 'double') || isa(obj, 'double')) || length(obj2) ~= 1)
               error('A vector can only be multiplied with a number!');
           end
            
           if (isa(obj2, 'double'))
                newVector = Vector2d(obj2*obj.x, obj2*obj.y);
           else
                newVector = Vector2d(obj*obj2.x, obj*obj2.y);
           end
        end
        
        function out = eq(a,b)
           % Check whether otherVector' is an instance of the class Vector2d 
           if(~isa(a, 'Vector2d') || ~isa(b, 'Vector2d'))
               error('Only Vector2d objects can be compared together!');
           end
           
           out = (a.x == b.x && a.y == b.y); 
        end
    end
    
end

