function isPreparable = IsPreparable(inputState)
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
    isPreparable = NonZeroElements(doubleState);
    
end