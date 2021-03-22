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

pca_train = (train_norm * V);
pca_test = (test_norm * V);

cols = size(pca_train, 2);
train_data = pca_train(:, cols-3:cols);
test_data = pca_test(:, cols-3:cols);


fig = figure;
ax1 = subplot(1,3,1);
m1 = get_bagged_performance(pca_train(:, cols-2:cols), pca_test(:, cols-2:cols), ytrain, ytest);
title("Largest 3 PCs")
ylabel("Accuracy (%)")
ax2 = subplot(1,3,2);
m2 = get_bagged_performance(pca_train, pca_test, ytrain, ytest);
title("All PCs")
ax3 = subplot(1,3,3);
m3 = get_bagged_performance(train_norm, test_norm, ytrain, ytest);
title("Normalised Data")
linkaxes([ax1,ax2,ax3],'y')
h=axes(fig,'visible','off'); 
h.XLabel.Visible='on';
xlabel(h,'Number of Trees In Ensemble');
ylim([min([m1 m2 m3]), 100]);

% train_tree(train_data, test_data, ytrain, ytest, 12)


function [test_acc] = train_tree(train_data, test_data, ytrain, ytest, tree_num)
    Mdl = TreeBagger(tree_num, train_data, ytrain, 'OOBPrediction', 'On', 'Method', 'classification');

%     view(Mdl.Trees{1},'Mode','graph')
%     view(Mdl.Trees{2},'Mode','graph')

    ytest_pred = predict(Mdl, test_data);
    ytest_pred = str2double(ytest_pred);

    ytrain_pred = predict(Mdl, train_data);
    ytrain_pred = str2double(ytrain_pred);

%     figure;
%     subplot(1,2,1)
%     cm = confusionchart(ytrain,ytrain_pred);
%     title("Train Confusion Matrix")
%     subplot(1,2,2)
%     cm = confusionchart(ytest,ytest_pred);
%     title("Test Confusion Matrix")

    test_diff = abs(ytest - ytest_pred);
    test_diff(test_diff > 0) = 1;
    test_acc = 100*(length(test_diff) - sum(test_diff)) / length(test_diff);
    disp("Test Acc: " + num2str(test_acc) + "%");

    tr_diff = abs(ytrain - ytrain_pred);
    tr_diff(tr_diff > 0) = 1;
    disp("Train Acc: " + num2str(100*(length(tr_diff) - sum(tr_diff)) / length(tr_diff)) + "%");
end

function [lb_min] = get_bagged_performance(train_data, test_data, ytrain, ytest)
    accs = [];
    for tree_num =1:15
        num_acc = [];
        for r = 1:50
            test_acc = train_tree(train_data, test_data, ytrain, ytest, tree_num);
            num_acc = [num_acc test_acc];
        end
        accs = [accs; [mean(num_acc) std(num_acc)]];
    end
    
    % visual from https://uk.mathworks.com/matlabcentral/answers/494515-plot-standard-deviation-as-a-shaded-area
    
    y = accs(:, 1)';
    stds = accs(:, 2)';
    
    upper_bound = y + stds;
    lower_bound = y - stds;
    
    x = 1:tree_num;
    x2 = [x fliplr(x)];
    
    inBetween = [upper_bound fliplr(lower_bound)];
    h = fill(x2, inBetween, 'g');
    set(h,'facealpha',.25)
    hold on;
    plot(x, y, 'b', 'LineWidth', 2);
    
    xlim([1 tree_num])
%     hold on
%     plot(accs(:, 2));
    lb_min = min(lower_bound);
end
