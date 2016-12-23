% Point spread main
% Load image
% im = imread('SpAExpCorrect.png');
% 
% imshow(im)
% axis on
% 
% plot(im(100,:,1))

%% Plot Gauss
close all; clear;clc;

% Define fontsize
fontsize = 15;

N = 3.0;
x=linspace(-N, N);
y=x;
[X,Y]=meshgrid(x,y);
z=(1000/sqrt(2*pi).*exp(-(X.^2/2)-(Y.^2/2)));

maxZ = max(max(z));

% normalise z
z = z/maxZ;


% Plot 2D
figure('position',[0 0 800 600])
imagesc(x,y,z)
cbar = colorbar;
axis image
xlabel('x-direction [-]')
ylabel('y-direction [-]')
set(gca,'fontsize',fontsize)
hold on
plot(x,zeros(size(x)),'k')


% Colorbar
set(cbar,'fontsize',fontsize)
ylabel(cbar,'Intensity [-]')


% Plot 3D
figure('position',[0 0 800 600])
h = surf(X,Y,z);
shading interp
set(h, 'edgecolor','k')
axis tight
xlabel('x-direction [-]')
ylabel('y-direction [-]')
zlabel('Intensity [-]')
set(gca,'fontsize',fontsize)


% Plot 1D
figure('position',[0 0 800 600])
plot(x,z(:,end/2))
xlabel('x-direction [-]')
ylabel('Intensity [-]')
grid minor
set(gca,'fontsize',fontsize)

% Plot 1D ideal case
figure('position',[0 0 800 600])
idealX = -3:0.01:3;
idealY = idealX == 0;
plot(idealX,idealY)
xlabel('x-direction [-]')
ylabel('Intensity [-]')
grid minor
set(gca,'fontsize',fontsize)

%%
% close all;

gaussStamp = z(:,end/2)';

% startpoints = [0, 0.5, 1.0, 1.5];
% startpoints = [0, 1, 2, 3];
startpoints = [0, 0.25, .5, .75];


totalLength = 1;

X = linspace(min(startpoints),max(startpoints)+totalLength, ((max(startpoints)-min(startpoints))+1)*totalLength*length(gaussStamp));

Y = zeros(1,length(X));

indexfinder = 1:length(X);

for i = startpoints
    index = indexfinder(X >= i);
    Y(index(1):index(1)+length(gaussStamp)-1) = Y(index(1):index(1)+length(gaussStamp)-1) + gaussStamp;
end

% normalise Y
Y = Y/max(Y);

% Stretch in Z direction
Z = [0,1];

Y = [Y;Y];

figure;
imagesc(X,Z,1-Y)
colormap('gray')