%% runOpt.m 
% m1 - SimBiology Model Object
% ds - dataBean
% nSubj - Number of total experiments
% nRepl - Number of replicates in each scenario
% gParams - list of global parameters. Should be an array of simBiology
% parameter objects
% sParams - list of scenario parameters. Should be array of simBiology
% parameter Objects
% gEst - horizontal vector of global parameter estimates.
% sEst - Horizontal cell array of horizontal vectors. Each vector is a list
% of estimates for that scenario
% gLB - horizontal vector of lower bounds for global parameters.
% sLB - horizontal cell array of horizontal vectors. Each vector is a list
% of bounds for that scenario's specific parameters.
% gUB - horizontal vector of upper bounds for global parameters
% sUB - horizontal cell array of horizontal vectors. Each vector is a list
% of bounds for that scenario's specific parameters.
%
%

function [output, fitVal] = singleDrug_Optimization_GA(m1, ds, species, LL, UL, gParams, sParams, gEst, sEst, gLB, sLB, gUB, sUB, sOrder)
%% Setup

ds2 = ds;

sNames = fieldnames(ds);
numScenarios = length(sNames);

s = ds.(sNames{1});
speciesNames = fieldnames(s);
numSpecies = length(fieldnames(s));

tempSpecies = s.(speciesNames{1});
[nPoints, nRepl] = size(tempSpecies);

nSubj = nRepl * numScenarios;
firstData = getFirstData(ds);
% Reformat data
ds = reshapeData(ds, numScenarios, nRepl, numSpecies, nPoints);

% Apply limits to data
%nCols = size(ds, 2);

% for j = 1:nCols
%     ds( ds(:, j) > UL(j), j) = UL(j);
%     ds( ds(:, j) < LL(j), j) = LL(j);
% end

% Get number of Global/Scenario Parameters
numGParams = length(gParams);
numSParams = length(sParams);

% GA number of variables to optimize
nvars = numGParams + numScenarios * numSParams;

% Setup model
ps = [species' gParams sParams];

%Set config settings.
cfgset = m1.getconfigset;
set(cfgset, 'SolverType', 'ode15s');
slvopts = get(cfgset, 'SolverOptions');
set(slvopts, 'AbsoluteToleranceScaling', 1); ... normally 0, was 0 
rnopts = get(cfgset, 'RuntimeOptions');
set(rnopts, 'StatesToLog', species);
set(slvopts, 'RelativeTolerance', 1e-8); ...normally -2, was -8
set(slvopts, 'AbsoluteTolerance', 1e-8); ... normally -3, was -8
set(cfgset, 'MaximumWallClock', 40);

% Creating exported m1, and accelerating
m1Exp = export(m1, ps);
%accelerate(m1Exp);
%% Save m1Exp and ds to a mat file 
save exportedModel m1Exp

%% Initial estimate and optim options
p0  = [ gEst cell2mat(sEst) ]; % initial estimate
lb  = [ gLB cell2mat(sLB)   ]; % lower bound
ub  = [ gUB cell2mat(sUB)   ]; % upper bound
A   = []                     ; % 
b   = []                     ; % 
Aeq = []                     ; % 
beq = []                     ; % 
nlc = []                     ; % 

% Optimization: fmincon 
opt2 = optimset(@fmincon);
opt2 = optimset(opt2, ...
                   'Display'        , 'iter'            , ... %Iterations should be displayed
                   'Algorithm'      , 'interior-point'  , ... %Optimization Algorithm that should be used
                   'FinDiffRelStep' , m1Exp.SimulationOptions.RelativeTolerance ,.... %Step size factor
                   'TolFun'         , 1e-4             ,... %Term toler on the functionvalue, a positive scalar, norm = -5, was -5
                   'TolX'           , 1e-4             ,... %Term tol on x, a +ve scalar, norm -6, was -6
                   'MaxFunEvals'    , 1e10);
               
%% Optimization: GA
opt1 = gaoptimset;
opt1.PopulationSize = 5;
opt1.UseParallel = 'always';
opt1.TolFun = 1e-8; %Term toler on the functionvalue. was -6 
opt1.TolX =  1e-8;  %Term tol on x. was -6
                   

% opt1.Generations = 2;
opt1.PlotFcns = @gaplotscores;
% opt1.InitialPopulation = [p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0 ];
opt1.InitialPopulation = [p0; p0; p0; p0; p0 ];
% opt1.InitialPopulation = [p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0; p0];
% Time limit for GA work in seconds (Default: 1 day))
opt1.TimeLimit =  86400;
% Stall limit if the objective funciton doesn't improve (Default: 3 hrs)
opt1.StallTimeLimit = 1080;

errorBarFlag = 1;

% Create function handle
fh = @(p) objectiveFcn(p, ds, nSubj, nRepl,numGParams, numSParams, UL, LL, firstData, sOrder) ;

% Run optimization 
% [pFit_GA, fitVal] = fmincon(fh, p0, A, b, Aeq, beq, lb, ub, nlc, opt2) ;
% [pFit_GA, fitVal] = ga(fh, nvars, A, b, Aeq, beq, lb, ub, nlc, opt1);

[reactionObj, names] = getActiveReactions(m1);

% Trying to combine GA and fmincon:
[pFit_GA_p0, fitVal] = ga(fh, nvars, A, b, Aeq, beq, lb, ub, nlc, opt1);
[pFit_GA, fitVal] = fmincon(fh, pFit_GA_p0, A, b, Aeq, beq, lb, ub, nlc, opt2) ;

plotResults(pFit_GA, ds2, nSubj, nRepl,numGParams, numSParams, firstData, sOrder, errorBarFlag, names);

% Evaluate prediction at estimated parameters 
% [~, ds.predTumor_FMC] = objectiveFcn(pFit_GA , ds, nSubj) ;
% fvals
output = pFit_GA;