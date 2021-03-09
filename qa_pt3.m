load('F0_PVT.mat');

colours = {'c', 'r', 'g', 'b', 'm', 'k'};

for i=1:length(colours)
    scatter3(data.pressures(1+10*(i-1):10*i), data.vibrations(1+10*(i-1):10*i), data.temperatures(1+10*(i-1):10*i),10,colours{i});
    hold on
end

xlabel('Pressure');
ylabel('Vibration');
zlabel('Temperature');
legend({'acrylic vase', 'black foam', 'car sponge', 'flour sack', 'kitchen sponge', 'steel vase'});
savefig('pvt_scatter_plot');