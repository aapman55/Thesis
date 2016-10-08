%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
classdef SensicamImage < handle

    
    properties
        sourceImage;            % The original source image
        bracketedImage;         % The intensity bracketed image
        upperLimit;             % The upper limit for intensity
        lowerLimit;             % The lower limit for intensity
    end
    
    methods(Access = private)
        function obj = SensicamImage(image)
           % Compress the RGB values gray
           obj.sourceImage = rgb2gray(image);
           
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
    end
    
    methods(Static)
        % Method to load a picture
        function out = load(path)           
           try
               img = imread(path);
           catch
               error('Image could not be read!')
           end
           
           out = SensicamImage(img);
        end
    end
    
end

