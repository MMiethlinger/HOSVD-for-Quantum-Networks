%Here we want to define a function that computes a random network-separable
%state, based on the dimensions given as input, which specify the
%entanglement dimensionality/# of Schmidt coefficients for each source.

function state = randnetworkstate(dim)
    %unitaries by parties
    unitaries = arrayfun(@(x) RandomUnitary(x^2), dim, 'uni', 0);

    %schmidt coefficients of states prepared by sources + normalization
    schmidt_coeff = rand(max(dim), length(dim));
    weights = vecnorm(schmidt_coeff);
    schmidt_coeff = schmidt_coeff./weights;
    
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
        states(elements(:,i), i) = schmidt_coeff(:,i);
    end
    cellstate = num2cell(states, 1);
    
    %state prepared by sources, but we only need the tensor for later
    %purposes, so we will instead contruct the tensor, rather than do
    %further computations with the state vector itself.
    %state = dec2base(find(Tensor(cellstate))-1, dim(1)^2)
end