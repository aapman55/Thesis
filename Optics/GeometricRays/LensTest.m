% This program is used to test the classes Lens and LensObject
clear all; close all; clc

figure
L1 = Lens(0.1, 0, 0.5);
O1 = LensObject(-.1,0.1);

L1.setObject(O1);
L1.computeImage();

L1.draw();

L2 = Lens(0.1, 0.2, 0.5);
L2.setObject(L1.computedImage.toObject());
L2.computeImage();
L2.draw();

% L2 = Lens(0.1, 0.45, 0.5);
% L2.setObject(L1.computedImage.toObject());
% L2.computeImage();
% L2.draw();

grid minor;