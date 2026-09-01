function isPure = allMarginalsPure(psi, tol)

if nargin < 2
    tol = 1e-10;
end

d = size(psi);
n = numel(d);
isPure = true;

for k = 1:n
%   Move subsystem k to the first dimension
    order = [k, 1:k-1, k+1:n];
    psi_k = permute(psi, order);

%   Reshape into subsystem k x all other subsystems
    psi_k = reshape(double(psi_k), d(k), []);

%   Reduced density matrix
    rho_k = psi_k * psi_k';

%   Check Tr(rho_k^2) = 1
    purity = real(trace(rho_k^2));

    if abs(purity - 1) > tol
        isPure = false;
        return;
    end
end
end