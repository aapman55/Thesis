%%
res = Result.loadFolder('testData');
res.canonImageObject.crop(0,0,1000,1500);
% res.canonImageObject.show;
res.canonImageObject.rot90(2);
res.plotImageAndSpectrum(771,[2810, 3069] , [430,467.5])

%%
Result.install
res1 = Result.loadFolder('testData2');
res1.canonImageObject.rotate(1.5);


res1.canonImageObject.crop(0,0,1500,1000);
res1.canonImageObject.show;
hold on
plot([0,5000],[380,380])

res1.plotImageAndSpectrum(700,[3270, 4176] , [431.1,563.4])
view(90,90)