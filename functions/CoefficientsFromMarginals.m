function coeff = CoefficientsFromMarginals(state)
%CoefficientsFromMarginals determines the Schmidt coefficients via the
%marginals and then outputs them.

%   First we need to compute the marginals of the state.
    dims = size(state);
    vector = reshape(state, 1, numel(state));

%   For simplicity sake, we will compute the marginals, eigenvectors, and 
%   then Schmidt coefficients, source-by-source in a do-loop, rather than
%   in nested arrays (makes keeping track of the indices easier.
    marginal = ... %PartialTrace(vector'*vector, 1, dims)
    arrayfun(@(x) PartialTrace(vector'*vector, x, dims), [1,2,3], ...
    'UniformOutput',false);
    
%   We can now compute the Eigenvectors for each matrix, and then get the
%   Schmidt coefficients from that. The d last columns of V are the
%   eigenvectors with finite eigenvalue.
    [V, ~] = eig(cell2mat(marginal(1)));
    S = SchmidtDecomposition(V(:, end))


    
    coeff = 1;


end
%PartialTrace(vector'*vector, x, dims)