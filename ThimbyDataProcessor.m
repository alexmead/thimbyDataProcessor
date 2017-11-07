% Author: Alex R. Mead
% Date: October 2017
% Description: A script used to process data from Thimby for System ID and
% model predictive control (MPC)

clear all; close all; clc;

% Get data filename from user
%inputFilename = input('Enter the data file name:   ');
%inputFilename = 'LongestDataSet.csv';
inputFilename = 'ThimbyTotal.csv';

% Import the data as a table
d = readtable(inputFilename);

% Allow user to examine data, ask how many time series they want to
% examine.
summary(d)
numberOfTimeSeries = input('How many times series do you want to examine?     ');
% dt = input('What is the sampling time?  ');
% units = input('What are the sampling time units?   ');

% Have user enter in the time series by name they desire to explore
listOfTimeSeries ={numberOfTimeSeries};
for i=1:numberOfTimeSeries
    ts_holder = input(strcat('Time series ',num2str(i),' name: '));
    listOfTimeSeries{i} = ts_holder;
end

% Populate time series objects for the specificed variables from the table
ActualTimeSeries = {numberOfTimeSeries};
for i=1:numberOfTimeSeries
   ActualTimeSeries{i} = timeseries(d.(listOfTimeSeries{i}),d.datetime);
   %ActualTimeSeries{i}.Name = listOfTimeSeries{i};
end

% Plot the time series for examination by user to select domains
starts = {numberOfTimeSeries};
stops = {numberOfTimeSeries};
dataLength = size(d.(listOfTimeSeries{i}),1);
for i=1:numberOfTimeSeries
   figure(1);
   plot(ActualTimeSeries{i},'Marker','*');
   % Ask user for desired start/stop times for the subset to analyze
   starts{i} = datenum(input('Please enter the starting data/time (fmt: dd-mmm-yyyy hr:mn:sc):   ')) - datenum(ActualTimeSeries{i}.TimeInfo.StartDate);
   stops{i} = datenum(input('Please enter the ending1 data/time (fmt: dd-mmm-yyyy hr:mn:sc):   ')) - datenum(ActualTimeSeries{i}.TimeInfo.StartDate);
   
   % Close the plot down
   close 1;
   
   % Construct the index vector for the data sampling process
   sampleIndexes = [];
   
   for j=1:dataLength
       if ((ActualTimeSeries{i}.Time(j) >= starts{i}) && (ActualTimeSeries{i}.Time(j) < stops{i}))
          sampleIndexes = [sampleIndexes j]; 
       end
   end
   
   % Trim the time series down with the new sampleIndexes
   ActualTimeSeries{i} = getsamples(ActualTimeSeries{i},sampleIndexes);
   
   % Check if these should be used for all
   allTs = input('Do you want these dates for all remaining time series (y/n):  ');
   %if i==1
        if (allTs == 'y' || allTs == 'Y')
            for j=i+1:numberOfTimeSeries
                 %Trim the time series down with the new sampleIndexes
                 ActualTimeSeries{j} = getsamples(ActualTimeSeries{j},sampleIndexes);
            end
            break;
        end
   %end
end

% Clean up the workspace, plot the results

clc;
for i=1:numberOfTimeSeries
    figure(i); hold on;
    plot(ActualTimeSeries{i});
    grid on;
    title(ActualTimeSeries{i}.Name);
    hold off;
end

%clearvars -except ActualTimeSeries;

%Clean up the -9999 values of time series

for j=1:numberOfTimeSeries
    ActualTimeSeries{j}.Data = interpolator(ActualTimeSeries{j}.Data,-9999);
end


for i=1:numberOfTimeSeries
    figure(i+4); hold on;
    plot(ActualTimeSeries{i});
    grid on;
    title(ActualTimeSeries{i}.Name);
    hold off;
end








