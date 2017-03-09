clear all; close all; clc;
Result.install
fontSize = 12;
%% Linespread Thorlabs
xloc = 1200;
yRange = 1500:1550;
thorlabsLinespread = Result.loadFolder('FinalReportFigs/ThorlabsLineSpread');
figure()
thorlabsLinespread.canonImageObject.reset();
thorlabsLinespread.canonImageObject.show;
hold on
ylimit = ylim;
xlimit = xlim;
plot([xloc, xloc],[1, ylimit(2)],'color','white','linewidth',1)
plot([1, xlimit(2)],[yRange(1), yRange(1)],'color','white','linewidth',1)
plot([1, xlimit(2)],[yRange(end), yRange(end)],'color','white','linewidth',1)
plot([4581, 4581],[1, ylimit(2)],'color','red','linewidth',1)
plot([4954, 4954],[1, ylimit(2)],'color','red','linewidth',1)
xlabel('Pixels [-]')
ylabel('Pixels [-]')
set(gca,'XTick',[0 1000 2000 3000 4000 5000]);
set(gca,'YTick',[0 1000 2000 3000 ]);
set(gca,'fontsize',fontSize);

plotLinespread(thorlabsLinespread.canonImageObject.getCurrent,'v',xloc,yRange, fontSize);
%% Linespread Ibsen
xloc = 3000;
yRange = 2400:2600;
canonImage = cameraImage('FinalReportFigs/IbsenLinespread/LinespreadF55.JPG');
img = canonImage.getCurrent;
figure()
canonImage.show;
hold on
ylimit = ylim;
xlimit = xlim;
plot([xloc, xloc],[1, ylimit(2)],'color','white','linewidth',1)
plot([1, xlimit(2)],[yRange(1), yRange(1)],'color','white','linewidth',1)
plot([1, xlimit(2)],[yRange(end), yRange(end)],'color','white','linewidth',1)
xlabel('Pixels [-]')
ylabel('Pixels [-]')
set(gca,'XTick',[0 1000 2000 3000 4000 5000]);
set(gca,'YTick',[0 1000 2000 3000 ]);
set(gca,'fontsize',fontSize);
plotLinespread(img(:,:,3),'v',xloc,yRange, fontSize)
%% Spectrometer validation
spectrometer1 = Result.loadFolder('FinalReportFigs/Spectrometer/1');
%==============================================================================
% Only used in the presentation figures
% indices = spectrometer1.spectrumObject.DATA(:,1)>586 & spectrometer1.spectrumObject.DATA(:,1)<592;
% indices2 = spectrometer1.spectrumObject.DATA(:,1)>580 & spectrometer1.spectrumObject.DATA(:,1)<586;
% spectrometer1.spectrumObject.DATA(indices,2) = spectrometer1.spectrumObject.DATA(indices2,2);
%==============================================================================
spectrometer1.canonImageObject.reflectH
h = spectrometer1.plotImageAndSpectrum(160,[228, 591] , [460,520],[0,0.8,0.8]);
set(h,'position',[0 0 900 800])
set(gca,'fontsize',14)
grid minor
xlabel('Wavelength [nm]')
ylabel('Normalised intensity [-]')
%% Spectrometer validation
spectrometer2 = Result.loadFolder('FinalReportFigs/Spectrometer/2');
spectrometer2.canonImageObject.reflectH
h = spectrometer2.plotImageAndSpectrum(130,[570, 798] , [400,500], [0, .8, .8]);
set(h,'position',[0 0 900 800])
set(gca,'fontsize',14)
grid minor
xlabel('Wavelength [nm]')
ylabel('Normalised intensity [-]')
%% The steady flame no pipe extension
steadyNoPipe = Result.loadFolder('FinalReportFigs/steadyFlameNoPipe');
% ======================================
% For presentation only
% ======================================
index = steadyNoPipe.spectrumObject.DATA(:,1) > 588.15 & steadyNoPipe.spectrumObject.DATA(:,1) < 588.25;
steadyNoPipe.spectrumObject.DATA(index,2) = 0;
steadyNoPipe.canonImageObject.rotate(180);
steadyNoPipe.canonImageObject.crop(0,0,1500,1500)
steadyNoPipe.canonImageObject.increaseBrightness(1.5)
h = steadyNoPipe.plotImageAndSpectrum(160,[2835, 3715] , [431.1,563.4],'white');
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)

% DataRay camera
figure('position',[0 0 900 800])
steadyNoPipe.dataRayObject.showBracketedImage;
axis xy;
xlabel('Pixels [-]')
ylabel('Pixels [-]')
set(gca,'fontsize',fontSize)

% DataRay histogram
figure('position',[0 0 900 800])
steadyNoPipe.dataRayObject.plotIntensity
axis tight
grid minor
xlabel('Pixel intensity [-]')
ylabel('Amount [-]');
set(gca,'fontsize',fontSize)

figure('position',[0 0 900 800])
steadyNoPipe.dataRayObject.setUpperlimit(7000)
steadyNoPipe.dataRayObject.setLowerLimit(750)
steadyNoPipe.dataRayObject.showBracketedImage
axis xy;
xlabel('Pixels [-]')
ylabel('Pixels [-]')
set(gca,'fontsize',fontSize)

steadyNoPipe.dataRayObject.reset();
steadyNoPipe.dataRayObject.setUpperlimit(7000)
steadyNoPipe.dataRayObject.setLowerLimit(400)
newIm = histogramEquilisation(steadyNoPipe.dataRayObject.bracketedImage, 2^16);
figure();
imagesc(newIm); 
colormap('gray'); 
axis image; 
axis xy;

%% With pipe no plate no rod
pipeClean = Result.loadFolder('FinalReportFigs/Pipeclean');
pipeClean.canonImageObject.crop(0,0,1200,1200)
pipeClean.canonImageObject.increaseBrightness(1.2)
h = pipeClean.plotImageAndSpectrum(0,[3540, 4494] , [431.1,563.4], 'white');
% view(90,90)
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)
%% With pipe With plate
pipePlate = Result.loadFolder('FinalReportFigs/pipePlate');
pipePlate.canonImageObject.increaseBrightness(1.2)
h = pipePlate.plotImageAndSpectrum(1000,[3212, 3481] , [431.1,473.5], 'white');
% view(90,90)
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)

% Edge detection with RGB
img = pipePlate.canonImageObject.getCurrent;
lineHeight = 1850;
plotLine = double(img(lineHeight,:,1)) + double(img(lineHeight,:,2)) + double(img(lineHeight,:,3));
plot(plotLine)
hold on
plot(rgb2gray(img(lineHeight,:,:)))
%% With pipe With plate 2
pipePlate2 = Result.loadFolder('FinalReportFigs/pipePlate2');
pipePlate2.canonImageObject.rotate(1)
pipePlate2.canonImageObject.crop(0, 0, 1200, 800)
pipePlate2.canonImageObject.increaseBrightness(1.5)
pipePlate2.canonImageObject.show
h = pipePlate2.plotImageAndSpectrum(1200,[3258, 3537] , [431.1,473.5], 'white');
% view(90,90)
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)

%% With pipe V-flame
vFlame = Result.loadFolder('FinalReportFigs/Vflame');
vFlame.canonImageObject.rotate(-2.5);
vFlame.canonImageObject.crop(0,0, 1400, 1400);
vFlame.canonImageObject.increaseBrightness(1.2)
h = vFlame.plotImageAndSpectrum(300,[3297, 3859] , [431.1,516.4], 'white');
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)


% create datacube
vFlame.canonImageObject.reset();
vFlame.canonImageObject.rotate(-2.0);
vFlame.canonImageObject.crop(0,0, 1400, 1400);
vFlame.canonImageObject.increaseBrightness(1);
cube = DataCube.createDataCube(vFlame.canonImageObject.getCurrent,...
                                150, 150, 314, ...
                                [3320, 3547, 3848, 4181, 4595],...
                                [431.1, 473.5, 516.4, 563.4, 618.8],...
                                734);
% cube = DataCube.createDataCube(vFlame.canonImageObject.getCurrent,...
%                                 150, 150, 314, ...
%                                 [3284, 3547, 3848, 4181, 4595],...
%                                 [431.1, 473.5, 516.4, 563.4, 618.8],...
%                                 734);
% Figure for the locations                            
cube.VisualiseLocations;

% Figure for separate plots
HL = cube.plotFramesSeparate;
figure
cube.plotZerothOrder();
set(gca,'YTick',[],'XTick',[]);
axis image
axis xy

% Figure to show the bar plot with spectrum
figure('position',[0 0 1200 300])
cube.plotXY(30,30)
hold on
h = vFlame.spectrumObject.plot;
set(h,'color','white')

% Figure to show the datacube
cube.visualiseSlices;
set(gca,'fontsize',fontSize)

% Figure to show merged
figure()
hold on
subplot(1,2,1)
cube.plotZerothOrder();
colormap('gray')
axis image
axis xy
axis off
subplot(1,2,2)
cube.mergeAndPlot();
colormap('gray')
axis xy
axis image
axis off

%%  Ibsen setup
cm1 = Result.loadFolder('FinalReportFigs/Ibsen/1');
cm1.canonImageObject.rotate(2)
cm1.canonImageObject.reflectH();
cm1.canonImageObject.crop(0,0,1000,1000)
cm1.canonImageObject.increaseBrightness(2)
cm1.canonImageObject.show
h = cm1.plotImageAndSpectrum(200,[1256, 3217] , [431.1,473.5], 'white');
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)

cm2 = Result.loadFolder('FinalReportFigs/Ibsen/2');
cm2.canonImageObject.rotate(2)
cm2.canonImageObject.reflectH();
cm2.canonImageObject.crop(0,0,1000,1000)
cm2.canonImageObject.increaseBrightness(1.5)
cm2.canonImageObject.show
h = cm2.plotImageAndSpectrum(0,[1396, 3654] , [473.5,516.4], 'white');
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)

cm3 = Result.loadFolder('FinalReportFigs/Ibsen/3');
cm3.canonImageObject.rotate(2)
cm3.canonImageObject.reflectH();
cm3.canonImageObject.crop(0,0,1000,1000)
cm3.canonImageObject.increaseBrightness(2)
cm3.canonImageObject.show
h = cm3.plotImageAndSpectrum(0,[3573, 4455] , [549.9,563.4], 'white');
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)
%%
cm4 = Result.loadFolder('FinalReportFigs/Ibsen/4');
% cm4.canonImageObject.rotate(2)
cm4.canonImageObject.reflectH();
cm4.canonImageObject.crop(0,0,1000,1000)
cm4.canonImageObject.increaseBrightness(1.5);
cm4.canonImageObject.show
h = cm4.plotImageAndSpectrum(0,[807, 2680] , [431.1,473.5], 'white');
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)