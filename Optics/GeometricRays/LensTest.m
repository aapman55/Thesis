% This program is used to test the classes Lens and LensObject
clear all; close all; clc

figure
L1 = Lens(0.1, 0, 0.5);
O1 = LensObject(-.15, 0.1);

L1.setObject(O1);
L1.computeImage();

L1.draw();

L2 = Lens(0.1, L1.computedImage.x+0.15, 0.5);
O2 = LensObject(L1.computedImage.x,L1.computedImage.height);

L2.setObject(O2);
L2.computeImage();

L2.draw();
grid minor;