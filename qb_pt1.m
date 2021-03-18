clc; clear;

load('F0_PVT.mat');
colours = {'c', 'r', 'g', 'b', 'm', 'k'};

concat_data = vertcat(data.pressures, data.vibrations, data.temperatures);
concat_data = concat_data';
% Normalise the columns of the data
concat_data = normalize(concat_data, 1);

% compute the covariance matrix of the data
covMatrix = cov(concat_data);
% compute the eigenvectors V and eigenvalues D from the covariance matrix
[V,D] = eig(covMatrix);

% plot the data on the new coordinates
subplot(2,2,[1,3]);

for i=1:length(colours)
    scatter3(concat_data(1+10*(i-1):10*i,1),concat_data(1+10*(i-1):10*i,2),concat_data(1+10*(i-1):10*i,3),10,colours{i},'filled');
    hold on
end

line([0 V(1,1)],[0 V(2,1)],[0 V(3,1)],...
    'Color',[0.8 0.5 0.3],...
    'LineWidth',1.0);
line([0 V(1,2)],[0 V(2,2)], [0 V(3,2)],...
    'Color',[0.5 0.8 0.3],...
    'LineWidth',1.0);
line([0 V(1,3)],[0 V(2,3)], [0 V(3,3)],...
    'Color',[0.3 0.5 0.8],...
    'LineWidth',1.0);
title('(a)');
xlabel('standardised pressure');
ylabel('standardised vibration');
zlabel('standardised temperature');
legend({'acrylic vase', 'black foam', 'car sponge',...
        'flour sack', 'kitchen sponge', 'steel vase',...
        'pc1', 'pc2', 'pc3'});
axis equal

newdata = concat_data * V;
variance = D / sum(D(:));

% plot the transformed data
subplot(2,2,2);
for i=1:length(colours)
    scatter(newdata(1+10*(i-1):10*i,2),newdata(1+10*(i-1):10*i,3),10,colours{i}, 'filled');
    hold on
end

xlabel('PC2');
ylabel('PC3');
title('(b)');

% plot the data across PCs as 1D plots
subplot(2,2,4);
pc_plots = [];
for j=1:3
    pc_plots(end+1) = scatter(newdata(:,j), 0.*newdata(:,j)+0.5*(j-1), 10, 'filled'); hold on
    scatter([-std(newdata(:,j)), std(newdata(:,j))],[0.5*(j-1), 0.5*(j-1)], 50, 'k', 'x', 'LineWidth', 1.5);
    dummy_plot = scatter(NaN, NaN, 'k', 'x', 'LineWidth', 1.5);
end

pc_plots(end+1) = dummy_plot;
legend(pc_plots, {'pc1', 'pc2', 'pc3', '$\mu \pm \sigma$'}, 'Interpreter', 'latex');
title('(c)');

