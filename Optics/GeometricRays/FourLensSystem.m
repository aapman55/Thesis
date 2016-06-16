clear all; close all; clc

% Define lenses
L1 = Lens(0.1, 0, 0.05);
L2 = Lens(0.2, 0.3, 0.05);
L3 = Lens(0.1, 0.6, 0.05);
L4 = Lens(0.2, 0.9, 0.05);

% Define object/lightsource
O = LensObject(-inf, 0.0065);

% Pass through first lens
L1.setObject(O);
L1.computeImage();

% Pass through second lens
L2.setObject(L1.computedImage.toObject);
L2.computeImage();

% Pass through third lens
L3.setObject(L2.computedImage.toObject);
L3.computeImage();

%Pass through fourth lens
L4.setObject(L3.computedImage.toObject);
L4.computeImage();

% Draw all
figure;
hold on; grid minor;
L1.draw();
L2.draw();
L3.draw();
L4.draw();