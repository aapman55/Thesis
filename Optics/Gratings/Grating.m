%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This can be used freely as long as this
% credits text remains.
%=========================================
%
% Grating Diffraction grating, diffract a pattern of white light into the
% visible spectrum
%
classdef Grating
    
    properties
        normalisedPic
    end
    
    methods(Static)
        
        function picture = diffractHorizontally(inputImage)
            % Set some default values (further versions might include the
            % posibility to change these values)
            amountOfColors = 500;
            percentageShift = 0.5;
            
            % Check if the input image is a double matrix
            if(~isa(inputImage, 'double'))
                error('The input Image needs to be a numerical matrix!')
            end
            
            % Checks if the input image is a 2-dimensional matrix
            if (ndims(inputImage) ~= 2)
                error('Please provide a 2 dimensional pattern!')
            end
            
            % Check for zero dimensions
            if (numel(inputImage) == 0)
                error('Input Image contains a dimension with length 0!');
            end
            
            % Number of Colors (defaults to 500)
            % Get colors
            colors = hsv(amountOfColors*1.25)';
            colors = colors(:,1:amountOfColors);
            
            % Turn input image into matrix containing only ones and zeros
            booleanImage = inputImage > 0;
            
            % Determine height of drawingBoard
            drawingBoardHeight = size(booleanImage, 1);
            
            % Determine pixelshift per color
            pixelShiftPerColor = ceil(percentageShift/100 * size(booleanImage, 2));
            
            % Determine width of drawingboard
            drawingBoardWidth = pixelShiftPerColor * amountOfColors + size(booleanImage, 2);
            
            % Create drawingboard
            drawingBoard = zeros(drawingBoardHeight, drawingBoardWidth, 3);
            
            % Loop over drawing board and add each color
            for i = 1 : length(colors) - 1
               % determine begin and end indices
               beginIndex = (i - 1) * pixelShiftPerColor + 1;
               endIndex = beginIndex + size(booleanImage, 2) - 1;
               
               % Add RGB values to the drawingBoard
               drawingBoard(:,beginIndex:endIndex, 1) = drawingBoard(:,beginIndex:endIndex, 1) + colors(1, i).*booleanImage;
               drawingBoard(:,beginIndex:endIndex, 2) = drawingBoard(:,beginIndex:endIndex, 2) + colors(2, i).*booleanImage;
               drawingBoard(:,beginIndex:endIndex, 3) = drawingBoard(:,beginIndex:endIndex, 3) + colors(3, i).*booleanImage;
            end
            
            % normalise picture
            minimum = min(min(min(drawingBoard)));
            maximum = max(max(max(drawingBoard)));
            
            normalisedPic = drawingBoard/(maximum-minimum);
            
            figure();
            imagesc(normalisedPic);
            
            picture = normalisedPic;
        end
    end
    
end

