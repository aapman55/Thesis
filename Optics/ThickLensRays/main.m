% This is the main file
clear; close all; clc;

tl1 = ThickLens(50, -23.51, inf, 50, 5);

% tl1.showRefractionBorders();

for i=-24:2:24
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(50, 10, 50, inf, 5);

% tl1.showRefractionBorders();

for i=-10:2:10
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(100, 0, inf, 70, 5);

% tl1.showRefractionBorders();
direction = Vector2d(1, 0);

for i=-10:10
    lr1 = LightRay(Vector2d(-120,0), direction.rotate(i));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(100, 0, 70, inf, 5);

% tl1.showRefractionBorders();
direction = Vector2d(1, 0);

for i=-10:10
    lr1 = LightRay(Vector2d(-147,0), direction.rotate(i));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(100, -23.51, inf, 70, 5);
direction = Vector2d(1, 0);
% tl1.showRefractionBorders();

for i=-55:5:10
    lr1 = LightRay(Vector2d(-100,i), direction.rotate(20));
    tl1.addLightRay(lr1);
end

tl1.drawRays();
