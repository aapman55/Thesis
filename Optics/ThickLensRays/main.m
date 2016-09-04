% This is the main file
clear; close all; clc;

tl1 = ThickLens(100, 0, 50, inf, 5);

tl1.showRefractionBorders();

for i=-50:5:50
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();