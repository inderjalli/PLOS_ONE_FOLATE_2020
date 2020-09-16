function [f, yPred] = objectiveFcn(p, yObs, nSubj, nRepl, numGParams, numSParams, LL, UL, firstData, sOrder)
% p     - parameter 
% yObs  - Observed response 
% nSubj - number of subjects in the dataset 
% yPred - predicted response 
% f     - value of the objective function 

% Preallocate for simulation output. nSubj is # of replicates * number of
% scenarios.
yPred = cell(1,nSubj);
nCols = size(yObs, 2);

speciesWeight = [1	1	1	1	1	1	100	100	1	1	1	1	1	1	1	1	1	1];

if nCols ~= length(speciesWeight)
    error('Invalid species weight vector')
end
%Normalize weights
speciesWeight = speciesWeight/sum(speciesWeight);

numScenarios = nSubj/nRepl;

%Preallocates matrix for grabbing the species initial values.
sInitVals = zeros(1, length(sOrder));

%Timeout flag, if set to 1, skips the remaining simulations.
timeout = 0;

% Loop over scenarios
for i = 1:numScenarios
    %i
    
    %% Setup m1 and export
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

    % Offset for indexing the yPred matrix
    cellOffset = ((i-1)*nRepl) + 1;

    % Simulate
    data = simulateModel(p0);
    
    %This is for checking if a simulation didn't finish before timeout, I
    %could check by checking the number of rows in the simulation 
%     [r c ] = size(data);
%     
%     if r ~= 7
%        timeout = 1;
%        break; 
%     end
    
%     for j = 1:nCols
%         data( data(:, j) > UL(j), j) = UL(j);
%         data( data(:, j) < LL(j), j) = LL(j);
%     end

    %Copies the simulation output into a number of cells equal to the
    %number of replicates, so that all replicates of a scenario are
    %compared to the same simulation output
    
    [yPred{cellOffset:(cellOffset -1 + nRepl)}] = deal(data);
end

%Default fitness value for timeout case.
f = 1e20;

if ~timeout
    % Concatenate the contents of yPred vertically, making the format the
    % same as the data.
    yPred = vertcat(yPred{1:end});
    
    % Identify non-nan values in yObs
    idx = ~isnan(yObs) ;
    idx2 = ~isnan(yPred);
    
    % Objective function: sum of squared errors
    % Inder note 6/13/14
    % This isn't normalized, and it's usually good to normalize a obj fxn
    %f = sum(sum((yPred(idx) - yObs(idx)).^2)) ;
    f=0;
    yObsTemp =  yObs;
    yObsTemp(~idx) =  0;
    yObsTemp =  reshape(yObsTemp,size(yObs));
    
    yPredTemp =  yPred;
    yPredTemp(~idx) =  0;
    yPredTemp =  reshape(yPredTemp,size(yPred));

    for idx2=1:1:size(yObsTemp,2)  
        normConstant = sum((yObsTemp(:,idx2).^2));
        if normConstant==0 
            normConstant = 1;
            warning('One of your scenarios has bad data. Inspect and remove.')
        end
        % Tim's objective fxn
		% f = f + sum((yPredTemp(:,idx2) - yObsTemp(:,idx2)).^2)/normConstant;
		% Andre's objective fxn
		 f = f + speciesWeight(idx2)*sum((yPredTemp(:,idx2) - yObsTemp(:,idx2)).^2)/normConstant;
    end
    % f=f/size(yObsTemp,2)    ...meant to be here.
% end


end 