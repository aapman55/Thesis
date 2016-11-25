classdef SpectrometerExperiment < handle
    %SpectrometerExperiment This is to import the contents of a folder
    %containing csv files of SpectrometerMeasurments at once
    
    properties
        measurements;       % This list contains all the SpectrometerMeasurement objects
    end
    
    methods
        function obj = SpectrometerExperiment(measurements)
           obj.measurements = measurements; 
        end
        
        %=======================================
        % This function plots only measurement 'n'
        %=======================================        
        function h = plot(obj, number)
            if (number <= 0 || number > length(obj.measurements))
                error(['There are only ',num2str(length(obj.measurements)),' measurements!'])
            end
            h = obj.measurements(number).plot();
        end
        %=======================================
        % This function plots all the graphs
        %=======================================
        function h = plotAll(obj)
            % Create a figure and return the handle
            h = figure();
            hold on
            grid minor
            cmap = parula(length(obj.measurements)+3);
            % Initialise legend array
            legendList = cell.empty(length(obj.measurements),0);
            
            % Loop 
            for i= 1:length(obj.measurements)
               plot(obj.measurements(i).DATA(:,1), obj.measurements(i).DATA(:,2),...
                   'color',cmap(i,:), 'linewidth',1);
               legendList{i} = obj.measurements(i).Name;
            end
            xlabel('Wavelength [nm]');
            ylabel('Intensity [-]');
            legend(legendList);
            set(gca,'fontsize',11);
        end
        
        %=======================================
        % This function plots all the graphs separate
        %=======================================
        function handleList = plotAllSeparate(obj)
            % Create a figure and return the handle
            handleList = [];
            % Loop 
            for i= 1:length(obj.measurements)
               h = figure();
               hold on
               grid minor
               plot(obj.measurements(i).DATA(:,1), obj.measurements(i).DATA(:,2),...
                   'linewidth',1);
               xlabel('Wavelength [nm]');
               ylabel('Intensity [-]');
               legend(obj.measurements(i).Name);
               set(gca,'fontsize',11);
               
               % Add to handle list
               handleList = [handleList; h];
            end
            
        end
        
        %=======================================
        % This function plots all the graphs
        %=======================================
        
        function list(obj)
            for meas = obj.measurements
                disp(meas.Name);
            end
        end
    end
    
    methods(Static)
        function spectrometerExperiment = load(folder)
           % Get all the .csv files in the folder
           csvFilePaths = dir([folder,'/*.csv']);      
           
           % Create a list for the measurements
           measurements = SpectrometerMeasurement.empty;
           
           % For all csv files create a SpectrometerMeasurement object for
           % it
           for i = 1:length(csvFilePaths)
               measurements(i) = SpectrometerMeasurement.load([folder,'/',csvFilePaths(i).name]);
               disp([num2str(i/length(csvFilePaths)*100),'% Completed'])
           end
           
           spectrometerExperiment = SpectrometerExperiment(measurements);
        end
    end
    
end

