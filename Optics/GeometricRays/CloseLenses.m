% Close lenses test
clear all; close all; clc;
%Unify figure sizes
figSize = [0 0 1500 400];

L1 = Lens(30, 0, 50);
L2 = Lens(20,10, 50);

O1 = LensObject(-50, 20);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject);
L2.computeImage();

figure('position',figSize);
hold on;
grid minor;
L1.draw();
L2.draw();

%%
L1 = Lens(200, 0, 50);
L2 = Lens(200,10, 50);

O1 = LensObject(-inf, 20);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject);
L2.computeImage();

figure('position',figSize);
hold on;
grid minor;
L1.draw();
L2.draw();