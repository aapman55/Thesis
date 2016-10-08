% This script uses the Grating class to make plots
%
clear; close all; clc

% Create a square with a darkened square in the middle
SQ = ones(100,100);
Darkener = zeros(30,60);
SQ(36:65,21:80) = Darkener;

Grating.diffractHorizontally(SQ)