clc; clear;

e = load("F0_electrodes.mat");
colours = {'c', 'r', 'g', 'b', 'm', 'k'};

data = e.electrodes_data.impedances';
data = normalize(data, 1);

[wcoeff,score,latent,tsquared,explained] = pca(data);

names = {};
for i = 1:length(explained)
    names{i} = sprintf('PC%d',i);
end

subplot(1,2,1);
pareto(explained, names, 0.97);
xlabel('Principal Component');
ylabel('Variance Explained %');
title('(a)');

subplot(1,2,2);
for i=1:length(colours)
    scatter3(score(1+10*(i-1):10*i,1),score(1+10*(i-1):10*i,2),score(1+10*(i-1):10*i,3),10,colours{i},'filled');
    hold on
end

xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
legend({'acrylic vase', 'black foam', 'car sponge',...
        'flour sack', 'kitchen sponge', 'steel vase'});
title('(b)');