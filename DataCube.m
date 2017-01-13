classdef DataCube < handle
    %DataCube This class contains a datacube.
    
    properties
        img;            % Contains the original image
        cube;
    end
    
    methods
        function obj = DataCube(img, cube)
            obj.cube = cube;
            obj.img = img;
        end
        
        function h = mergeAndPlot(obj)
            
            red = sum(obj.cube(:,:,1,:),4);
            green = sum(obj.cube(:,:,2,:),4);
            blue = sum(obj.cube(:,:,3,:),4);

            newImage(:,:,1) = red;
            newImage(:,:,2) = green;
            newImage(:,:,3) = blue;
            
            h = figure();
            imagesc(uint8(newImage)); 
            axis xy;
            axis image;
            
        end
    end
    
    % These static methods are used to initiaite and create a datacube.
    % This should be the way to create a datacube and not touching the
    % constructor yourself.
    methods(Static)
        % This method creates the datacube.
        function dataCube = createDataCube( img,  width, height, vertLoc, horLocs) 
            figure()
            imshow(img);
            hold on;

                for i = horLocs
                    vert = DataCube.determineRectangle(width, height, vertLoc, i);
                    DataCube.plotRectangle(vert);
                end

                for i = 1:length(horLocs)
                    vert = DataCube.determineRectangle(width, height, vertLoc, horLocs(i));
                    crop(:,:,:,i) = DataCube.cropImage(img, vert);
                    figure();
                    imshow(crop(:,:,:,i))
                end

                dCrop = double(crop);  
                dataCube = DataCube(img, dCrop);
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
        
        % This method plots the rectangle created by the vertices
        function plotRectangle(vertices)
            plot([vertices(:,1); vertices(1,1)], [vertices(:,2); vertices(1,2)]);
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

