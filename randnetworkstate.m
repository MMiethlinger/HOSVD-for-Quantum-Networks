%Here we want to define a function that computes a random network-separable
%state, based on the dimension given as input

function state = randnetworkstate(dim)
    %unitaries by parties
    unitaries = arrayfun(@(x) RandomUnitary(x^2), dim, 'uni', 0);

    %schmidt coefficients of states prepared by sources
    schmidt_coeff = rand(max(dim), length(dim));
    weights = vecnorm(schmidt_coeff);
    schmidt_coeff = schmidt_coeff./weights;
    
    elements = zeros(max(dim), length(dim));
    for i=1:size(elements, 2)
        elements(:, i) = (0:dim(i)-1)+dim(i)*(0:dim(i)-1) + 1;
    end

    states = zeros(max(dim)^2, length(dim));
    for i=1:size(elements, 2)
        states(elements(:,i), i) = schmidt_coeff(:,i);
    end
    cellstate = num2cell(states, 1);
    cellstate{:}

    %states at sources
end