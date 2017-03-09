% The creation of a soft edge response
x=linspace(pi,2*pi,1001);
y = 0.5+cos(x)/2;

figure('position',[0 0 1200 300])
imagesc(y)
colormap gray
axis off

figure('position',[0 0 1200 300])
imagesc([0 0 0 1 1 1 ])
colormap gray
axis off