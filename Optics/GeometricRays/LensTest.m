% This program is used to test the classes Lens and LensObject
clear all; close all; clc

L1 = Lens(0.1, 0, 0.5);
O1 = LensObject(-.3, 0.1);

L1.setObject(O1);
L1.computeImage();

L1.draw();