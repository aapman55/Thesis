% This is the main file
clear; close all; clc;
%%
tl1 = ThickLens(50, -4, inf, 50, 3);
tl1.translateY(50)
% tl1.showRefractionBorders();

for i=26:2:74
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays(true);

%%
tl1 = ThickLens(50, 5, 50, inf, 3);

% tl1.showRefractionBorders();

for i=-24:2:24
    lr1 = LightRay(Vector2d(-100,i), Vector2d(1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays(false);

%%
tl1 = ThickLens(50, -5, inf, 50, 3);

% tl1.showRefractionBorders();
direction = Vector2d(1, 0);

for i=-24:24
    lr1 = LightRay(Vector2d(-100,0), direction.rotate(i));
    tl1.addLightRay(lr1);
end

tl1.drawRays(true);

%%
tl1 = ThickLens(50, 4, 50, inf, 3);

% tl1.showRefractionBorders();
direction = Vector2d(1, 0);

for i=-24:24
    lr1 = LightRay(Vector2d(-100,0), direction.rotate(i));
    tl1.addLightRay(lr1);
end

tl1.drawRays(true);

%%
tl1 = ThickLens(50, 0, inf, 50, 3);
tl1.translateY(10)
direction = Vector2d(1, 0);
% tl1.showRefractionBorders();

for i=-40:2:10
    lr1 = LightRay(Vector2d(-50,i), direction.rotate(20));
    tl1.addLightRay(lr1);
end

tl1.drawRays(true);

%% Reversed direction
tl1 = ThickLens(50, 5, 50, inf, 3);
tl1.translateY(0)
% tl1.showRefractionBorders();

for i=-12:2:12
    lr1 = LightRay(Vector2d(100,i), Vector2d(-1, 0));
    tl1.addLightRay(lr1);
end

tl1.drawRays(true);

%% 4f system

tl1 = ThickLens(50, 5, 50, inf, 3);
tl2 = ThickLens(50, -195, inf, 50, 3);

% tl1.showRefractionBorders();

for i=-24:2:24
    lr1 = LightRay(Vector2d(100,i), Vector2d(-1, 0));
    tl1.addLightRay(lr1);
end

for i=1:length(tl1.outGoingRayList)
    tl2.addLightRay(tl1.outGoingRayList(i));
end

tl1.drawRays(true);
tl2.drawRays(false);

%% 4f system

tl1 = ThickLens(50, 5, inf, 50, 3);
tl2 = ThickLens(50, -195, 50, inf, 3);

% tl1.showRefractionBorders();

for i=-24:2:24
    lr1 = LightRay(Vector2d(100,i), Vector2d(-1, 0));
    tl1.addLightRay(lr1);
end

for i=1:length(tl1.outGoingRayList)
    tl2.addLightRay(tl1.outGoingRayList(i));
end

tl1.drawRays(true);
tl2.drawRays(false);