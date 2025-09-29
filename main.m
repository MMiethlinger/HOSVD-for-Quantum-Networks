%As a first order of business, to work with this thing and to make our
%lives easier, we utilize QETLAB and tensor toolbox, so let me add this to
%the path so I don't forget everytime I open this thing up.

addpath(genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\QETLAB-0.9"), ...
    genpath( ...
    "C:\Users\MIETHLINGER\Documents\MATLAB\tensor_toolbox-v3.6"))

%Now we want to initialize a network-preparable state, for this we will
%prepare a separate file containing a function that returns a vector of a
%network separable state, in this case randomly chosen, with the dimension
%of the subsystems prepared by each source specified here.

%The way that I have been writing the code, its also possible to impose a
%different dimension on each source, but for simplicity sake, I kept it at
%the same dimension

num_sources = 3;
d = 4;
dim = zeros(1, num_sources) + d;


a = randnetworkstate(dim)