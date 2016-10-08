si = SensicamImage.load('test_0001.tif');
si.plotIntensity;
si.setLowerLimit(100);
si.setUpperlimit(1500);


figure
si.showBracketedImage;