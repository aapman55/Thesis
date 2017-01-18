function [ newImage ] = histogramEquilisation( im, newRange )

[b]=histcounts(im,'normalization','probability','binwidth',1); 

probDens = cumsum(b);

newVals = floor(newRange*probDens);

newImage = zeros(size(im));

for i = 1:size(im,1)
    for j = 1:size(im,2)
            newImage(i,j) = newVals(max(1,im(i,j)));
    end
end

end

