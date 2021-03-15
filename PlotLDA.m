function [Mdl] = PlotLDA(X, label, variables)
    figure;
    scatter(X(1:10,1), X(1:10,2), 10, 'r', 'filled'); hold on
    scatter(X(11:20,1), X(11:20,2), 10, 'g', 'filled');
    xlabel(variables(1));
    ylabel(variables(2));
    legend({'black foam', 'car sponge'}, 'Location', 'southeast');

    % Fit LDA
    Mdl = fitcdiscr(X,label);
    K1 = Mdl.Coeffs(1,2).Const;
    L1 = Mdl.Coeffs(1,2).Linear;
    disp(K1);
    disp(L1);
    
    f = @(x1,x2) K1 + L1(1)*x1 + L1(2)*x2;
    h2 = fimplicit(f);
    h2.Color = 'b';
    h2.LineWidth = 2;
    h2.DisplayName = 'Boundary between black foam & car sponge';
end