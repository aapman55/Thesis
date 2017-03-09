classdef cameraImage < handle
    %CAMERAIMAGE This class is used as a wrapper for an image taken by a
    %camera. As the image contains EXIF information that might be usefull.
    %The EXIF data that is extracted in this class are the exposure time,
    %ISO value, aperture settings and focal length setting.
    
    properties
        imgData;            % The real image data
        exposure;           % The exposure setting of the image
        ISO;                % The ISO value used
        aperture;           % The aperture setting
        focalLength;        % The focal lenth of the lens
        fullEXIF;           % Full EXIF data
        currentImage;       % This is the image after some manipulations
    end
    
    methods
        %% =========================
        % Constructor
        %=========================
        function obj = cameraImage(filePath)
            %=========================
            % Reading image 
            %=========================
            try
                obj.imgData = imread(filePath);
                obj.currentImage = obj.imgData;
            catch e
                error('Error reading the image!')
            end
            
            %=========================
            % Reading image EXIF data
            %=========================
            try
                imgEXIF = imfinfo(filePath);
                obj.fullEXIF        = imgEXIF;
                obj.exposure        = imgEXIF.DigitalCamera.ExposureTime;
                obj.ISO             = imgEXIF.DigitalCamera.ISOSpeedRatings;
                obj.aperture        = imgEXIF.DigitalCamera.FNumber;
                obj.focalLength     = imgEXIF.DigitalCamera.FocalLength;
            catch e
                warning('Error loading image EXIF data! EXIF data is skipped!')
            end
        end
        %% =========================
        % Show Image
        %=========================
        function show(obj)
           image(obj.currentImage);
        end
        
        %% =========================
        % Show histogram of current image
        %=========================
        function showHist(obj)
           histogram(obj.currentImage);
        end
        %% =========================
        % get Current image
        %=========================
        function out = getCurrent(obj)
           out = obj.currentImage;
        end
        %% =========================
        % horizontal rgb summed line plot
        %=========================
        function HorRGBSummedLinePlot(obj, verticalLoc)
           plot(sum(obj.currentImage(verticalLoc,:,:),3));
        end
        
        %% =========================
        % crop
        % Specify he amount of pixels to crop in each direction
        %=========================
        function crop(obj, left, right, top, down)
           leftIndex = max(left, 1);
           rightIndex = size(obj.currentImage,2) - right;
           topIndex = max(top,1);
           botIndex = size(obj.currentImage,1) - down;
           
           % Error handling
           if (leftIndex > rightIndex)
               error('Check your left or right input!')
           end
           
           if (topIndex > botIndex)
               error('Check your top or down input!')
           end
           
           % Change the image
           obj.currentImage = obj.currentImage(topIndex:botIndex,leftIndex:rightIndex,:);
        end
        
        %% =========================
        % Rotate 90 degrees amount times
        %=========================
        function rot90(obj, amount)
                      
           % Change the image
           obj.currentImage = rot90(obj.currentImage, amount);
        end
        
        %% =========================
        % Rotate 90 degrees amount times
        %=========================
        function rotate(obj, angle)
                      
           % Change the image
           obj.currentImage = imrotate(obj.currentImage, angle);
        end
        
        %% =========================
        % Rotate 90 degrees amount times
        %=========================
        function reflectH(obj)
                      
           % Change the image
           obj.currentImage = flipud(obj.currentImage);
        end
        %% =========================
        % Increase brightness by factor
        %=========================
        function increaseBrightness(obj, factor)
                      
           % Change the image
           obj.currentImage = obj.currentImage*factor;
        end
        %% ============================
        % reset Image
        %==============================
        function reset(obj)
            % Set the original image as current image
            obj.currentImage = obj.imgData;
        end
    end
    
end

