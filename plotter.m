% Plotter stuff for exploring the data.

clear all; close all; clc;

%d = readtable('ThimbyTotal.csv');
%d = readtable('LongestDataSet.csv');
d = readtable('endingDataSet.csv');
d= d(57:end,:);


% Get rid of '-9999'
d.load_1=myInterpolator(d.load_1,-9999);
d.load_2=myInterpolator(d.load_2,-9999);
d.load_3=myInterpolator(d.load_3,-9999);
d.load_4=myInterpolator(d.load_4,-9999);
d.load_5=myInterpolator(d.load_5,-9999);
d.load_6=myInterpolator(d.load_6,-9999);
d.load_7=myInterpolator(d.load_7,-9999);
d.load_8=myInterpolator(d.load_8,-9999);

% d.SOE = myInterpolator(d.SOE,-9999);
% d.PV_power = myInterpolator(d.PV_power,-9999);
% d.B_power = myInterpolator(d.B_power,-9999);
% d.G_power = myInterpolator(d.G_power,-9998);
 d.load=myInterpolator(d.load,-9999);


% Intialize data storage
totalLoads = zeros(size(d,1),1);
HP_on = zeros(size(d,1),1);

for i = 2:size(d,1)-1
   
   if isnan(d.load_1(i));
       d.load_1(i) = (d.load_1(i-1)+d.load_1(i+1))/2;
   end
   if isnan(d.load_2(i));
       d.load_2(i) = (d.load_2(i-1)+d.load_2(i+1))/2;
   end
   if isnan(d.load_3(i));
       d.load_3(i) = (d.load_3(i-1)+d.load_3(i+1))/2;
   end
   if isnan(d.load_4(i));
       d.load_4(i) = (d.load_4(i-1)+d.load_4(i+1))/2;
   end
   if isnan(d.load_5(i));
       d.load_5(i) = (d.load_5(i-1)+d.load_5(i+1))/2;
   end
   if isnan(d.load_6(i));
       d.load_6(i) = (d.load_6(i-1)+d.load_6(i+1))/2;
   end
   if isnan(d.load_7(i));
       d.load_7(i) = (d.load_7(i-1)+d.load_7(i+1))/2;
   end
   if isnan(d.load_8(i));
       d.load_8(i) = (d.load_8(i-1)+d.load_8(i+1))/2;
   end
   
   totalLoads(i) = d.load_1(i)+d.load_2(i)+d.load_3(i)+d.load_4(i)+d.load_5(i)+d.load_6(i)+d.load_7(i)+d.load_8(i);
   
   if strcmp(d.HP_on,'TRUE');
       HP_on(i) = 100;
   else
       HP_on(i) = 0;
   end
    
end

totalLoads = totalLoads./1000;

% Construct E_batt variable
E_batt = zeros(size(d.SOE,1),1);
E_batt(1) = d.SOE(1)*13.5;

for i = 1:size(d.SOE,1)-1
    E_batt(i+1) = E_batt(i) + 15*60*0.9*d.B_power(i);
end


% Create some time series objects
load_1 = timeseries(d.load_1,d.datetime);
load_2 = timeseries(d.load_2,d.datetime);
load_3 = timeseries(d.load_3,d.datetime);
load_4 = timeseries(d.load_4,d.datetime);
load_5 = timeseries(d.load_5,d.datetime);
load_6 = timeseries(d.load_6,d.datetime);
load_7 = timeseries(d.load_7,d.datetime);
load_8 = timeseries(d.load_8,d.datetime);

soe = timeseries(d.SOE./100,d.datetime);
pv  = timeseries(d.PV_power,d.datetime);
b  = timeseries(d.B_power,d.datetime);
g = timeseries(d.G_power,d.datetime);
l = timeseries(d.load,d.datetime);
e = timeseries(E_batt,d.datetime);




figure(2);hold on;
plot(soe,'Marker','*');
plot(pv,'Marker','*');
plot(b,'Marker','*');
plot(l,'Marker','*');
%plot(g,'Marker','*');
% plot(load_1);
% plot(load_2);
%plot(1:size(d,1),totalLoads,'Marker','*');
%plot(1:size(d,1),d.load*1000,'Marker','*');
%plot(1:size(d,1),d.load_1,'Marker','*');
%plot(1:size(d,1),HP_on,'Marker','*','LineStyle','none');
% plot(1:size(d,1),d.load_2,'Marker','*');
% plot(1:size(d,1),d.load_3,'Marker','*');
% plot(1:size(d,1),d.load_4,'Marker','*');
% plot(1:size(d,1),d.load_5,'Marker','*');
%plot(1:size(d,1),d.load_6,'Marker','*');
% plot(1:size(d,1),d.load_7,'Marker','*');
% plot(1:size(d,1),d.load_8,'Marker','*');

legend('soe','pv','b','l');
% legend('total','load_1','load_2','load_3','load_4','load_5','load_6','load_7','load_8');
grid on;
hold off;

title('Summation of circuit loads');
xlabel('time [s]');
ylabel('power [kW]');
axis([0 1 -0.1 2.4]);

% figure(3);hold on;
% plot(e,'Marker','*');
% grid on;
% title('Battery Energy Level');
% axis([0 2 0 14]);
% legend('e');
% xlabel('time [s]');
% ylabel('energy [kWh]');

