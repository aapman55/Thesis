classdef Result < handle
    %RESULT This class takes the spectrum info, canon image and 
    
    properties
        spectrumObject;
        canonImageObject;
        dataRayObject;
    end
    
    methods
        %% ========================
        % Constructor
        %==========================
        function obj = Result(spectrumObject, canonImageObject, dataRayObject)
            obj.spectrumObject = spectrumObject;
            obj.canonImageObject = canonImageObject;
            obj.dataRayObject = dataRayObject;
        end
        
        %% ========================
        % Simultaneous plot with spectrum and color image
        %==========================
        function h = plotImageAndSpectrum(obj, scanLine, twoImagePoints, twoSpectrumWaveLengths)
 
            % Preprocessing spectrumData
            spectrumRange = obj.spectrumObject.DATA(:,1);
            spectrumValue = obj.spectrumObject.DATA(:,2);
            
            % Resize
            lengthImage = size(obj.canonImageObject.currentImage,2);
            flameFrontOffset = twoImagePoints(2)-twoImagePoints(1);

            lengthSpectrum = spectrumRange(end) - spectrumRange(1);
            spectrumOffset = twoSpectrumWaveLengths(2) - twoSpectrumWaveLengths(1);

            scale = (spectrumOffset/lengthSpectrum)/(flameFrontOffset/lengthImage);

            newSpectrumLength = scale*lengthSpectrum;

            % Shift
            imgPercentageLeftOffSet = (twoImagePoints(1)/lengthImage);
            spectrumPercentageLeftOffSet = (twoSpectrumWaveLengths(1) - spectrumRange(1))/newSpectrumLength;

            shift = (imgPercentageLeftOffSet - spectrumPercentageLeftOffSet)*newSpectrumLength;
            
            % Also shift the image in y direction
            percentageYshift = scanLine/size(obj.canonImageObject.currentImage,1);
            
            % Together plot
            x = linspace(spectrumRange(1)-shift, spectrumRange(1)+newSpectrumLength-shift, size(obj.canonImageObject.currentImage,2));
            y = linspace(-percentageYshift*max(spectrumValue), max(spectrumValue), size(obj.canonImageObject.currentImage,1));
            [X,Y] = meshgrid(x,y);

            h = figure();
            outputImage = rot90(obj.canonImageObject.currentImage(:,:,:),0);
            image(X(:),Y(:),outputImage);
            hold on
            plot(spectrumRange, spectrumValue,'color',[1,1,1])
            axis([spectrumRange(1)-shift, spectrumRange(1)+newSpectrumLength-shift, -percentageYshift*max(spectrumValue), max(spectrumValue)])
            axis xy
        end
    end
    
    methods(Static)
        %% ========================================
        % Load the contents of a folder, assuming
        % 1 canon photo, 1 spectrum file and 1
        % dataRayImage (.xlsx file). Although DataRay
        % Image is optional
        %==========================================
        function resultObject = loadFolder(folderPath)
            spectroMeterFiles   = dir([folderPath,'/*.csv']);
            canonFiles          = dir([folderPath,'/*.JPG']);
            dataRayFiles        = dir([folderPath,'/*.xlsx']);
            
            % Error handling
            if (length(spectroMeterFiles) < 1)
                error('No Spectrometer file found! It should be in .csv format!')
            elseif (length(spectroMeterFiles) > 1)
                warning('The folder contains more than one spectrometer file. The first one will be taken!')
            end
            
            if (length(canonFiles) < 1)
                error('No image file found! It should be in .csv format!')
            elseif (length(canonFiles) > 1)
                warning('The folder contains more than one image file. The first one will be taken!')
            end
            
            if (length(dataRayFiles) < 1)
                 warning('No dataRay image data found!')
            end
            
            try
                spectrumObject = SpectrometerMeasurement.load([folderPath,'/',spectroMeterFiles(1).name]);
                canonImageObject = cameraImage([folderPath,'/',canonFiles(1).name]);
                if (length(dataRayFiles) > 1)
                    dataRayObject = DataRayImage.load([folderPath,'/',dataRayFiles(1).name]);
                else
                    dataRayObject = [];
                end
            catch e
                error('Please run Result.install() first!')
            end
            
            resultObject = Result(spectrumObject, canonImageObject, dataRayObject);
            
        end
        
        %% ========================================
        % Add the dependencies folders to the path
        %==========================================
        function install()
            addpath('./DataRay')
            addpath('./Spectrometer')
            addpath('./AnalysesTools')
        end
        %% ========================================
        % Remove the dependencies folders to the path
        %==========================================        
        function uninstall()
            rmpath('./DataRay')
            rmpath('./Spectrometer')
            rmpath('./AnalysesTools')
        end
    end
    
end

