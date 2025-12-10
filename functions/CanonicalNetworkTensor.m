function elements = CanonicalNetworkTensor(dim)
%CanonicalNetworkTensor(dim) computes the non-zero elements of a network
%state in the canonical basis.

%   dim -> dimensions of sources given as input, which specify the 
%   entanglement dimensionality/# of Schmidt coefficients for each source. 
%   The function returns a matrix of non-zero elements of a generic network
%   state.

%   "schmidt coefficients" of states prepared by sources
    schmidtCoeff = ones(max(dim), length(dim));
    
%   matrix of indices where each Schmidt coefficient goes in our source
%   states, i.e., |ii>, i ∈ {0,...,d-1}. Here we change the index to be
%   one larger than the base-d integer ii would be, so 00 is 1, etc.
    basisElements = zeros(max(dim), length(dim));
    for i=1:size(basisElements, 2)
        basisElements(:, i) = (0:dim(i)-1)+dim(i)*(0:dim(i)-1) + 1;
    end

%   putting Schmidt coefficients where they are supposed to be in a
%   matrix, later later want to pass the states on as arguments for a
%   function so will create a cell-array, where the cells are the state
%   vectors
    states = zeros(max(dim)^2, length(dim));
    for i=1:size(basisElements, 2)
        states(basisElements(:,i), i) = schmidtCoeff(:,i);
    end
    cellstate = num2cell(states, 1);
    
%   state prepared by sources, permuted into parties, and reshaped into
%   needed tensor.
    state = Tensor(cellstate);
    state = PermuteSystems(state, [6, 1, 2, 3, 4, 5]);
    state = tensor(reshape(state, dim.^2));
    state = double(state);
    
    elements = NonZeroElements(state);

end