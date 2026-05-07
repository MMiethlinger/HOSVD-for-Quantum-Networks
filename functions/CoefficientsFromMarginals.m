function coeff = CoefficientsFromMarginals(inputState, dim, N)
%CoefficientsFromMarginals determines the Schmidt coefficients via the
%marginals and then outputs them.

%   First we need to compute the marginals of the state, as well as the
%   necessary information about the network graph
    state = double(inputState);
    dims = size(state);
    vector = reshape(state, 1, numel(state));
    parties = 1:numnodes(N);
    edges = table2array(N.Edges(:,1));
    coeff = zeros(max(dim), length(parties));


    for p = 1:length(edges)
%   For simplicity sake, we will compute the marginals, eigenvectors, and 
%   then Schmidt coefficients, source-by-source in a do-loop, rather than
%   in nested arrays (makes keeping track of the indices easier. We also
%   compute for each index the parties to trace out in this way
    traceOut = parties(~ismember(parties, edges(p, :)));
    marginal = PartialTrace(vector, traceOut, dims);
    %arrayfun(@(x) PartialTrace(vector'*vector, x, dims), [1,2,3], ...
    %'UniformOutput',false);
    
%   We can now compute the Eigenvectors for each matrix, and then get the
%   Schmidt coefficients from that. The d last columns of V are the
%   eigenvectors with finite eigenvalue.
        [V, ~] = eig(marginal);
        S = SchmidtDecomposition(V(:, end));
        S(S < 1e-15) = [];
        S(end+1:max(dim)) = 0;
        coeff(:, p) = S;
    end

end
%PartialTrace(vector'*vector, x, dims)