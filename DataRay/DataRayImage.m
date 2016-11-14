   
%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================

% DataRayImage For ease of importing and showing data obtained with the
% dataray LCM4

classdef DataRayImage < handle
    
    properties
        data;                   % Contains the data also recorded in the image
        sourceImage;            % The original source image
        bracketedImage;         % The intensity bracketed image
        upperLimit;             % The upper limit for intensity
        lowerLimit;             % The lower limit for intensity
    end
    
    methods(Access = private)
        function obj = DataRayImage(image, data)
           % Fill in the parameters for data
           obj.data = data;      
           
           obj.sourceImage = image;
          
           % Set limits by looking at the smallest and largest number in
           % the gray picture
           obj.upperLimit = max(max(obj.sourceImage));
           obj.lowerLimit = min(min(obj.sourceImage));
                      
           % Put Bracket image as failsafe when someone wants to show the
           % bracketed image
           obj.bracketedImage = obj.sourceImage;
        end
    end
    
    methods
        % Set the upper limit for intensity
        function setUpperlimit(obj, limit)
           obj.upperLimit = limit;
           obj.updateBracketing();
        end
        
        % Set the lower limit for intensity
        function setLowerLimit(obj, limit)
           obj.lowerLimit = limit;
           obj.updateBracketing();
        end
        
        % Update the bracketed image
        function updateBracketing(obj)
            % Get indices to remove
           indicesUp = obj.sourceImage > obj.upperLimit; 
           indicesLo = obj.sourceImage < obj.lowerLimit;
           
           % Remove
           obj.bracketedImage = obj.sourceImage;
           obj.bracketedImage(indicesUp) = obj.upperLimit;
           obj.bracketedImage(indicesLo) = obj.lowerLimit;       
           
        end
        
        % Plot the intensity levels in a histogram
        function h = plotIntensity(obj)
            h = histogram(obj.sourceImage);
        end
        
        % Show the bracketedimage
        function h = showBracketedImage(obj)
            h = imagesc((obj.bracketedImage(:,:,1)));
            colormap('gray');
            axis image;
        end
        
        % Show the bracketedimage
        function h = showOriginalImage(obj)
            h = imagesc((obj.sourceImage(:,:,1)));
            colormap('gray');
            axis image;
        end
        
        % Auto exposure
        function autoExposure(obj)
           meanVal = mean(obj.sourceImage(:));
           stdVal = std(obj.sourceImage(:));
           
            lowLimit = max(meanVal - 3*stdVal, min(obj.sourceImage(:)));
            upLimit = min(meanVal + 3*stdVal, max(obj.sourceImage(:)));
           
           obj.setLowerLimit(lowLimit);
           obj.setUpperlimit(upLimit);
        end
    end
    
    methods(Static)
        % Method to load a picture
        function out = load(path)           
           try
               [ndata, text, ~] = xlsread(path);
           catch
               error('Image could not be read!')
           end
           
           % Retrieve camera type
           cameraString = split(text{5},' = ');
           data.cameraType = cameraString{2};
           
           data.Xpixels = ndata(1,10);
           data.Ypixels = ndata(1,13);
           
           img = ndata(3:end,:);
           
           out = DataRayImage(img, data);
        end
    end  
    
end

