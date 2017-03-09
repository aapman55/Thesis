% Plot line spread functin
clear; close all; clc;

% Load the 2 images
withf100 = imread('Withf100InBetween.JPG');
withoutf100 = imread('Withoutf100InBetween.JPG');
withoutf100f18 = imread('Withoutf100InBetweenf18.JPG');


% Convert them to grayscale
withf100grayscale = rgb2gray(withf100);
withoutf100grayscale = rgb2gray(withoutf100);
%%
% plot linespread
figure()
hold on;
plot(diff(medfilt1(double(withf100(2100,2300:2500,1)),10)))
plot(medfilt1(double(withf100(2100,2300:2500,1)),10))
% plot(withf100(2100,2300:2500,1))
% plot(diff(withf100(2100,2300:2500,1)))

%%
figure()
hold on
plot(withoutf100grayscale(1900,3500:3700))
plot(withoutf100(1900,3500:3700,1))

%%
figure()
hold on
plot(withoutf100f18(1700,2900:3100,1))
plot(gradient(medfilt1(double(withoutf100f18(1700,2900:3100,1)),10)))
plot(medfilt1(double(withoutf100f18(1700,2900:3100,1)),10))



