function [state, schmidtCoeff] = PrepareRandomNetworkState(dim)
%PrepareRandomNetworkState(dim) computes a random network-separable state. 
%   dim -> dimensions of sources given as input, which specify the 
%   entanglement dimensionality/# of Schmidt coefficients for each source. 
%   The function returns the state in tensor form and a matrix of Schmidt 
%   coefficients, where the columns correspond to the sources and the rows 
%   show each Schmidt coefficient.

    %unitaries by parties
    unitaries = arrayfun(@(x) RandomUnitary(x^2), dim, 'uni', 0);

    %schmidt coefficients of states prepared by sources + normalization
    schmidtCoeff = rand(max(dim), length(dim));
    weights = vecnorm(schmidtCoeff);
    schmidtCoeff = sort(schmidtCoeff./weights, 'descend');
    
    %matrix of indices where each Schmidt coefficient goes in our source
    %states, i.e., |ii>, i ∈ {0,...,d-1}. Here we change the index to be
    %one larger than the base-d integer ii would be, so 00 is 1, etc.
    elements = zeros(max(dim), length(dim));
    for i=1:size(elements, 2)
        elements(:, i) = (0:dim(i)-1)+dim(i)*(0:dim(i)-1) + 1;
    end

    %putting Schmidt coefficients where they are supposed to be in a
    %matrix, later later want to pass the states on as arguments for a
    %function so will create a cell-array, where the cells are the state
    %vectors
    states = zeros(max(dim)^2, length(dim));
    for i=1:size(elements, 2)
        states(elements(:,i), i) = schmidtCoeff(:,i);
    end
    cellstate = num2cell(states, 1);
    
    %state prepared by sources, permuted into parties, and reshaped into
    %needed tensor.
    state = Tensor(cellstate);
    state = PermuteSystems(state, [6, 1, 2, 3, 4, 5]);
    state = tensor(reshape(state, dim.^2));
    
    %Multiply each mode of the tensor with random unitaries next
    state = ttm(state, unitaries, [1, 2, 3]);
    
end