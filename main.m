%As a first order of business, to work with this thing and to make our
%lives easier, we utilize QETLAB and tensor toolbox, so let me add this to
%the path so I don't forget everytime I open this thing up. Also we add the
%folder that contains the functions that we are creating.
addpath( ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\QETLAB-0.9"), ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\tensor_toolbox-v3.6"), ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\GitHub\" + ...
    "HOSVD-for-Quantum-Networks\functions") ...
    )

%Now we want to initialize a network-preparable state, in this case with
%three bipartite sources, that each prepare a state with a number of
%Schmidt coefficients d. In principal one could impose a different
%dimension for each source.
num_sources = 3;
d = 2;
dim = zeros(1, num_sources) + d;

%Calling the function to get the state and Schmidt coefficients
[test, coeff] = PrepareRandomNetworkState(dim);

test1 = Compute1ModeSVDs(test);
for i = 1:ndims(test1)
    test1(i, :, :)
end
sum(sum((double(test1(1,:,:).^2))))