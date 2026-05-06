function state = NetworkStateFromCoefficients(coeff, N)
%This function computes a state vector from the Schmidt coefficients of the
%sources.

%   We do this simply by doing a do-loop over all links of the network in
%   some canonical order, and then just do the permutation of subsystems.
%   First we initialize the constants that we need. coeff is in the form of
%   a matrix, where each column corresponds to the Schmidt coefficients of
%   the corresponding source. We later need to do some permutations to get
%   the right ordering of subsystems for the parties and so on.
    numParties = numnodes(N);
    parties = 1:numParties;
    counters = zeros(numParties);
    edges = table2array(N.Edges(:,1));
    subsystems = zeros(2, 0);

    for e = 1:length(edges)
        
    end

end