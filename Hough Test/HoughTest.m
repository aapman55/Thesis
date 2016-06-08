clear all; close all; clc;
im = imread('square2.png');

IM = rgb2gray(im);

Ed = edge(IM,'canny');

imshow(Ed);

[H,T,R] = hough(Ed);

figure,imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
axis on, axis normal, hold on, colormap('hot');
xlabel('angle (\theta)');ylabel('radius (r)');

P  = houghpeaks(H,200,'threshold',ceil(0.1*max(H(:))));

lines = houghlines(Ed,T,R,P,'FillGap',1,'MinLength',7);
figure, imshow(IM), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end