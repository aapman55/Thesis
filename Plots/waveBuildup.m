clear; close all; clc;
% This script creates the necessary sinusoidal waves to make a figure to
% explain that adding sinusoidal waves can form a wave with nice features

%%%%%%%%%%%%%%%%% User Input %%%%%%%%%%%%%%%%%%%%%%%%
amountOfWaves = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

range = 0:0.01*pi:6*pi;

addedSine = zeros(size(range));
waveList = zeros(amountOfWaves, length(range));

for i = 0:amountOfWaves-1
    no = (1+i*2);
    newWave = 1/no*sin(no*range);
    % Save the new wave in the waveList
    waveList(i+1,:) = newWave;    
end

% Make the 3D plot
figure
stdColormap = lines;
plot3( zeros(size(range)), range, sum(waveList),'color',stdColormap(2,:),'linewidth',2)

set(gca,...
'XTickLabel','', ...
'YTickLabel','', ...
'ZTickLabel','')
hold on
grid minor
box on

for i = 1: amountOfWaves
    plot3( ones(size(range))*i, range, waveList(i,:), 'color',stdColormap(1,:))
end

xlabel('Frequency domain (Hz)')
ylabel('Time domain (s)')