clear all; close all; clc;

l1 = Lens(100, 0, 500);
l1.setOrientation(2);
o1 = LensObject(inf, 50);

l1.setObject(o1);
l1.computeImage()

l1.draw()