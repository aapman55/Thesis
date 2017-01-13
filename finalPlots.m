clear all; close all; clc;
Result.install
fontSize = 12;
%% Linespread Thorlabs
thorlabsLinespread = Result.loadFolder('FinalReportFigs/ThorlabsLineSpread');
figure()
thorlabsLinespread.canonImageObject.show;
xlabel('Pixels [-]')
ylabel('Pixels [-]')
plotLinespread(thorlabsLinespread.canonImageObject.getCurrent,'v',1200,1500:1550)

%% Linespread Ibsen
canonImage = cameraImage('FinalReportFigs/IbsenLinespread/LinespreadF55.JPG');
img = canonImage.getCurrent;
figure()
canonImage.show;
xlabel('Pixels [-]')
ylabel('Pixels [-]')
plotLinespread(img(:,:,3),'v',3000,2400:2600)
%% The steady flame no pipe extension
steadyNoPipe = Result.loadFolder('FinalReportFigs/steadyFlameNoPipe');
steadyNoPipe.canonImageObject.rotate(180);
steadyNoPipe.canonImageObject.crop(0,0,1500,1500)
h = steadyNoPipe.plotImageAndSpectrum(160,[2835, 3715] , [431.1,563.4]);
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
steadyNoPipe.dataRayObject.setUpperlimit(4000)
steadyNoPipe.dataRayObject.showBracketedImage
axis xy;
xlabel('Pixels [-]')
ylabel('Pixels [-]')
set(gca,'fontsize',fontSize)

%% With pipe no plate no rod
pipeClean = Result.loadFolder('FinalReportFigs/Pipeclean');
pipeClean.canonImageObject.crop(0,0,1200,1200)
h = pipeClean.plotImageAndSpectrum(0,[3540, 4494] , [431.1,563.4]);
% view(90,90)
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)
%% With pipe With plate
pipePlate = Result.loadFolder('FinalReportFigs/pipePlate');
h = pipePlate.plotImageAndSpectrum(1000,[3212, 3481] , [431.1,473.5]);
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
pipePlate2.canonImageObject.show
h = pipePlate2.plotImageAndSpectrum(1200,[3258, 3537] , [431.1,473.5]);
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
h = vFlame.plotImageAndSpectrum(300,[3297, 3859] , [431.1,516.4]);
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)


% create datacube
vFlame.canonImageObject.reset();
vFlame.canonImageObject.rotate(-2.0);
vFlame.canonImageObject.show();
cube = DataCube.createDataCube(vFlame.canonImageObject.getCurrent, 100, 100, 1715, [3320, 3547, 3848, 4181]);
%%  Ibsen setup
cm1 = Result.loadFolder('FinalReportFigs/Ibsen/1');
cm1.canonImageObject.rotate(2)
cm1.canonImageObject.reflectH();
cm1.canonImageObject.crop(0,0,1000,1000)
cm1.canonImageObject.show
h = cm1.plotImageAndSpectrum(200,[1256, 3217] , [431.1,473.5]);
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)

cm2 = Result.loadFolder('FinalReportFigs/Ibsen/2');
cm2.canonImageObject.rotate(2)
cm2.canonImageObject.reflectH();
cm2.canonImageObject.crop(0,0,1000,1000)
cm2.canonImageObject.show
h = cm2.plotImageAndSpectrum(0,[1396, 3654] , [473.5,516.4]);
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)

cm3 = Result.loadFolder('FinalReportFigs/Ibsen/3');
cm3.canonImageObject.rotate(2)
cm3.canonImageObject.reflectH();
cm3.canonImageObject.crop(0,0,1000,1000)
cm3.canonImageObject.show
h = cm3.plotImageAndSpectrum(0,[3573, 4455] , [549.9,563.4]);
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
cm4.canonImageObject.show
h = cm4.plotImageAndSpectrum(0,[807, 2680] , [431.1,473.5]);
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)