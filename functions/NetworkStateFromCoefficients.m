function [state, inv_idx] = NetworkStateFromCoefficients(coeff, N)
%This function computes a state vector from the Schmidt coefficients of the
%sources.

%   We do this simply by doing a do-loop over all links of the network in
%   some canonical order, and then just do the permutation of subsystems.
%   First we initialize the constants that we need. coeff is in the form of
%   a matrix, where each column corresponds to the Schmidt coefficients of
%   the corresponding source. We later need to do some permutations to get
%   the right ordering of subsystems for the parties and so on.
    numParties = numnodes(N);
    %parties = 1:numParties;
    counters = zeros(numParties, 1);
    edges = table2array(N.Edges(:,1));
    subsystems = zeros(2, 2*length(edges));
    state = ones(1);

%   subsystems is supposed to contain the initial ordering of the
%   subsystems when constructing the state. This is useful, because this
%   ordering can then be used to permute the subsystems into the by-Parties
%   ordering that is necessary for a generic network state. subsystems will
%   be a 2-by-2e array, where e is the number of edges. The first line
%   contains the label of the party, the second line the index indicating
%   the current subsystem of that party (i.e., the largest index indicates 
%   how many subsystems that party has access to).
    for e = 1:length(edges)
        state = kron(state, StateFromSchmidtCoefficients(coeff(:, e)));
        for i = 0:1
            p = edges(e, i + 1);
            counters(p) = counters(p) + 1;
            subsys = [p, counters(p)];
            subsystems(:, 2*e + i - 1) = subsys;
        end
    end
    [~, idx] = sortrows(subsystems.', [1 2]);
    %subsystemsSorted = subsystemsSorted.';
    inv_idx(idx) = 1:length(idx);
    idx = idx';

    state = PermuteSystems(state, idx);
    subsysDim = size(coeff, 1).^counters;
    state = tensor(reshape(state, subsysDim.'));
end