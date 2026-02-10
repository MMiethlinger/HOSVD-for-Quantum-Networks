function isPreparable = IsPreparable(inputState, dim)
%IsPreparable(state) checks whether a state fulfills the criterion that we
%discovered.

%   We first check whether state has degenerate spectra at the level of the
%   parties, to ensure that our criterion still applies. Then we compute
%   the HOSVD of the state, followed by permutations as specificied and
%   lastly computing the Schmidt coefficients

    rel = 1e-14;

%   First we check if the state is even suitable for our criterion, i.e.,
%   does it have degenerate n-th mode spectra. For this we call
%   IsDegenerate.
    if IsDegenerate(inputState)==false
        disp("hell no")
    end
    
%   Next step is to compute the HOSVD of the tensor of our state.
    state = hosvd(inputState,rel).core;
    doubleState = double(state);

%   NonZeroElements gives us the indices of our non-zero elements in the
%   tensor
    nonZeros = NonZeroElements(doubleState);
    
%   Next we need to check for which permutation the tensor is brought into
%   the canonical form
%   For this we call a function which brute force tries all the
%   permutations and check if the tensor is in the canonical form then
    isPreparable = CheckPermutations(nonZeros, dim);

end