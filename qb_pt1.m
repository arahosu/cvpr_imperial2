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
figure;
ax = axes();
view(ax, 3)
hold(ax, 'on')

for i=1:length(colours)
    scatter3(concat_data(1+10*(i-1):10*i,1),concat_data(1+10*(i-1):10*i,2),concat_data(1+10*(i-1):10*i,3),10,colours{i});
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

newdata = concat_data * V;
% newdata = newdata';

variance = D / sum(D(:));
variance_2 = var(newdata)/sum(var(newdata));

% plot the transformed data
figure;

for i=1:length(colours)
    scatter(newdata(1+10*(i-1):10*i,1),newdata(1+10*(i-1):10*i,2),10,colours{i});
    hold on
end

xlabel('PC1');
ylabel('PC2');

% plot the data across PCs as 1D plots

figure;
for j=1:3
    subplot(3,1,j);
    for i=1:length(colours)
        scatter(newdata(1+10*(i-1):10*i,j), zeros(10,1), 10,colours{i});
        hold on
    end
end
