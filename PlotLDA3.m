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
    K = Mdl.Coeffs(1,2).Const;
    L = Mdl.Coeffs(1,2).Linear;
    
    f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
    fs = fsurf(f);
    fs.EdgeColor = 'b';
    fs.FaceColor = 'b';
    fs.FaceAlpha = 0.25;
    fs.DisplayName = sprintf('Hyperplane between %s & %s', char(names(1)), char(names(2)));

end