function [avgRuntime, varRuntime] = AvgRuntime(Connectivity, dim, numTrials)
% Handles calling the method multiple times for a given dimension and
% network.

networkSize = size(Connectivity, 1);
N = graph(Connectivity);
% labelnode(N, N.Nodes, char(65:64 + numnodes(N)))
d = zeros(1, numedges(N)) + dim;
times = zeros(1, numTrials);
numFailed = 0;


for trial = 1:numTrials
    % Calling the function to get a state
    [test, ~] = RandomNetworkState(d, N);
    t0 = tic;
    
    seedState = rng;   % snapshot the RNG state before this trial's randomness is drawn
    try
        result = IsPreparable(test, d, N);
    catch ME
        fprintf('Error: %s\n', ME.message);
        for s = 1:numel(ME.stack)
        fprintf('  in %s (line %d)\n', ME.stack(s).name, ME.stack(s).line);
        end
        %save(sprintf('failcase_trial%d.mat', trial), 'seedState', 'dim', 'numTrials');
        save(sprintf('failcase_trial%d.mat', trial), 'seedState', 'networkSize', 'numTrials');
        numFailed = numFailed + 1;
        continue;
    end

    times(trial) = toc(t0);

    if result == 0
        save(sprintf('failcase_trial%d.mat', trial), 'seedState', 'networkSize', 'numTrials');
        numFailed = numFailed + 1;
        continue;
    end
end


successfulTimes = times(times > 0);
ts = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
filename = sprintf('successful_times_size%d_n%d_%s.mat', networkSize, numTrials, ts);
save(filename, 'successfulTimes');

completedTimes = times(times > 0);
%completed      = numel(completedTimes);
avgRuntime    = mean(completedTimes);
varRuntime    = var(completedTimes);
%fprintf('Average runtime over %d completed trials: %.4f s\n', completed, avgRuntime);
