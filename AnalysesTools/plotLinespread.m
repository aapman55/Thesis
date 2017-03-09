function [ handle ] = plotLinespread( img , direction, pivotLine, range, fontsize)
%plotLineSpread is a function that takes a target image that has been
%specifically made for the purpose of determining the linespread function.

% Convert the image to grayscale when the image is RGB
if(isRGB(img))
    img = rgb2gray(img);
end

% Parse direction Should be 'v', or 'h' for vertical or horizontal
switch direction
    case 'v'
        X = range;
        Y = pivotLine;
        picX = X;
        picY = Y;
        cutOut = img(picX,picY)';
    case 'h'
        X = pivotLine;
        Y = range;
        picX = X;
        picY = Y;
        cutOut = img(picX,picY);
    otherwise
        error('The direction must either by v or h!')
end

linespread = diff(smooth(double(img(X,Y))));

% Create figures
handle = figure();
subplot(2,1,2)
% plot(picX,img(X,Y));
plot(picX,double(img(X,Y))/double(max(img(X,Y))));
hold on
plot(picX(1:end-1),linespread/max(linespread))


xlabel('Pixels [-]')
ylabel('Intensity/change in intensity [-]')
% set(get(ax(1),'Ylabel'),'String','Intensity [-]')
% set(get(ax(2),'Ylabel'),'String','Change in intensity [-]') 
lh = legend('Edge response (Intensity)','Change in intensity','location','northeast');
set(lh,'fontsize',fontsize)
grid on
ticks = get(gca,'XTick');
set(gca,'Xtick',round(linspace(ticks(1),ticks(end),6)));
set(gca,'fontsize',fontsize)
ylim([-0.1 1.1])

subplot(2,1,1)
imagesc(picX, picY,cutOut);
colormap('gray');
xlabel('Pixels [-]')
ylabel('Pixels [-]')
set(gca,'Ytick',picY)
set(gca,'Xtick',round(linspace(ticks(1),ticks(end),6)));
set(gca,'fontsize',fontsize)
end

function bool = isRGB(img)
    bool = size(img,3) == 3;
end