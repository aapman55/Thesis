% This file is used to make grating plots. Specifically the first order
% dispersion angles.
range = 400:650;
angle = transmissionGrating(range,0,1200);

%% Thorlabs
fontsize = 12;
range = 430:.1:620;
angle = transmissionGrating(range,0,1200);

secondY = @(X) (angle(2)-angle(1))./(range(2)-range(1)).*(X-range(1))+angle(1);
tangentLine = secondY(range);
% plot(range, angle) 
% hold on
figure('position',[0 0 600 500])
hold on
[ax h1 h2] = plotyy(range, angle,range(1:end-1), diff(angle))
axes(ax(1))
plot(range, tangentLine,'color','k');
xlabel('Wavelength [nm]')
set(get(ax(1),'Ylabel'),'String','First order dispersion angle [deg]')
set(get(ax(2),'Ylabel'),'String','Change in disperion angle per nm') 
handleLegend = legend('First Order dispersion angle at 0^\circ incidence','Tangent','Change in dispersion angle','location','northwest')
set(ax,{'ycolor'},{'k';'k'})
grid minor
set(ax,'fontsize',fontsize)
set(handleLegend, 'fontsize', fontsize)

%% Ibsen
fontsize = 12;
range = 430:.1:580;
angle = transmissionGrating(range,70,3309);

secondY = @(X) (angle(2)-angle(1))./(range(2)-range(1)).*(X-range(1))+angle(1);
tangentLine = secondY(range);
% plot(range, angle) 
% hold on
figure('position',[0 0 600 500])
hold on
[ax h1 h2] = plotyy(range, angle,range(1:end-1), diff(angle))
axes(ax(1))
plot(range, tangentLine,'color','k');
xlabel('Wavelength [nm]')
set(get(ax(1),'Ylabel'),'String','First order dispersion angle [deg]')
set(get(ax(2),'Ylabel'),'String','Change in disperion angle per nm') 
handleLegend = legend('First Order dispersion angle at 70^\circ incidence','Tangent','Change in dispersion angle','location','northwest')
set(ax,{'ycolor'},{'k';'k'})
grid minor
set(ax,'fontsize',fontsize)
set(handleLegend, 'fontsize', fontsize)

%% Ibsen 2
range = 500:580;
angle1 = transmissionGrating(range,70,3309);
angle2 = transmissionGrating(range,80,3309);
fontsize = 12;

figure()
plot(range,angle1, range, angle2)
grid minor
legend('Angle of incidence 70^\circ','Angle of incidence 80^\circ','location','northwest')
set(gca,'fontsize',fontsize)
xlabel('Wavelength [nm]')
ylabel('First order dispersion angle [deg]')