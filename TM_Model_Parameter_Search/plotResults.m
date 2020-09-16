function [] = plotResults(p, ds, nSubj, nRepl,numGParams, numSParams, firstData, sOrder, eBarFlag, rNames)

numScenarios = nSubj/nRepl;
scenarioNames = fieldnames(ds);
%Preallocates matrix for grabbing the species initial values.
sInitVals = zeros(1, length(sOrder));
   
fHandles = 1:numScenarios;

ds = cell2mat(struct2cell(ds));

% Loop over scenarios
for i = 1:numScenarios
    
    %% Setup m1
    % This loop grabs the initial species values and sets them in the
    % model. For each species, I just grab the data of the first data point
    % and average it.
    for j = 1:length(sInitVals)
        temp = firstData{j,i};
        idx = ~isnan(temp);
        sInitVals(j) = mean(temp(idx)); 
    end
    
    %% 
    % I do a lot of index math here - I checked it all, should be working.
    % In hindsight, I probably could've just made use of a cell array for
    % some of this.
    % offset is for getting the right set of scenario parameters to input
    % into the simulation
    
    offset = numGParams + 1 + (i-1)*numSParams;

    % p0 are the values to be set in the model before the simulation,
    % including species initial values (sInitVals), global parameters
    % (p(1:numGParams)) and scenario parameters.
    p0 = [sInitVals p(1:numGParams) p(offset:offset+numSParams-1)];

    % Simulate
    [data,t, names] = simulateModel(p0);
    
    %Define times for observed data
    %obsTime = [0 1 5 15 30 60 120]'.*60;
    obsTime = [0 6 10 20 35 65 125]'.*60;
    obsTimeVels = [0	0.03	0.06	0.09	0.12	0.15	0.18	0.21	0.24	0.27	0.3	0.33	0.36	0.39	0.42	0.45	0.48	0.51	0.54	0.57	0.6	0.63	0.66	0.69	0.72	0.75	0.78	0.81	0.84	0.87	0.9	0.93	0.96	0.99	1.02 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 25 35 40 50 55 60 65 70 75 80 85 90 95 100 110 115 120 125]'.*60;
    % Removing the last time points
    %obsTime = [0 6]'.*60;
    
    obsData = struct2cell(ds(i));
    
    numS = numel(names);
    
    numRows = floor(sqrt(numS));
    numCols = ceil(sqrt(numS));
    
    
    if floor(numS/numCols)~= (numS/numCols)
        numRows= numRows+1;
    end
    
    %Velocity Stuff
%   assignin('base','times', obsTime);
    assignin('base','times', obsTimeVels);
    rateout;
    reactionTimes = evalin('base', 'times');
    reactionVels = evalin('base', 'vels');
    figure(i);
    title(strcat(scenarioNames(i), 'Velocities'));
    plot(reactionTimes./60,reactionVels, 'displayname', rNames);
    legend(rNames, 0);
    
    
    
    figure(i+numScenarios);
    
    for j = 1:numS 
        
        %Calculate means/std Devs and upper/lower error bars
        means = mean(obsData{j}, 2);
        stdDevs =  std(obsData{j}, 0, 2);
        
        U = means + stdDevs;
        L = means - stdDevs;
        
        %Since you can't have negative values in a log plot, this removes
        %negative values and sets them to a default 1E-4 (changable)
        negs = L<=0;
        L(negs) = 1E-4;
        
        
        
        % The horizontal lines on the error bars are too short/long 
        % if the x scale of the data and the x scale of the axes don't match.
        % So I use this to only plot the error bars that are within the x
        % limits of the plot. 
        %times = t < 125;
        times = 1:numel(t); 
        
        %Plot
        subplot(numRows, numCols, j);
        
        %Plot simulation results
        semilogy(t/60, data(:,j), 'b-');
        
        xlim([-10 135]);
        ylim([1E-3 1E3]);
        
        hold on;
        title(names(j));
        
        %Plot observed data
        semilogy(obsTime/60, means, 'ro');
        
        %Plot the error bars.
        if eBarFlag
            h = errorbar(obsTime(times)/60, means(times), L(times), U(times), 'k.');

            %Online black magic to get error bars to display.
            errorbarlogy;
        end      
    end
    suplabel(strrep(scenarioNames{i}, '_', '\_'), 't');
end

save reactionOutputs reactionTimes reactionVels rNames scenarioNames
end
