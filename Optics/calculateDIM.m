function [ do,di,M, AX, H1, H2 ] = calculateDIM( f, variant )
%calculateDIM calculates the image distance and the magnification factor
%with a known focal length and varying object distance.

calcDI = @(do) 1./(1./f-1./do);

if (variant==1)
    do = 1.1*f:0.01*f:4*f;
else
    do = 0:0.01*f:4*f;
end

di = calcDI(do);

M = -di./do;

figure('position',[0 0 1200 600])
[AX,H1,H2] = plotyy(1000*do,M,1000*do,1000*di);
hold on

title(['f = ',num2str(f*1000),' mm'])
xlabel('Object distance (d_o) [mm]')
grid minor;
HL = legend('Magnification',' Image distance','location','northeast');
ylim(AX(2),[-5*f*1000 5*f*1000]);
ylim(AX(1),[-5 5]);
set(HL, 'fontsize' , 14);

set(AX,{'ycolor'},{'k';'k'})
set(get(AX(1),'Ylabel'),'String','Magnification')
set(get(AX(2),'Ylabel'),'String','Image distance (d_i) [mm]') 
set(AX(1),'Ytick',-5:5)
set(AX(2),'Ytick',-5*f*1000:100:5*f*1000)

set(H1,'linestyle','-','color',' k','linewidth',2); 
set(H2,'linestyle','--','color',lines(1),'linewidth',2); 

set(AX,'fontsize', 14)
end

