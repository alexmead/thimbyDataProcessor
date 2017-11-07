function [ timeSeries ] = toZero( timeSeries )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

maxer = max(size(timeSeries));
for i=1:maxer
    
    if timeSeries(i) < -5
        timeSeries(i) = 0;
    end

end
