% Find the maximum data set wihtout breaks


startTime = 1;
endTime = 1;
maximum = 1;
starts = [];
ends = [];
for i = 1:size(ActualTimeSeries{1}.Time,1)-1
    if(ActualTimeSeries{1}.Time(i+1)-ActualTimeSeries{1}.Time(i)>0.0104)
        % Archive starts, ends
        starts = [starts startTime];
        ends = [ends endTime];
        
        % Increment times for next series
        startTime = i+1;
        endTime = i+1;
    else
        endTime = i;
    end
    
end