% This is the main file
clear; close all; clc;
%%
tl1 = ThickLens(50, -4, inf, 50, 3);

% tl1.showRefractionBorders();

for i=-12:2:12
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(50, 5, 50, inf, 3);

% tl1.showRefractionBorders();

for i=-12:2:12
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(50, -5, inf, 50, 3);

% tl1.showRefractionBorders();
direction = Vector2d(1, 0);

for i=-20:20
    lr1 = LightRay(Vector2d(-100,0), direction.rotate(i));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(50, 4, 50, inf, 3);

% tl1.showRefractionBorders();
direction = Vector2d(1, 0);

for i=-20:20
    lr1 = LightRay(Vector2d(-100,0), direction.rotate(i));
    tl1.addLightRay(lr1);
end

tl1.drawRays();

%%
tl1 = ThickLens(50, 0, inf, 50, 3);
direction = Vector2d(1, 0);
% tl1.showRefractionBorders();

for i=-40:2:10
    lr1 = LightRay(Vector2d(-50,i), direction.rotate(20));
    tl1.addLightRay(lr1);
end

tl1.drawRays();
