clc; clear; 

load('F0_PVT.mat');
colours = {'c', 'r', 'g', 'b', 'm', 'k'};

concat_data = vertcat(data.pressures, data.vibrations, data.temperatures);
concat_data = concat_data';
% Normalise the columns of the data
concat_data = normalize(concat_data, 1);


covMatrix = cov(concat_data); % compute the covariance matrix of the data
[V,D] = eig(covMatrix); % compute the eigenvectors V and eigenvalues D from the covariance matrix
V = fliplr(V); % sort by size of PCs
pcs = (concat_data * V)';

figure;

% plot the data on the new coordinates
subplot(2,3,[1 2]);
for i=1:length(colours)
    x = concat_data(1+10*(i-1):10*i,1);
    y = concat_data(1+10*(i-1):10*i,2);
    z = concat_data(1+10*(i-1):10*i,3);
    scatter3(x, y, z, 10, colours{i}, 'filled');
    hold on
end

line([0 V(1,1)],[0 V(2,1)],[0 V(3,1)],...
    'Color',[0.8 0.5 0.3],...
    'LineWidth',0.75);
line([0 V(1,2)],[0 V(2,2)], [0 V(3,2)],...
    'Color',[0.5 0.8 0.3],...
    'LineWidth',0.75);
line([0 V(1,3)],[0 V(2,3)], [0 V(3,3)],...
    'Color',[0.3 0.5 0.8],...
    'LineWidth',0.75);
legend({'acrylic vase', 'black foam', 'car sponge',...
        'flour sack', 'kitchen sponge', 'steel vase',...
        'pc1', 'pc2', 'pc3'});
axis equal

newdata = pcs';

% plot the transformed data
subplot(2,3,3);
for i=1:length(colours)
    scatter(newdata(1+10*(i-1):10*i,3),newdata(1+10*(i-1):10*i,2),10,colours{i}, 'filled');
    hold on
end

xlabel('PC3');
ylabel('PC2');

% plot the data across PCs as 1D plots


for j=1:3
    subplot(2,3,j+3);
    for i=1:length(colours)
        scatter(newdata(1+10*(i-1):10*i,j), zeros(10,1), 10,colours{i}, 'filled');
        hold on
    end
end

subplot(2,3,4);
title("PC1")

subplot(2,3,5);
title("PC2")

subplot(2,3,6);
title("PC3")
