function [ do,di,M ] = calculateDIM( f )
%calculateDIM calculates the image distance and the magnification factor
%with a known focal length and varying object distance.

calcDI = @(do) 1./(1./f-1./do);

do = 1.1*f:0.01*f:4*f;

di = calcDI(do);

M = di./do;

figure
plotyy(do,M,do,di);
hold on
title(['f = ',num2str(f*1000),' mm'])
xlabel(' do [m]')
ylabel('Magnification');
grid minor;


end

