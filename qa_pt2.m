files = dir('data/*.mat');

data = struct;
data.vibrations = [];
data.pressures = [];
data.temperatures = [];
data.names = {};

electrodes_data = struct;
electrodes_data.impedances = [];

for i=1:length(files)
    A = load(files(i).name);
    data.vibrations = [data.vibrations, A.F0pac(2,33)];
    data.pressures = [data.pressures, A.F0pdc(1,33)];
    data.temperatures =  [data.temperatures, A.F0tdc(1,33)];
    data.names{end+1} = files(i).name;
    
    electrodes_data.impedances = [electrodes_data.impedances, A.F0Electrodes(1:end,33)];
end

save('F0_PVT.mat', 'data');
save('F0_electrodes.mat', 'electrodes_data');