clc;clear;

files = {'data/acrylic_211_01_HOLD.mat', 'data/car_sponge_101_01_HOLD.mat'};

figure();
for i=1:length(files)
    A = load(files{i});
    vibration = A.F0pac(2,1:1000);
    pressure = A.F0pdc(1,1:1000);
    temperature = A.F0tdc(1,1:1000); 
    plot(vibration); hold on
    plot(pressure); hold on
    plot(temperature); hold on

end
y=[1000,2200];
plot([33 33],[y(1) y(2)]);
xlabel('timesteps');
ylabel('value');
title('Presure, vibration and temperature for acrylic and car sponge');
legend({'acrylic vibration', 'acrylic pressure', 'acrylic temp', 'car sponge vibration', 'car sponge pressure', 'car sponge temperature', 't=33'});
hold off

figure();
for i=1:length(files)
    A = load(files{i});
    electrodes = A.F0Electrodes;
    for j=1:size(electrodes,1)
        plot(electrodes(j,1:end)); hold on
    end
end

y=[3100, 3700];
plot([33 33],[y(1) y(2)]);
xlabel('timesteps');
ylabel('value');
title('19-electrodes reading for acrylic and car sponge');
hold off