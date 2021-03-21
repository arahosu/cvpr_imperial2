clc; clear; close("all");

e = load("F0_electrodes.mat");

data = e.electrodes_data.impedances';

train_idxes = [];
labels = [];
c = 1;
test_idxes = [];
for i = 1:10:60
   for j = 0:9
       if j < 6
           train_idxes(end + 1) = i + j;
       else
           test_idxes(end + 1) = i + j;
       end
       labels(end + 1) = c;
   end
   c = c + 1;
end


train = data(train_idxes,:);
ytrain = labels(:,train_idxes)';
test = data(test_idxes,:);
ytest = labels(:,test_idxes)';

train_std = std(train,1);
train_mean = mean(train,1);

train_norm = (train - train_mean);

sigma = train_std;

for i = 1:size(train_norm,1) - 1
    train_std(end+1, :) = sigma; 
end

test_norm = (test - train_mean);

test_std = [];
for i = 1:size(test,1)
    test_std(end+1, :) = sigma;
end

train_norm = train_norm ./ train_std;
test_norm = test_norm ./ test_std;

clear test_std

covMatrix = cov(train_norm);
[V,D] = eig(covMatrix);

pca_train = (V * train_norm')';
pca_test = (V * test_norm')';

Mdl = TreeBagger(10, pca_train, ytrain, 'OOBPrediction', 'On', 'Method', 'classification');

%view(Mdl.Trees{1},'Mode','graph')

ytest_pred = predict(Mdl, pca_test);
ytest_pred = str2double(ytest_pred);

ytrain_pred = predict(Mdl, pca_train);
ytrain_pred = str2double(ytrain_pred);

figure;
cm = confusionchart(ytrain,ytrain_pred);
figure;
cm = confusionchart(ytest,ytest_pred);


test_diff = abs(ytest - ytest_pred);
test_diff(test_diff > 0) = 1;
disp("Test Acc: " + num2str(100*(length(test_diff) - sum(test_diff)) / length(test_diff)) + "%");

tr_diff = abs(ytrain - ytrain_pred);
ttr_diff(tr_diff > 0) = 1;
disp("Train Acc: " + num2str(100*(length(tr_diff) - sum(tr_diff)) / length(tr_diff)) + "%");








