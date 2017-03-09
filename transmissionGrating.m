function [ firstOrder ] = transmissionGrating( lambda, incidence, linesPermm )
%TRANMISSIONGRATING This function calculates the first order dispersion of
%a transmission grating

firstOrder = asind(lambda.*1E-9.*linesPermm.*1E3-sind(incidence));

end

