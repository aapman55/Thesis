% This script uses the Grating class to make plots
%
clear; close all; clc

% Create a square with a darkened square in the middle
SQ = ones(100,100);
Darkener = zeros(50,50);
SQ(26:75,26:75) = Darkener;

Grating.diffractHorizontally(SQ)