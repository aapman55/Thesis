% This is the main file
clear; close all; clc;





tl1 = ThickLens(100, 0, inf, 50, 5);

for i=0:2:44
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();