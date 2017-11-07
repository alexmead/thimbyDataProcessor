function [timeSeries] = myInterpolator(timeSeries, bottomOut)
%This function interpolate values that are reported at extremes due to API
%issues, for example several good measurements interupted by a few -9999.

interpret = false;
for i=2:size(timeSeries,1)
   
    % Will enter if this is the first bottomOut value in a spot
   if (timeSeries(i) == bottomOut && interpret == false)
       count=1;
       interpret=true;
       LeftValue=timeSeries(i-1);
   end
   
   % How many bottomOut are there in a row
   if (timeSeries(i) == bottomOut && interpret == true)
      count = count + 1; 
   end
   
   % Will enter if this is the first nonbottomOut value in a spot
   if (timeSeries(i) ~= bottomOut && interpret == true)
      RightValue = timeSeries(i);
      
      % Calculate ow big are the steps
      stepper = (RightValue - LeftValue)/count;
      
      % Interpolate the values
      for j=count:-1:1;
          timeSeries(i-j) = LeftValue + (count-j+1)*stepper;
      end
      interpret=false;
   end

end


end

