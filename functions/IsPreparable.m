function [isPreparable, maxAbsDiff, info] = IsPreparable(inputState, dim, N)
%IsPreparable(state) checks whether a state fulfills the criterion that we
%discovered.

  % We first check whether state has degenerate spectra at the level of the
  % parties, to ensure that our criterion still applies. Then we compute
  % the HOSVD of the state, followed by applying the unitaries determined
  % via the marginals, and then checking equivalence.
    maxAbsDiff = NaN;
    info = struct('mag', NaN, 'cycle', NaN, 'final', NaN);
    numParties = numnodes(N);
    rel = 1e-13;

  % First we check if the state is even suitable for our criterion, i.e.,
  % does it have degenerate n-th mode spectra. For this we call
  % IsDegenerate.
    if IsDegenerate(inputState)==false
        disp("hell no")
        error('IsPreparable:Degenerate','The local spectra of the state must be non-degenerate.')
    end
    
  % Next step is to compute the HOSVD of the tensor of our state.
    state = hosvd(inputState, rel, 'verbosity', 0).core;

  % Now we need to compute the two party marginals and determine the
  % Schmidt coefficients from them. The discarded variable idx is necessary
  % for reordering the state into by-source ordering, in case one wants to
  % check state itself rather than compare its LU equivalence to
  % reconstructedState
    coeff = CoefficientsFromMarginals(state, dim, N);
    [reconstructedState, ~] = NetworkStateFromCoefficients(coeff, N);
    
    HOSVD = hosvd(reconstructedState, rel, 'verbosity', 0);
    unitaries = cell(numParties, 1);
    for i = 1:numParties
        unitaries{i} = HOSVD.U{i};
    end
    state = ttm(state, unitaries, 1:numParties);

  % Check 1: compare the absolute values of the core and of
  % reconstructedState. This check is necessary for preparability. Both
  % tensors are in the by-party ordering, so no permutation is needed.
    absTol = 1e-4;
    state_abs = abs(double(state));
    Rd = double(reconstructedState);
    maxAbsDiff = max(abs(state_abs(:) - Rd(:)));
    if maxAbsDiff > absTol
        isPreparable = false;
        return
    end

  % Check 2: find phases for each party such that the core equals
  % reconstructedState multiplied by these phases. FindPhaseUnitaries
  % compares both tensors on every entry of the support and returns
  % ok = false if no consistent phases exist. Together with check 1, which
  % covers the entries outside the support, this shows that the core and
  % reconstructedState are equal up to local diagonal unitaries.
    [~, ok, info] = FindPhaseUnitaries(state, reconstructedState, 1e-4, false);
    isPreparable = ok;

% The following is the original version that allows to check state itself,
% rather than comparing it to reconstructedState.

  % First check whether the state is preparable by comparing the absolute
  % values (necessary for preparability)
  %   state_abs = abs(double(state));
  %   if abs(state_abs - double(reconstructedState)) > ...
  %       rel*ones(size(state_abs))
  %       isPreparable = false;
  %       return
  %   end
  % 
  % Solve the equations that yield the phases for the diagonal
  % unitaries.
  %   T = state;
  %   R = reconstructedState;
  %   save('tensors.mat', 'T', 'R', '-v7');
  %   warnState = warning('on', 'MATLAB:rankDeficientMatrix');
  %   [U, ~] = FindPhaseUnitaries(state, reconstructedState, 1e-9, true);
  %   warning(warnState);
  %   phaseUnitary = cellfun(@diag, U, 'UniformOutput', false);
  %   Uinv = cellfun(@ctranspose, phaseUnitary, 'UniformOutput', false);
  %   state = ttm(state, Uinv);
  % 
  % Order state into partitioning by sources
  %   state = reshape(double(state), 1, []);
  %   state = PermuteSystems(state, idx);
  %   state = reshape(state, size(reconstructedState));
  % 
  % Checking purity
  %   isPreparable = AllMarginalsPure(state);

end