% This file makes the plots used in the thesis report
clear; close all; clc;
% Low pass
FourierPlaneFilter('square.bmp','filter','lowpass','top',0,'bot',0,'left',45,'right',45)

% Highpass
FourierPlaneFilter('square.bmp','filter','highpass','top',0,'bot',0,'left',45,'right',45)