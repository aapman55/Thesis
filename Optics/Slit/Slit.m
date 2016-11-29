%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
%
% Slit Simulates the effect of slits on a light wave
%
classdef Slit < handle
    %Slit Assumed that the slit hole is infinitesimally small;
    
    properties
        d;                  % Slit spacing 
        amtSlit;            % Amount of Slits
        screenDist;         % Distance to the screen in same units as d
        slitPointList;      % List with Point2D objects, will be filled by the constructor
        minX;               % The minimum value for x of the slits
        maxX;               % The maximum value for x of the slits
        
        lastResult;         % Saves the last shineLight simulation result
    end
    
    methods
        %% ========================
        % Constructor
        %==========================
        function obj = Slit(d, amtSlit, screenDist)
            % Setters
            obj.d = d;
            obj.amtSlit = amtSlit;
            obj.screenDist = screenDist;
            
            % create list with slit points
            odd = logical(mod(amtSlit, 2));
            
            % To assure that the slit points are symmetric around y=0. A
            % distinction is made for odd and even cases
            
            if (odd)
                % The amount of slits is odd. There should be a slit point
                % at y=0
                x = -(amtSlit-1)/2*d:d:(amtSlit-1)/2*d;
            else
                % The amount of slits is even. There should be no slit point
                % at y=0
                x = -amtSlit/2*d+d/2:d:amtSlit/2*d-d/2;
            end
            
            % Create the slitpoints
            obj.slitPointList = Point2D.createPointsFromVector(x,zeros(size(x)));            
            
            % For convenience (total grating dimensions) these values are
            % saved
            obj.minX = min(x);
            obj.maxX = max(x);
        end
        
        %% ========================
        % Start the simulation
        % lightWavelength - User defines the wavelength of the light
        % screenPointsX - User defines the sample points on the screen
        % (only x coordinates are needed, as screendistance was already
        % proivided)
        %==========================        
        function magnitudeScreenPoints = shineLight(obj, lightWavelength, screenPointsX)
            % Create a vector with screen distances with the same length as
            % screenPointsX
            screenPointsY = repelem(obj.screenDist, length(screenPointsX));
            
            % Create the poit2D objects
            screenPoints = Point2D.createPointsFromVector(screenPointsX, screenPointsY);            
            
            % Initialise values for the screenpoints
            magnitudeScreenPoints = zeros(size(screenPointsX));

            % Loop over all screenpoints. For each screenpoint add all the
            % contributions of the slitpoints
            for i = 1:length(screenPointsX)
                % Initialise dummy variable to keep track of all influences
                % on the current screenPoint
                current = 0;
                
                % Loop over all slitpoints
                for j = obj.slitPointList
                    % The distance from the current screenPoint to the
                    % current slitpoint
                    distance = j.dist(screenPoints(i));
                    % Calculate how many times the wavelength fits in the
                    % distance. The remainder (decimal) indicates the phase
                    % shift.
                    portion = distance/lightWavelength;  
                    % Add the contribution of the current Slitpoint
                    current = current + sin((portion-floor(portion))*2*pi)/(distance);
                end
                
                % All influences on this screen point are done. Add to the
                % list.
                magnitudeScreenPoints(i) = current;
            end
            
            % Save the current simulation in the struct lastResult
            obj.lastResult.screenPointsX = screenPointsX;
            obj.lastResult.magnitudeScreenPoints = magnitudeScreenPoints;     
            
            % Display the results in a plot
            obj.plotLastResults();

        end
        %% ========================
        % Plot
        %==========================
        function plotLastResults(obj)
            % Create a new figure
            figure()
            % Plot the results
            plot(obj.lastResult.screenPointsX, obj.lastResult.magnitudeScreenPoints);
            % Put in the legend the amount of slits
            legend([num2str(obj.amtSlit),' slits'])
            % Set minor grid
            grid minor
            % Set font size
            set(gca,'fontsize',14);
            % Define axis labels
            ylabel('Amplitude [-]')
            xlabel('Distance along screen [m]')
        end
    end
    
end

