% main file
linesPermm = 1200;

slit1 = Slit(1/linesPermm*1E-3,2, 1);
case1 = slit1.shineLight(692E-9, -4:0.001:4);

slit2 = Slit(1/linesPermm*1E-3, 8, 1);
case2 =slit2.shineLight(692E-9, -4:0.001:4);

slit3 = Slit(1/linesPermm*1E-3, 16, 1);
case3 =slit3.shineLight(692E-9, -4:0.001:4);

slit4 = Slit(1/linesPermm*1E-3, 32, 1);
case4 =slit4.shineLight(692E-9, -4:0.001:4);

slit5 = Slit(1/linesPermm*1E-3, 64, 1);
case5 =slit5.shineLight(692E-9, -4:0.001:4);

slit6 = Slit(1/linesPermm*1E-3, 128, 1);
case6 =slit6.shineLight(692E-9, -4:0.001:4);

%%
slit7 = Slit(1/1200*1E-3, 4096, 1);
case7 =slit7.shineLight(692E-9, -4:0.005:4);