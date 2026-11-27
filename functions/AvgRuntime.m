function [avgRuntime, varRuntime] = AvgRuntime(Connectivity, dim, numTrials)
% Handles calling the method multiple times for a given dimension and
% network.

networkSize = size(Connectivity, 1);
N = graph(Connectivity);
% labelnode(N, N.Nodes, char(65:64 + numnodes(N)))
d = zeros(1, numedges(N)) + dim;
times = zeros(1, numTrials);
numFailed = 0;

gaps     = nan(1, numTrials);
maxDiffs = nan(1, numTrials);
failed   = false(1, numTrials);
threw    = false(1, numTrials);
infoMag = nan(1,numTrials); 
infoCycle = nan(1,numTrials); 
infoFinal = nan(1,numTrials);
minCoeff = nan(1, numTrials);

for trial = 1:numTrials
    if mod(trial, 20000) == 0
        save(sprintf('diagnostics_partial_size%d_dim%d.mat', networkSize, dim), ...
     'gaps', 'maxDiffs', 'failed', 'threw', 'times', 'infoMag', 'infoCycle', 'infoFinal','minCoeff');
    end
    seedState = rng;   % snapshot the RNG state before this trial's randomness is drawn
    
    % Calling the function to get a state
    [test, coeff] = RandomNetworkState(d, N);
    gaps(trial) = MinSpectralGap(coeff, N);
    minCoeff(trial) = min(coeff(:));
    t0 = tic;
    
    try
        [result, maxDiffs(trial), info] = IsPreparable(test, d, N);
        infoMag(trial) = info.mag;  
        infoCycle(trial) = info.cycle;  
        infoFinal(trial) = info.final;
    catch ME
        threw(trial) = true;
        failed(trial) = true;
        fprintf('Error: %s\n', ME.message);
        for s = 1:numel(ME.stack)
        fprintf('  in %s (line %d)\n', ME.stack(s).name, ME.stack(s).line);
        end
        %save(sprintf('failcase_trial%d.mat', trial), 'seedState', 'dim', 'numTrials');
        save(sprintf('failcase_size%d_dim%d_trial%d.mat', networkSize, dim, trial), 'seedState', 'networkSize', 'dim', 'numTrials');
        numFailed = numFailed + 1;
        continue;
    end

    times(trial) = toc(t0);

    if result == 0
        failed(trial) = true;
        save(sprintf('failcase_size%d_dim%d_trial%d.mat', networkSize, dim, trial), 'seedState', 'networkSize', 'dim', 'numTrials');
        numFailed = numFailed + 1;
        continue;
    end
end


successfulTimes = times(times > 0);
ts = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
save(sprintf('diagnostics_size%d_dim%d_n%d_%s.mat', networkSize, dim, numTrials, ts), ...
     'gaps', 'maxDiffs', 'failed', 'threw', 'times', 'infoMag', 'infoCycle', 'infoFinal','minCoeff');
filename = sprintf('successful_times_size%d_dim%d_n%d_%s.mat', networkSize, dim, numTrials, ts);
save(filename, 'successfulTimes');

completedTimes = times(times > 0);
%completed      = numel(completedTimes);
avgRuntime    = mean(completedTimes);
varRuntime    = var(completedTimes);
%fprintf('Average runtime over %d completed trials: %.4f s\n', completed, avgRuntime);
