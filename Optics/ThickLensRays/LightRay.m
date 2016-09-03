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
    end
    
end

