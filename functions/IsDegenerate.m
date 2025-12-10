function isDegenerate = IsDegenerate(inputTensor)
%CheckDegeneracy(state) checks whether the n-th mode spectra of a tensor
%are degenerate, i.e., if there are repeated singular values.

%   Very straightforward, compute the SVD for each mode using the 
%   corresponding function and check for degeneracy.

%   First we call the function that returns a matrix where column n
%   contains the n-th mode singular values. Then we just multiply with the
%   value of the uniqueness of each of the singular values, i.e., if all
%   are unique, then the output will be true.
    nmodeSVDs = Compute1ModeSVDs(inputTensor);
    isDegenerate = true;
    for i = 1:ndims(nmodeSVDs)
        [~, singularvalues] = find(nmodeSVDs(i, :, :));
        isDegenerate = and(isDegenerate,allunique(singularvalues));
    end
end