function isDegenerate = CheckDegeneracy(inputTensor)
%CheckDegeneracy(state) checks whether the n-th mode spectra of a tensor
%are degenerate, i.e., if there are repeated singular values.
%   Very straightforward, compute the SVD for each mode using the 
%   corresponding function and check for degeneracy.

    %First we call the function that returns a matrix where column n
    %contains the n-th mode singular values.
    Compute1ModeSVDs(inputTensor)
end