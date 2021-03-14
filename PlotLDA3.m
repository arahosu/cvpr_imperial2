function [Mdl] = PlotLDA3(X, label, variables)
    figure;
    scatter3(X(1:10,1), X(1:10,2), X(1:10,3), 'r'); hold on
    scatter3(X(11:20,1), X(11:20,2), X(11:20,3), 'g'); 
    xlabel(variables(1));
    ylabel(variables(2));
    zlabel(variables(3));
    legend({'black foam', 'car sponge'});

    % Fit LDA
    Mdl = fitcdiscr(X,label);
    K = Mdl.Coeffs(2,1).Const;
    L = Mdl.Coeffs(1,2).Linear;
    
    f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
    fsurf(f);
end