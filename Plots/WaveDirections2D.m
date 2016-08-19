clear; close all; clc

resolution = 0:1000;

[X,Y] = meshgrid(resolution,resolution);

wave = @(u, v, shift) exp(2*pi*1i*(u*X/length(resolution)+v*Y/length(resolution)+shift));

h = figure('position',[0 0 500 500]);
% get the figure and axes handles
hFig = gcf;
hAx  = gca;

% set the axes to full screen
set(hAx,'Unit','normalized','Position',[0 0 1 1]);

hold on

counter = 0;
for j = 2:-1:-2
    for i = -2:2
        counter = counter + 1;
        subplot(5,5,counter)
        imagesc(real(wave(i,j,0.25)))
        xlabel(['Fh = ',num2str(i),' Fv = ',num2str(j)])
        colormap gray; axis image;
        set(gca,...
        'XTick','', ...
        'YTick','', ...
        'ZTick','',...
        'fontsize',14)
    end
end
