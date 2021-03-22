clc; clear; close("all");

load('F0_PVT.mat');
pvt_data = vertcat(data.pressures, data.vibrations, data.temperatures)';
pvt_data = normalize(pvt_data, 1);

classes = {'acr', 'bla', 'car', 'flo', 'kit', 'ste'};

one_hots = [];
labels = data.names;
for n = 1:size(data.names, 2)
    s = string(data.names(n));
    idx = find(contains(classes, extractBefore(s,4)));
    one_hots(end + 1) = idx;
end

colours = {'c', 'r', 'g', 'b', 'm', 'k'};
kshapes = {'.', '|', '*', 'o', '^', 'd'};

%'Distance', 'cityblock'

ds = [];
for k = 1:6
    opts = statset('Display','final');
    [idx,C,sumd,D] = kmeans(pvt_data,k,'Replicates',5,'Options',opts);
    ds(end+1) = sum(sumd);
    
    figure;
    for i = 1:k
        d = pvt_data(idx==i,:);
        for c = 1:6
            oh = one_hots(idx==i);
            dc = d(oh==c,:);
            if size(dc, 1) > 0
                plot3(dc(:, 1), dc(:, 2), dc(:, 3), char([colours(c) kshapes(i)]),'MarkerSize',12)
                hold on;
            end
        end
    end
    title(sprintf("K-Means (K=%d) Clustering of the PVT data", i));
    plot3(C(:,1),C(:,2), C(:,3),'kx','MarkerSize',15,'LineWidth',3)
    xlabel("Pressure");
    ylabel("Vibration");
    zlabel("Temperature");
    hold off;
    
end

colours = {'c.', 'r.', 'g.', 'b.', 'm.', 'k.'};

figure;
for c = 1:6
    scatter3(pvt_data(one_hots == c, 1), pvt_data(one_hots == c, 2), pvt_data(one_hots == c, 3), char(colours(c)));
    hold on;
end
hold off;
xlabel("pressure");
ylabel("vibrations");
zlabel("temperature");
legend('acrylic', 'black foam', 'car sponge', 'flour sack', 'kitchen sponge', 'steel vase');


% figure;
% plot3(pvt_data(idx==1,1),pvt_data(idx==1,2),pvt_data(idx==1,3),'r.','MarkerSize',12)
% hold on
% plot3(pvt_data(idx==2,1),pvt_data(idx==2,2),pvt_data(idx==2,3),'b.','MarkerSize',12)
% plot3(C(:,1),C(:,2), C(:,3),'kx',...
%      'MarkerSize',15,'LineWidth',3) 
% legend('Cluster 1','Cluster 2','Centroids',...
%        'Location','NW')
% title 'Cluster Assignments and Centroids'
% hold off

figure
plot(ds);


%[eq_idx,eq_C,eq_sumd,eq_D] = kmeans(pvt_data,4,'Distance', 'sqeuclidean' ,'Replicates',5);
%[cb_idx,cb_C,cb_sumd,cb_D] = kmeans(pvt_data,4,'Distance', 'cityblock' ,'Replicates',5);
