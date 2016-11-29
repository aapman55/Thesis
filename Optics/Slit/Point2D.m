%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
%
% Point2D An easy to use class for a 2D point
%
classdef Point2D < handle
    %Point2D a D point in space
    
    properties
        x;              % X-coordinate
        y;              % Y-coordinate
    end
    
    methods
        %% ================================
        % Constructor
        %==================================
        function obj = Point2D(x,y)
            obj.x = x;
            obj.y = y;
        end
        %% ================================
        % Calculates the distance between 2 points
        %==================================        
        function distance = dist(obj, other)
            distance = sqrt((obj.x - other.x)^2+(obj.y - other.y)^2);
        end
        %% ================================
        % Plots the point
        %==================================         
        function show(obj)
            scatter(obj.x, obj.y);
        end
    end
    
    methods(Static)
        %% ================================
        % Creates a list of Points by entering a vector with x coordinates
        % and a vector with y coordinates
        %================================== 
        function pointsList = createPointsFromVector(xVector, yVector)
            % Initialise the list with Point2D objects
            pointsList = Point2D.empty(length(xVector),0);
            
            % Check if the x vector is the same length as the y vector
            if (size(xVector) ~= size(yVector))
                error('The size of the vectors need to be identical!')
            end
            
            % Create for each entry a point and add it to the list
            for i = 1:length(xVector)
                pointsList(i) = Point2D(xVector(i), yVector(i));
            end
            
        end
    end    
end

