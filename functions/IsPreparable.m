function isPreparable = IsPreparable(inputState, dim, N)
%IsPreparable(state) checks whether a state fulfills the criterion that we
%discovered.

%   We first check whether state has degenerate spectra at the level of the
%   parties, to ensure that our criterion still applies. Then we compute
%   the HOSVD of the state, followed by applying the unitaries determined
%   via the marginals, and then checking equivalence.
    numParties = numnodes(N);
    rel = 1e-14;

%   First we check if the state is even suitable for our criterion, i.e.,
%   does it have degenerate n-th mode spectra. For this we call
%   IsDegenerate.
    if IsDegenerate(inputState)==false
        disp("hell no")
        error('IsPreparable:Degenerate','The local spectra of the state must be non-degenerate.')
    end
    
%   Next step is to compute the HOSVD of the tensor of our state.
    state = hosvd(inputState,rel).core;

%   Now we need to compute the two party marginals and determine the
%   Schmidt coefficients from them.
    coeff = CoefficientsFromMarginals(state, dim, N);
    [reconstructedState, idx] = NetworkStateFromCoefficients(coeff, N);
    
    HOSVD = hosvd(reconstructedState, rel);
    unitaries = cell(numParties, 1);
    for i = 1:numParties
        unitaries{i} = HOSVD.U{i};
    end
    state = ttm(state, unitaries, 1:numParties);
    state = reshape(double(state), 1, []);
    state = PermuteSystems(state, idx);

%    state = reshape(double(reconstructedState), 1, []);
%    state = PermuteSystems(state, idx);

    numEdges = numedges(N);
    numSubsystems = 2*numEdges;
    subsystems = 1:numSubsystems;
    subsysDims = zeros(numSubsystems, 1) + reshape([dim; dim], [], 1);
    for i = 1:numEdges
        traceOut = subsystems;
        traceOut([2*i - 1, 2*i]) = [];
        sourceState = PartialTrace(state, traceOut, subsysDims);
        Purity(sourceState)
    end
end