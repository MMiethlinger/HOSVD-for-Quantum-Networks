function nonZeroElements = NonZeroElements(inputState)
%NonZeroElements(inputState) outputs the indices of the non-zero elements
%of tensor inputState.

%   We just need to find the elements of our tensor which are smaller than
%   our threshold.

    threshold = 10^-6;
    ndim = ndims(inputState);
    
%   Compute the linear indices of the elements, the absolute value of which is
%   larger than our threshold
    v = find(abs(inputState)>threshold);
    
%   Compute empty array to put stuff into. Create Cell array to transform
%   the linear indices into mode indices and save them in matrix
    dims = length(inputState) * ones(1, ndim);
    subs = cell(1, ndim);
    [subs{:}] = ind2sub(dims, v);
    subs = cell2mat(subs(:)');
    
%   Return mode indices in QI-Computational basis.
    nonZeroElements = subs-1;

end