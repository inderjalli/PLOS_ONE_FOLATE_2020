function [yPredI, t, names] = simulateModel(p)
% Simulates model and returns yPred for iSubj at parameter value p

%% 
% In this section, we make the model and dataset persistent variables to
% avoid passing them as inputs to function at every call. This modification
% has been made to improve performance.

% The code checks for existence of these variable in the function workspace
% and only loads them from mat file if they don't already exist. Since
% these variable have been declared persistent they will be stored in the
% function workpace and will be available for subsequent calls to this
% function. 


persistent m1Exp 

if isempty(m1Exp) % Check if m1Exp exists 
    
    % Load data and model
    load exportedModel m1Exp
    
end

%% Simulation 

% Set values of parameters to be estimated to value in current iteration, p

m1Exp.InitialValues = p ;

% Set sampling time for iSubj
% m1Exp.SimulationOptions.OutputTimes = [0 1 5 15 30 60 120]'.*60;
m1Exp.SimulationOptions.OutputTimes = [0 6 10 20 35 65 125]'.*60;
% Removing the last time points
% m1Exp.SimulationOptions.OutputTimes = [0 6]'.*60;

% Simulate 
[t, yPredI, names] = simulate(m1Exp) ;
