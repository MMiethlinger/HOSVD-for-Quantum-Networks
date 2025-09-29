prec = 8;
count = 0;

for i = 1:10^0
    a = rand();
    b = rand();
    gamma = rand();
    rhoA1 = [a^2, 0; 0, 1-a^2];
    rhoB2 = [b^2, 0; 0, 1-b^2];
    state_gamma = pure_to_mixed([gamma, 0, 0, sqrt(1-gamma^2)]);
    state = Tensor(rhoA1,state_gamma,rhoB2);
    statePT = PartialTranspose(state);
    x1 = round(eig(statePT)', 8);
    
    dim = 4;
    [U_A, ~] = qr(randn(dim));
    U_A = conj(det(U_A))^(1/dim)*U_A;
    [U_B, ~] = qr(randn(dim));
    U_B = conj(det(U_B))^(1/dim)*U_B;
    
    state = Tensor(U_A, U_B)*state*Tensor(adjoint(U_A), adjoint(U_B));
    statePT = PartialTranspose(state);
    x2 = sort(round(eig(statePT)', 8));
    
    if x1==x2
        count = count + 1;
    end
end
count