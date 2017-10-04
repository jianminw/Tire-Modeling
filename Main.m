function Main()
%% Tire Modeling
%Pretty much everything should be called by this file. This is the main
%file that should be ran every time. 

clc
close all
format long

%% R25B Non-Driven Behavior
% R25B data
r20 = load('Round-5-SI/B1464run20.mat'); % loading round 20 data
r21 = load('Round-5-SI/B1464run21.mat'); % loading round 21 data

%% Driven Behavior
r39 = load('Round-5-SI/B1464run39.mat'); % loading round 39 data
r40 = load('Round-5-SI/B1464run40.mat'); % loading round 40 data

CR25 = combine(r20, r21); 
CR25 = timeSplice(CR25, r20, r21);
CR25.pos = segment(CR25.SA, 8450, 117280, 2); % Lots of Magic Numbers

DR25 = combine(r39, r40);
DR25 = timeSplice(DR25, r39, r40);
DR25.pos = segment(DR25.IA, -1, length(DR25.P)+1, 1);


%% Pacejka Fit

Slip_Angle_Modeling(CR25);

%Slip_Ratio_Modeling(DR25);

end

