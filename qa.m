clc;clear; close("all")

%% Part 1
files = dir('data/*.mat');
colours = {'c', 'r', 'g', 'b', 'm', 'k'};

figure();
subplot(2,2,[1,3]);
idx = 1;
dummy_plots = [];

for i=1:10:length(files)
    A = load(['data/' files(i).name]);
    vibration = A.F0pac(2,1:1000);
    pressure = A.F0pdc(1,1:1000); 
    temperature = A.F0tdc(1,1:1000); 
    plot(vibration, 'Color', colours{idx}, 'LineWidth', 0.5); hold on
    plot(pressure, 'LineStyle', ':', 'Color', colours{idx}); hold on
    plot(temperature, 'LineStyle', '-.', 'Color', colours{idx}); hold on
    % dummy plot for legend
    dummy_plots(end+1) = plot([NaN,NaN], 'Color', colours{idx});
    idx = idx+1;
end

y=[800,2200];
t33 = plot([33 33],[y(1) y(2)], 'LineStyle', '--');
xlabel('timesteps');
ylabel('value');
title('(a)');
dummy_plots(end+1) = t33;
legend(dummy_plots, {'acrylic', 'black foam', ...
    'car sponge', 'flour sack', 'kitchen sponge', ...
    'steel vase', 't=33'});
hold off

subplot(2,2,2);
idx = 1;
for i=1:10:length(files)
    A = load(['data/' files(i).name]);
    electrodes = A.F0Electrodes;
    for j=1:size(electrodes,1)
        plot(electrodes(j,1:end), 'Color', colours{idx}); hold on
    end
    dummy_plots(idx) = plot([NaN,NaN], 'Color', colours{idx});
    idx = idx + 1;
end

y=[3000, 3800];
line = plot([33 33],[y(1) y(2)], 'LineStyle', '--');
xlabel('timesteps');
ylabel('value');
title('(b)');
dummy_plots(end) = line;
legend(dummy_plots, {'acrylic', 'black foam', ...
    'car sponge', 'flour sack', 'kitchen sponge', ...
    'steel vase', 't=33'});
hold off

%% Part 2 
data = struct;
data.vibrations = [];
data.pressures = [];
data.temperatures = [];
data.names = {};

electrodes_data = struct;
electrodes_data.impedances = [];

for i=1:length(files)
    A = load(['data/' files(i).name]);
    data.vibrations = [data.vibrations, A.F0pac(2,33)];
    data.pressures = [data.pressures, A.F0pdc(1,33)];
    data.temperatures =  [data.temperatures, A.F0tdc(1,33)];
    data.names{end+1} = files(i).name;
    
    electrodes_data.impedances = [electrodes_data.impedances, A.F0Electrodes(1:end,33)];
end

% save the PVT and electrodes data separately in a .mat file
save('F0_PVT.mat', 'data');
save('F0_electrodes.mat', 'electrodes_data');

%% Part 3
subplot(2,2,4);
for i=1:length(colours)
    scatter3(data.pressures(1+10*(i-1):10*i), data.vibrations(1+10*(i-1):10*i), data.temperatures(1+10*(i-1):10*i),10,colours{i},'filled');
    hold on
end

xlabel('Pressure');
ylabel('Vibration');
zlabel('Temperature');
title('(c)');
legend({'acrylic', 'black foam', 'car sponge', 'flour sack', 'kitchen sponge', 'steel vase'});


