function state = StateFromSchmidtCoefficients(coeff)
%This function computes a pure state vector from some Schmidt coefficients.

%   This is pretty, straightforward, we first make a diagonal matrix with
%   the coefficients and then we convert it into a 1 x d^2 array.
    state = diag(coeff);
    state = reshape(state, 1, []);
end