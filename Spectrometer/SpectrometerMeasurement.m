classdef SpectrometerMeasurement < handle
    %SPECTROMETERMEASUREMENT This class can read a csv file created by
    %Thorlabs OSWAW
    
    properties
        Name;           % Name of the file
        HeaderInfo;     % This contains all the environmental data that came with the experiment
        DATA;           % This contains the measured data from the experiment
    end
    
    methods
        function obj = SpectrometerMeasurement(Name, HeaderInfo, DATA)
            obj.Name = Name;
            obj.DATA = DATA;
            obj.HeaderInfo = HeaderInfo;
        end
        
        function h = plot(obj)
           h = plot(obj.DATA(:,1),obj.DATA(:,2));
           xlabel('Wavelength [nm]');
           ylabel('Intensity [-]');
           set(gca,'fontsize',11);
           grid minor
        end
        
        % Isolates the peak with a certain threshold, only works when there
        % is just one peak. The threshold should be a number between 0 and
        % 1. When 1 is entered only the peak value will be isolated
        function [peakX, peakY] = isolatePeak(obj)
            maximum = max(obj.DATA(:,2));
            peakIndices = find(obj.DATA(:,2)>1.5*maximum*mean(obj.DATA(:,2)));
            
            peakX = obj.DATA(peakIndices,1);
            peakY = obj.DATA(peakIndices,2);
            
            obj.plot();
            plot(peakX, peakY);
            
        end
        
        % Lowpass filters the signal
        function [lowY] = lowPassFilter(obj, frequency)
           y = obj.DATA(:,2);
           FFT = fft(y);
           FFT(frequency:end) = 0;
           IFFT = ifft(FFT);
           lowY = abs(IFFT);
           
           % Plot result
           obj.plot();
           plot(obj.DATA(:,1), lowY);
        end
    end
    
    methods(Static)
        function measurement = load(path)    
           % Put the text 'Loading ...' on the screen for the impatients
           disp('Loading data ...');
           
           % Start timing
           tic;
           
           fid = fopen(path);
           in = fgetl(fid);
           while(ischar(in))
               
               % Match the file contents 
               % Extract the header
               if ~isempty(strfind(in,'SpectrumHeader'))
                   [SpectrumHeader, in] = SpectrometerMeasurement.readSpectrumHeader(fid);
               end
               
               % Extract the data
               if ~isempty(strfind(in,'Data'))
                  [DATA, ~] = SpectrometerMeasurement.readData(fid);
               end
               
              % Go to the next line in the file
               in = fgetl(fid);
           end
           
           fclose(fid);
           
           % Get the file name
           temp = strsplit(path,'/');
           % Get the file name
           temp = temp{end};
           % Remove the extension
           temp = strsplit(temp,'.');
           % get the name
           name = temp{1};
           
           % Create a new SpectrometerMeasurement object
           measurement = SpectrometerMeasurement(name, SpectrumHeader, DATA);
           
           % Stop timing
           timer = toc;
           
           % Display ready text
           disp(['Loading completed successfully in ',num2str(timer),'ms'])
        end
    end
    
    methods(Static, Access = private)
        function [spectrumHeader, in] = readSpectrumHeader(fid)
            % Create the map spectrumHeader
            spectrumHeader = struct();
            
            % ReadLine
            in = fgetl(fid);
            
            % Loop
            while(in(1) == '#')
                % Split the string
                temp = strsplit(in,';');
                
                % Extract the key
                mapKey = temp{1}(2:end);
                
                % Extract the value
                mapValue = temp{2};
                
                % Fill in the new key and value
                spectrumHeader = setfield(spectrumHeader, mapKey, mapValue);
                
                % Go to next line
                in = fgetl(fid);
            end
        end
        
        function [data, in] = readData(fid)
            data = [];
            
            % Read data
            in = fgetl(fid);
            
            % begin loop
            while(ischar(in))
                % Parse line
                temp = strsplit(in,';');
                
                % Convert to doubles and add to data list
                data = [data;str2double(temp{1}), str2double(temp{2})];
                
                % Go to the next line
                in = fgetl(fid);
                
                % Check for EndOfFIle
                if (strfind(in,'EndOfFile') > 0)
                    break;
                end
            end
        end
    end
    
end

