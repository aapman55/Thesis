% This program is used to test the classes Lens and LensObject
clear all; close all; clc; clear classes

figure
L1 = Lens(0.1, 0, 0.5);
O1 = LensObject(-inf,0.065);

L1.setObject(O1);
L1.computeImage();

L1.draw();
grid minor;

L2 = Lens(0.1, 0.25, 0.5);
L2.setObject(L1.computedImage.toObject());
L2.computeImage();
L2.draw();

% L2 = Lens(0.1, 0.45, 0.5);
% L2.setObject(L1.computedImage.toObject());
% L2.computeImage();
% L2.draw();
