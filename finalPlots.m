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
plotLinespread(canonImage.getCurrent,'v',2500,2470:2530)
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
%% With pipe no plate no rod
pipeClean = Result.loadFolder('FinalReportFigs/Pipeclean');
h = pipeClean.plotImageAndSpectrum(1700,[3540, 4494] , [431.1,563.4]);
% view(90,90)
set(h,'position',[0 0 1200 300])
hold on
xlabel('Wavelength [nm]')
ylabel('Intensity [-]')
set(gca,'fontsize',fontSize)
%% With pipe With plate
pipePlate = Result.loadFolder('FinalReportFigs/pipePlate');
h = pipePlate.plotImageAndSpectrum(1700,[3212, 3481] , [431.1,473.5]);
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