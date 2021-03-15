clc; clear;

e = load("F0_electrodes.mat");

data = e.electrodes_data.impedances';
data = normalize(data, 1);

covMatrix = cov(data);
[V,D] = eig(covMatrix);

[wcoeff,score,latent,tsquared,explained] = pca(data);

figure()
pareto(explained, 0.97)
xlabel('Principal Component')
ylabel('Variance Explained (%)')