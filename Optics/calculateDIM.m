function [ do,di,M ] = calculateDIM( f )
%calculateDIM calculates the image distance and the magnification factor
%with a known focal length and varying object distance.

calcDI = @(do) 1./(1./f-1./do);

do = 1.1*f:0.01*f:4*f;

di = calcDI(do);

M = di./do;

figure('position',[0 0 800 600])
[AX,H1,H2] = plotyy(do,M,do,di);
hold on
title(['f = ',num2str(f*1000),' mm'])
xlabel('Object distance (d_o) [m]')
grid minor;
HL = legend('Magnification',' Image distance');

set(HL, 'fontsize' , 14);

set(AX,{'ycolor'},{'k';'k'})
set(get(AX(1),'Ylabel'),'String','Magnification')
set(get(AX(2),'Ylabel'),'String','Image distance (d_i) [m]') 

set(H1,'linestyle','-','color',' k','linewidth',2); 
set(H2,'linestyle','--','color',lines(1),'linewidth',2); 

set(AX,'fontsize', 14)
end

