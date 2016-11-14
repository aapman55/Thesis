d1 = DataRayImage.load('Data/Flame/WinCamExcelData_10_28_2016_12_13_19Multiple');
d1.autoExposure();

figure()
d1.showBracketedImage

figure()
d1.showOriginalImage