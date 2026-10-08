% As a first order of business, to work with this thing and to make our
% lives easier, we utilize QETLAB and tensor toolbox, so let me add this to
% the path so I don't forget everytime I open this thing up. Also we add the
% folder that contains the functions that we are creating.
addpath( ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\QETLAB-1.0"), ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\tensor_toolbox-v3.6"), ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\GitHub\" + ...
    "HOSVD-for-Quantum-Networks\functions") ...
    )

% Now we want to initialize a network-preparable state, in this case with
% three bipartite sources (but it is also possible to add more bipartite 
% sources using the adjacencymatrix), that each prepare a state with a 
% number of Schmidt coefficients d. In principal one could impose a 
% different dimension for each source.
%d = 2;
%connectivity = [0, 1, 1; 1, 0, 1; 1, 1, 0];
%N = graph(connectivity);
% labelnode(N, N.Nodes, char(65:64 + numnodes(N)))
%dim = zeros(1, size(connectivity, 1)) + d;
% plot(N)

% Calling the function to get the state and Schmidt coefficients
%[test, coeff] = RandomNetworkState(dim, N);

% Testing the IsPreparable function
%IsPreparable(test, dim, N)

%dimNum = 8;
%t = zeros(dimNum + 1);
%var = zeros(dimNum + 1);
%for dim = d:dimNum+d
%    [ti, vari] = AvgRuntime(connectivity, dim, 10^1);
%    t(dim) = ti;
%    var(dim) = vari;
%end


%dims       = [2 3 4 5 6 7 8 9 10];
%numTrials  = [2000000 1048544 303371 48085 6526 784 80 25 10];
%numTrials  = 2*[1 1 1 1 1];
%means     = zeros(1, length(dims));
%variances = zeros(1, length(dims));

dim = 2;
%numTrials  = 10*ones(1, 10);
numTrials = (1);
%networkSize = [3,4,5,6,7,8,9,10];
networkSize = (5);
means     = zeros(1, length(networkSize));
variances = zeros(1, length(networkSize));

for idx = 1:length(networkSize)
    connectivity = ones(networkSize(idx))-eye(networkSize(idx));
    fprintf('--- starting Size = %d, numTrials = %d ---\n', networkSize(idx), numTrials(idx));
    [means(idx), variances(idx)] = AvgRuntime(connectivity, dim, numTrials(idx));
end