% This script is to make the right plots to be used in
% reports/presentations

clear; close all; clc;

% Used units are in mm

%% 2f Magnification : 1x, incoherent

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define object
O1 = LensObject(-200, 15);

L1.setObject(O1);
L1.computeImage();

figure('name','2f magnification 1x')
L1.draw();

%% 2f Magnification : 2x, incoherent

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define object
O1 = LensObject(-150, 15);

L1.setObject(O1);
L1.computeImage();

figure('name','2f magnification 2x')
L1.draw();

%% 2f Magnification : 0.5x, incoherent

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define object
O1 = LensObject(-300, 15);

L1.setObject(O1);
L1.computeImage();

figure('name','2f magnification 2x')
L1.draw();

%% 2f Magnification : 2x, incoherent imaginary

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define object
O1 = LensObject(-50, 15);

L1.setObject(O1);
L1.computeImage();

figure('name','2f magnification 2x imaginary')
L1.draw();

%% 4f Magnification : 1x, incoherent

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define lens (f = 100mm)
L2 = Lens(100, 200, 50);

% Define object
O1 = LensObject(-100, 15);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 1x')
L1.draw();
grid minor;
L2.draw();

%% 4f Magnification : 2x, incoherent

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define lens (f = 200mm)
L2 = Lens(200, 300, 50);

% Define object
O1 = LensObject(-100, 15);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 2x')
L1.draw();
grid minor;
L2.draw();

%% 4f Magnification : 0.5x, incoherent

% Define lens (f = 200mm)
L1 = Lens(200, 0, 50);

% Define lens (f = 100mm)
L2 = Lens(100, 300, 50);

% Define object
O1 = LensObject(-200, 15);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 0.5x')
L1.draw();
grid minor;
L2.draw();

%% coherent through focal point

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define object
O1 = LensObject(-inf, 15);

L1.setObject(O1);
L1.computeImage();

figure('name','2f magnification 1x')
L1.draw();

%% 4f Magnification : 1x, coherent

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define lens (f = 100mm)
L2 = Lens(100, 200, 50);

% Define object
O1 = LensObject(-inf, 15);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 1x')
L1.draw();
grid minor;
L2.draw();

%% 4f Magnification : 2x, coherent

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define lens (f = 200mm)
L2 = Lens(200, 300, 50);

% Define object
O1 = LensObject(-inf, 15);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 2x')
L1.draw();
grid minor;
L2.draw();

%% 4f Magnification : 0.5x, coherent

% Define lens (f = 200mm)
L1 = Lens(200, 0, 50);

% Define lens (f = 100mm)
L2 = Lens(100, 300, 50);

% Define object
O1 = LensObject(-inf, 15);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 0.5x')
L1.draw();
grid minor;
L2.draw();

%% 4f converging after second lens

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define lens (f = 200mm)
L2 = Lens(200, 350, 50);

% Define object
O1 = LensObject(-inf, 6.5);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 2x')
L1.draw();
grid minor;
L2.draw();

%% 4f diverging after second lens

% Define lens (f = 100mm)
L1 = Lens(100, 0, 50);

% Define lens (f = 200mm)
L2 = Lens(200, 250, 50);

% Define object
O1 = LensObject(-inf, 6.5);

L1.setObject(O1);
L1.computeImage();

L2.setObject(L1.computedImage.toObject());
L2.computeImage();

figure('name','4f magnification 2x')
L1.draw();
grid minor;
L2.draw();