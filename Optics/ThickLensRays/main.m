% This is the main file
clear; close all; clc;

lr1 = LightRay(Vector2d(-2,1), Vector2d(1, 0));

rb1 = RefractionBorder(Vector2d(0,1), Vector2d(0,-1), 1, 1.5);

rb1.hasCollision(lr1)