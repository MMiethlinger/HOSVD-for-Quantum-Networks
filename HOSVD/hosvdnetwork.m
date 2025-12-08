addpath( ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\QETLAB-0.9"), ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\tensor_toolbox-v3.6"), ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\GitHub\" + ...
    "HOSVD-for-Quantum-Networks\functions") ...
    )

rand_num = sort(rand([3,1]), "descend");
%rand_num = [0,0,0];
alpha = 1/sqrt(2) + (1-1/sqrt(2))*rand_num(1);
beta = 1/sqrt(2) + (1-1/sqrt(2))*rand_num(2);
gamma = 1/sqrt(2) + (1-1/sqrt(2))*rand_num(3);
threshold = 1e-14;

state_alpha = transpose([alpha, 0, 0, sqrt(1-alpha^2)]);
state_beta = transpose([beta, 0, 0, sqrt(1-beta^2)]);
state_gamma = transpose([gamma, 0, 0, sqrt(1-gamma^2)]);
% fprintf(sprintf('%d ',state_alpha));

coeff = Tensor(state_alpha, state_beta, state_gamma);
coeff = PermuteSystems(coeff, [4, 5, 6, 1, 2, 3]);
coeff = tensor(reshape(coeff, [4, 4, 4]));
T = hosvd(coeff, threshold);
mod_squared = abs(double(full(T.core))).^2;
%non_zero_mod_squared = mod_squared(mod_squared > threshold);
% non_zero_mod_squared;


U_A = RandomUnitary(4);
U_B = RandomUnitary(4);
U_C = RandomUnitary(4);

coeff = Tensor(state_alpha, state_beta, state_gamma);
coeff = Tensor(U_A, U_B, U_C)*PermuteSystems(coeff, [4, 5, 6, 1, 2, 3]);
coeff = tensor(reshape(coeff, [4, 4, 4]));
T1 = hosvd(coeff, threshold);
mod_squared1 = abs(double(full(T1.core))).^2;
%non_zero_mod_squared = mod_squared1(mod_squared1 > threshold);
% non_zero_mod_squared;


% mod_squared
% mod_squared1
same = isapprox(mod_squared, mod_squared1, "tight");
isequal(zeros(size(same)) + 1, same)