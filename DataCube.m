classdef DataCube < handle
    %DataCube This class contains a datacube.
    
    properties
        img;            % Contains the original image
        cube;
        grayScaleCube;
        wavelengths;    % The wavelengths corresponding to the cube elements (in the same order)
        vertices;
        zerothOrderVert;
    end
    
    methods
        function obj = DataCube(img, cube, wavelengths, vertices, zerothOrderVert)
            obj.cube = cube;
            obj.img = img;
            obj.wavelengths = wavelengths;
            obj.vertices = vertices;
            obj.zerothOrderVert = zerothOrderVert;
            obj.grayScaleCube = zeros(size(cube,1), size(cube,2), size(cube,4));
            
            for i = 1:size(obj.cube,4)
                obj.grayScaleCube(:,:,i) = rgb2gray(uint8(cube(:,:,:,i)));
            end
        end
        
        % Merges all slices of all the wavelengths and plot the resulting
        % image.
        function mergeAndPlot(obj)
            
            red = sum(obj.cube(:,:,1,:),4);
            green = sum(obj.cube(:,:,2,:),4);
            blue = sum(obj.cube(:,:,3,:),4);

            newImage(:,:,1) = red;
            newImage(:,:,2) = green;
            newImage(:,:,3) = blue;
            
            imagesc(rgb2gray(uint8(newImage))); 
            axis xy;
            axis image;
            
        end
        
        % This function plots the cube slices for each wavelength
        function h = visualiseSlices(obj)
            h = figure();
            hold on
            for i=1:length(obj.wavelengths)
                obj.plot3DUnitImage(obj.wavelengths(i), uint8(obj.cube(:,:,:,i)));
            end
            alpha(.7)
            ylabel('Wavelength [nm]')
            view(3)
            set(gca,'XTickLabel','','ZTickLabel','')
            grid minor
        end
        
        function h = VisualiseLocations(obj)
            h = figure();            
            imshow(obj.img);
            hold on
            
            if (~isempty(obj.zerothOrderVert))
                obj.plotRectangle(obj.zerothOrderVert);
            end
            
            for i = 1:size(obj.vertices,3)
                obj.plotRectangle(obj.vertices(:,:,i));
            end
        end
        
        function plotZerothOrder(obj)
            if(isempty(obj.zerothOrderVert))
                error('No location for the zeroth order provided!');
            end
            
            % Get the image
            croppedImg = DataCube.cropImage(obj.img, obj.zerothOrderVert);

            imagesc(rgb2gray(croppedImg));
        end
        
        % Plot the spectrum at the location XY
        function plotXY(obj, X, Y)           
            
%            red = squeeze(obj.cube(Y,X,1,:));
%            green = squeeze(obj.cube(Y,X,2,:));
%            blue = squeeze(obj.cube(Y,X,3,:));
%            
%            maximum = max(red+green+blue);
%            
%            bar(obj.wavelengths, (red+green+blue)/maximum)
           bars = squeeze(obj.grayScaleCube(Y,X,:));
           bar(obj.wavelengths,bars/max(bars));
        end
        
        function handleList = plotFramesSeparate(obj)
            handleList = [];
            for i = 1:size(obj.cube,4)
                h = figure();
                imagesc(uint8(obj.cube(:,:,:,i)));
                set(gca,'YTick',[],'XTick',[])
                axis image
                axis xy
%                 xlabel([num2str(obj.wavelengths(i)),' nm'])
                handleList = [handleList; h];
            end
        end
    end
    
    % These methods are only helper methods. Users should not be bothered
    % with them
    methods(Access = private)
        % This method plots the rectangle created by the vertices
        function plotRectangle(~, vert)
                plot([vert(:,1); vert(1,1)], [vert(:,2); vert(1,2)],'color','white','linewidth',2);
        end
        
        % Maps an image to a square in 3D space
        function plot3DUnitImage(~, Y, img)
            xImage = [-0.5 0.5; -0.5 0.5];   %# The x data for the image corners
            yImage = [Y Y; Y Y];             %# The y data for the image corners
            zImage = [0.5 0.5; -0.5 -0.5];   %# The z data for the image corners
            surf(xImage,yImage,zImage,...    %# Plot the surface
                 'CData',img,...
                 'FaceColor','texturemap');
        end
    end
    
    % These static methods are used to initiaite and create a datacube.
    % This should be the way to create a datacube and not touching the
    % constructor yourself.
    methods(Static)
        % This method creates the datacube.
        function dataCube = createDataCube( img,  width, height, vertLoc, horLocs, wavelengths, zerothOrderLoc) 
            if (exist('zerothOrderLoc','var'))
                zeroOrder = DataCube.determineRectangle(width, height, vertLoc, zerothOrderLoc);
            else
                zeroOrder = [];
            end
            
            
            
            if (length(horLocs) ~= length(wavelengths))
                error('The amount of horizontal locations should correspond to the amount of wavelengths!')
            end
            
            for i = 1:length(horLocs)
                vert(:,:,i) = DataCube.determineRectangle(width, height, vertLoc, horLocs(i));
                crop(:,:,:,i) = DataCube.cropImage(img, vert(:,:,i));
            end

            dCrop = double(crop);  
            dataCube = DataCube(img, dCrop, wavelengths, vert, zeroOrder);
        end
        
        % This is a helper method to calculate the vertices of each
        % rectangle.
        function [vertices] = determineRectangle(width, height, vertLoc, horLoc)
            vertices = zeros(4,2);
            vertices(1,:) = [horLoc - width, vertLoc + height/2];
            vertices(2,:) = [horLoc, vertLoc + height/2];
            vertices(3,:) = [horLoc, vertLoc - height/2];
            vertices(4,:) = [horLoc - width, vertLoc - height/2];
        end
 
        % This method crops the area defined by the vertices out of the
        % original image
        function crop = cropImage(img, vertices)
            startX = min(vertices(:,1));
            endX = max(vertices(:,1));
            startY = min(vertices(:,2));
            endY = max(vertices(:,2));

            crop = img(startY:endY, startX:endX, :);
        end
    end
    
end

