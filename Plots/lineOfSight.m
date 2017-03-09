theta = 0:pi/16:2*pi;
y = sin(theta);
x = cos(theta);

scatter(x,y,'k')

axis image
axis off
hold on
plot([-1.1 -1.1],[-1.5 1.5],'color','k')
plot([-.9 -.9],[-1.5 1.5],'color','k')

plot([-.1 -.1],[-1.5 1.5],'color','k')
plot([.1 .1],[-1.5 1.5],'color','k')