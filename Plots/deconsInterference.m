% constructive and destructive interfeerence
x = linspace(0,2*pi,100);
figure
plot(x,sin(x),'linewidth',1)
hold on
plot(x,sin(x),'linestyle','--')
plot(x,sin(x)+sin(x))
legend('wave 1','wave 2','sum of the waves')
axis tight
grid minor

figure
plot(x,sin(x),'linewidth',1)
hold on
plot(x,sin(x+pi),'linestyle','--')
plot(x,sin(x)+sin(pi+x))
legend('wave 1','wave 2','sum of the waves')
axis tight
grid minor

% Arbitrary sinc function
figure
X = linspace(-2*pi, 2*pi, 500);
plot(X,sinc(X))
axis off