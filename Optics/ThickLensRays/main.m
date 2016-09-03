% This is the main file
clear; close all; clc;





tl1 = ThickLens(100, 0, 100, 100, 5);

for i=0:2:20
    lr1 = LightRay(Vector2d(-50,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();