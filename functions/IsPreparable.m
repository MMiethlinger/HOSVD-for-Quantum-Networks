function isPreparable = IsPreparable(inputState)
%IsPreparable(state) checks whether a state fulfills the criterion that we
%discovered.
%   We first check whether state has degenerate spectra at the level of the
%   parties, to ensure that our criterion still applies. Then we compute
%   the HOSVD of the state, followed by permutations as specificied and
%   lastly computing the Schmidt coefficients

    rel = 1e-14;
    threshold = 10^-6;

    %First we check if the state is even suitable for our criterion, i.e.,
    %does it have degenerate n-th mode spectra. For this we call
    %IsDegenerate.
    if IsDegenerate(inputState)==false
        disp("hell no")
    end
    
    %Next step is to compute the HOSVD of the tensor of our state.
    state = hosvd(inputState,rel).core;
    doubleState = double(state);

    %We now need the set of indices of non-zero elements.
    v = find(abs(doubleState)>threshold);
    
    dims = length(doubleState) * ones(1, ndims(doubleState));
    subs = cell(1, ndims(doubleState));
    [subs{:}] = ind2sub(dims, v);
    subs = cell2mat(subs(:)');

    isPreparable = subs-1;
end