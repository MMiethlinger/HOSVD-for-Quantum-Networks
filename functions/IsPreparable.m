function isPreparable = IsPreparable(inputState)
%IsPreparable(state) checks whether a state fulfills the criterion that we
%discovered.
%   We first check whether state has degenerate spectra at the level of the
%   parties, to ensure that our criterion still applies. Then we compute
%   the HOSVD of the state, followed by permutations as specificied and
%   lastly computing the Schmidt coefficients

    %First we check if the state is even suitable for our criterion, i.e.,
    %does it have degenerate n-th mode spectra. For this we write another 
    %function that outputs the corresponding boolean.
    CheckDegeneracy(inputState)

    isPreparable = false;

end