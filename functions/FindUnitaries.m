function unitary = FindUnitaries(realState, testState)
%findUnitaries finds the Unitaries necessary to cancel the complex phases
%that the HOSVD does not cancel

%   Construct the matrix of linear equations
    X = find(testState);
    [N, K] = size(X);
    M = max(X(:));
    rows = repmat((1:N)', K, 1);
    cols = X(:) + M * repelem((0:K-1)', N);
    vals = ones(N*K, 1);

%   Solve equations, with angles vals[i]
    T_sparse = sparse(rows, cols, vals, N, M*K);
    tol = 1e-10;
    state = double(realState);
    vals = -angle(state(abs(state) > tol));
    theta = T_sparse\vals;

%   Put into diagonal unitaries
    d = size(realState);
    idx = 0;

    U = cell(1, length(d));
    for k = 1:length(d)
        theta_k = theta(idx + 1 : idx + d(k));
        U{k} = diag(exp(1i * theta_k));
        idx = idx + d(k);
    end
    
    unitary = U;

    %unitary = U{1};
    %for k = 2:numel(U)
    %    unitary = kron(unitary, U{k});
    %end
end