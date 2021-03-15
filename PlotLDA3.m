function [Mdl] = PlotLDA3(X, label, variables, names)
    figure;
    scatter3(X(1:10,1), X(1:10,2), X(1:10,3), 10, 'r', 'filled'); hold on
    scatter3(X(11:20,1), X(11:20,2), X(11:20,3), 10, 'g', 'filled'); 
    xlabel(variables(1));
    ylabel(variables(2));
    zlabel(variables(3));
    legend(names);
    
    % Fit LDA
    Mdl = fitcdiscr(X,label);
    K1 = Mdl.Coeffs(1,2).Const;
    L1 = Mdl.Coeffs(1,2).Linear;
    
    f1 = @(x1,x2, x3) K1 + L1(1)*x1 + L1(2)*x2 + L1(3)*x3;
    fs = fimplicit3(f1);
    fs.EdgeColor = 'b';
    fs.FaceColor = 'b';
    fs.FaceAlpha = 0.25;
    fs.DisplayName = sprintf('Hyperplane between \n %s & %s', char(names(1)), char(names(2)));
end