function g = MinSpectralGap(coeff, N)
    edges = table2array(N.Edges(:,1));
    g = inf;
    for p = 1:numnodes(N)
        sv = 1;
        for e = find(any(edges == p, 2)).'
            sv = kron(sv, coeff(:, e));
        end
        sv = sort(sv(sv > 0));
        g = min([g; diff(sv) ./ sv(2:end)]);
    end
end