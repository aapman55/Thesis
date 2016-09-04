% This is the main file
clear; close all; clc;

tl1 = ThickLens(100, -23.51, inf, 70, 5);

% tl1.showRefractionBorders();

for i=-45:5:45
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(100, 23.51, 70, inf, 5);

% tl1.showRefractionBorders();

for i=-45:5:45
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(100, 0, 70, inf, 5);

% tl1.showRefractionBorders();
direction = Vector2d(1, 0);

for i=-20:5:20
    lr1 = LightRay(Vector2d(-50,0), direction.rotate(i));
    tl1.addLightRay(lr1);
end

tl1.drawRays();