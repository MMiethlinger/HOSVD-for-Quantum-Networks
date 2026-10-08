function [state, schmidtCoeff] = RandomNetworkState(dim, N)
%PrepareRandomNetworkState(dim) computes a random network-separable state. 
%   dim -> dimensions of sources given as input, which specify the 
%   entanglement dimensionality/# of Schmidt coefficients for each source. 
%   The function returns the state in tensor form and a matrix of Schmidt 
%   coefficients, where the columns correspond to the sources and the rows 
%   show each Schmidt coefficient.

%   schmidt coefficients of states prepared by sources + normalization
    schmidtCoeff = rand(max(dim), length(dim));
    weights = vecnorm(schmidtCoeff);
    schmidtCoeff = sort(schmidtCoeff./weights, 'descend');
    
    [state, ~] = NetworkStateFromCoefficients(schmidtCoeff, N);

%   unitaries by parties
    unitaries = arrayfun(@(x) RandomUnitary(x), size(state), 'uni', 0);

%   Multiply each mode of the tensor with random unitaries next
    state = ttm(state, unitaries);
    
end