% Camera test magnification determination
clear; close all; clc;

%% initial values
sensor.width = 22.3;           % [mm]
sensor.height = 14.9;            % [mm]

USAF.width = 76.2;             % [mm]
USAF.height = 76.2;            % [mm]

% Load test image for photo taken at 55mm focal length
f55 = imread('F55.JPG');

% Load test image for photo taken at 35mm focal length
f35 = imread('F35.JPG');

width = size(f55,2);
height = size(f55,1);

%% USAF Target
% Used to determine the size of the USAF target
USAFimg = imread('USAF.png');
USAFgray = round(rgb2gray(USAFimg)/255);

% The big square is between x:[142 , 175] and y:[62, 96]
figure()
image(USAFimg(62:96,142:175,:));
axis image

USAF.PixelWidth = size(USAFimg,2);
USAF.PixelHeight = size(USAFimg,1);

USAF.squareWidth = length(62:96)/USAF.PixelWidth * USAF.width;
USAF.squareHeight = length(142:175)/USAF.PixelHeight*USAF.height;

%% F55 image
figure();
% Height approximately from 780:1975
% Width approximately from 2350:3550
image(f55);
axis image;
hold on
plot([1,width],[780,780],'color',lines(1))
plot([1,width],[1975,1975],'color',lines(1))
plot([2350,2350],[1,height],'color',lines(1))
plot([3550,3550],[1,height],'color',lines(1))
xlabel('Width [pixels]')
ylabel('Height [pixels]')


F55.heigth = length(780:1975)/height*sensor.height;
F55.width = length(2350:3550)/width*sensor.width


magnificationF55.height = 55/100 * 9.1;
magnificationF55.width = 55/100 * 9.1
