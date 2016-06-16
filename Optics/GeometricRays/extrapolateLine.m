function [ newY ] = extrapolateLine( X, Y, newX )
%extrapolateLine Utility to take a line defined by a beginpoint and
%endpoint and fit it to a new line with another beginpoint and endpoint.
% Nothing fancy really.

% Check if the vectors X and Y only contain 2 values for X and 2 values for
% Y

if (length(X) ~= 2)
    error('The X vector needs to consist of 2 values!');
end

if (length(Y) ~= 2)
    error('The Y vector needs to consist of 2 values!');
end

P = polyfit(X,Y,1);

newY = polyval(P,newX);
end

