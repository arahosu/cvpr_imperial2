clc;clear;

%% Part 1
files = {'data/acrylic_211_01_HOLD.mat', 'data/car_sponge_101_01_HOLD.mat'};

figure();
subplot(3,1,1);
for i=1:length(files)
    A = load(files{i});
    vibration = A.F0pac(2,1:1000);
    pressure = A.F0pdc(1,1:1000); 
    temperature = A.F0tdc(1,1:1000); 
    plot(vibration, 'LineWidth', 2); hold on
    plot(pressure); hold on
    plot(temperature); hold on

end
y=[1000,2200];
plot([33 33],[y(1) y(2)], 'LineStyle', '--');
xlabel('timesteps');
ylabel('value');
title('(a) Presure, vibration and temperature for acrylic and car sponge');
legend({'acrylic vibration', 'acrylic pressure', 'acrylic temp', 'car sponge vibration', 'car sponge pressure', 'car sponge temperature', 't=33'});
hold off

subplot(3,1,2);
for i=1:length(files)
    A = load(files{i});
    electrodes = A.F0Electrodes;
    for j=1:size(electrodes,1)
        plot(electrodes(j,1:end)); hold on
    end
end

y=[3100, 3700];
line = plot([33 33],[y(1) y(2)], 'LineStyle', '--');
xlabel('timesteps');
ylabel('value');
title('(b) 19-electrodes reading for acrylic and car sponge');
legend(line, 't=33');
hold off

%% Part 2 
all_files = dir('data/*.mat');

data = struct;
data.vibrations = [];
data.pressures = [];
data.temperatures = [];
data.names = {};

electrodes_data = struct;
electrodes_data.impedances = [];

for i=1:length(all_files)
    A = load(all_files(i).name);
    data.vibrations = [data.vibrations, A.F0pac(2,33)];
    data.pressures = [data.pressures, A.F0pdc(1,33)];
    data.temperatures =  [data.temperatures, A.F0tdc(1,33)];
    data.names{end+1} = all_files(i).name;
    
    electrodes_data.impedances = [electrodes_data.impedances, A.F0Electrodes(1:end,33)];
end

% save the PVT and electrodes data separately in a .mat file
save('F0_PVT.mat', 'data');
save('F0_electrodes.mat', 'electrodes_data');

%% Part 3
colours = {'c', 'r', 'g', 'b', 'm', 'k'};

subplot(3,1,3);
for i=1:length(colours)
    scatter3(data.pressures(1+10*(i-1):10*i), data.vibrations(1+10*(i-1):10*i), data.temperatures(1+10*(i-1):10*i),10,colours{i},'filled');
    hold on
end

xlabel('Pressure');
ylabel('Vibration');
zlabel('Temperature');
title('(c) 3D visualisation of pressure, vibration and temperature');
legend({'acrylic vase', 'black foam', 'car sponge', 'flour sack', 'kitchen sponge', 'steel vase'});


