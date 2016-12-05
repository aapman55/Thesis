function [ smoothedData ] = curveSmoother( data, percentage )
frequencyData = fft(data);
frequencyData(floor(percentage/100*end):end) = 0;
smoothedData = real(ifft(frequencyData));
end

