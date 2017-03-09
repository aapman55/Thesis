function [ crop ] = createDataCube( img,  width, height, vertLoc, horLocs)
%createDataCube

disp('hi')

figure()
imshow(img);
hold on;

    for i = horLocs
        vert = determineRectangle(width, height, vertLoc, i);
        plotRectangle(vert);
    end
    
    for i = 1:length(horLocs)
        vert = determineRectangle(width, height, vertLoc, horLocs(i));
        crop(:,:,:,i) = cropImage(img, vert);
        figure();
        imshow(crop(:,:,:,i))
    end
    
    dCrop = double(crop);
    red = sum(dCrop(:,:,1,:),4);
    green = sum(dCrop(:,:,2,:),4);
    blue = sum(dCrop(:,:,3,:),4);
    
    newImage(:,:,1) = red;
    newImage(:,:,2) = green;
    newImage(:,:,3) = blue;
    
    imagesc(uint8(newImage));
end

function [vertices] = determineRectangle(width, height, vertLoc, horLoc)
    vertices = zeros(4,2);
    vertices(1,:) = [horLoc - width, vertLoc + height/2];
    vertices(2,:) = [horLoc, vertLoc + height/2];
    vertices(3,:) = [horLoc, vertLoc - height/2];
    vertices(4,:) = [horLoc - width, vertLoc - height/2];
end

function plotRectangle(vertices)
    plot([vertices(:,1); vertices(1,1)], [vertices(:,2); vertices(1,2)]);
end

function crop = cropImage(img, vertices)
    startX = min(vertices(:,1));
    endX = max(vertices(:,1));
    startY = min(vertices(:,2));
    endY = max(vertices(:,2));
    
    crop = img(startY:endY, startX:endX, :);
end