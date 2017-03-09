% Main file for plotting the efficiencies.
clear all; close all; clc;

fontsize = 14;

%% NBK7 Transmission efficiency plot
NBK7Transmission = load('NBK7Transmission.txt');

figure('position',[0 0 1400 400]);
plot(NBK7Transmission(:,1),NBK7Transmission(:,2),'linewidth',2);
% hold on
% plot([350,350],[0,100])
set(gca,'FontSize',fontsize);
grid minor;
xlabel('Wavelength [nm]');
ylabel('Transmission efficiency [%]');

%% NBK7 Anti-Reflective coating performance
NBK7Reflection = load('NBK7Reflectivity.txt');

figure('position',[0 0 1400 400]);
plot(NBK7Reflection(:,1),NBK7Reflection(:,2),'linewidth',2);
% hold on
% plot([350,350],[0,100])
set(gca,'FontSize',fontsize);
grid minor;
xlabel('Wavelength [nm]');
ylabel('Reflection [%]');