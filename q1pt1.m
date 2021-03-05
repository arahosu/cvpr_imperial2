files = dir('*.mat');
elbows = [];
for i=1:length(files)
    A = load(files(i).name);
    vibration = A.F0pac(2,1:1000);
    pressure = A.F0pdc(1,1:1000);
    temperature = A.F0tdc(1,1:1000); 
    figure(i);
    plot(vibration); hold on
    plot(pressure); hold on
    plot(temperature); hold on
    x = linspace(1,1000,1000);
    [x_val, x_idx] = knee_pt(vibration, x);
    elbows = [elbows, x_idx];
    print(sprintf('location of knee point at %f', x_idx));
    title(sprintf('Presure, vibration and temperature for %s', files(i).name), 'interpreter', 'none');
    legend({'vibration', 'pressure', 'temperature'});
    hold off
end