% Test for line detection with Hough

im = imread('charmander.png');

edge(im(:,:,1),'canny')