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
MdlPVT = PlotLDA3(X, label, {'normalised pressure', 'normalised vibration', 'normalised temperature'});