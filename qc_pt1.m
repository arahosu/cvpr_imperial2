clear; clc; close("all");
load('F0_PVT.mat');
colours = {'c', 'r', 'g', 'b', 'm', 'k'};

concat_data = vertcat(data.pressures, data.vibrations, data.temperatures)';
concat_data = normalize(concat_data, 1);
black_foam_data = concat_data(11:20,:);
car_sponge_data = concat_data(21:30,:);

X = vertcat(black_foam_data, car_sponge_data);
X1 = [X(:,1), X(:,2)];
X2 = [X(:,1), X(:,3)];
X3 = [X(:,2), X(:,3)];

label = {};
label(1:10,1) = {'black_foam'};
label(11:20,1) = {'car_sponge'};

% pressure vs vibration
MdlPV = PlotLDA(X1, label, {'normalised pressure', 'normalised vibration'});
% pressure vs temperature
MdlPT = PlotLDA(X2, label, {'normalised pressure', 'normalised temperature'});
% vibration vs temperature
MdlVT = PlotLDA(X3, label, {'normalised vibration', 'normalised temperature'});

% 3D LDA plot
MdlPVT = PlotLDA3(X, label, {'normalised pressure', 'normalised vibration', 'normalised temperature'},...
                  {'black foam', 'car sponge'});

% % Get data of car sponge and kitchen sponge
% car_sponge_data = concat_data(21:30,:);
% kitchen_sponge_data = concat_data(41:50,:);
% new_data = vertcat(car_sponge_data, kitchen_sponge_data);
% new_label = {};
% new_label(1:10,1) = {'car sponge'};
% new_label(11:20,1) = {'kitchen sponge'};
% 
% % Get a 3D LDA plot of acrylic and steel vase data
% PlotLDA([new_data(:,1), new_data(:,2)], label, {'normalised pressure', 'normalised vibration'});
% PlotLDA([new_data(:,1), new_data(:,3)], label, {'normalised pressure', 'normalised temperature'});
% PlotLDA([new_data(:,2), new_data(:,3)], label, {'normalised vibration', 'normalised temperature'});
% 
% MdlPVT_AS = PlotLDA3(new_data, label,...
%                      {'normalised pressure', 'normalised vibration', 'normalised temperature'},...
%                      {'car sponge', 'kitchen sponge'});