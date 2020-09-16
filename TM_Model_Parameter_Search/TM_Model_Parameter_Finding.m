clear all;
%% Load the project/data (Loads a file called m1)

sbioloadproject('Drug_Search_Modified_Real_VMAXS');

% List an array of parameters
p_array = sbioselect(m1,'Type','parameter');

% Load experimental data for multiple scenarios
load('databean_nFTHF3GLU.mat');

% Reduce dataBean and all species by lowering # of columns:
% This function reduces the amount of data from 9 columns to something
% else, and rows if needbe.
dataBean = cleanDataBeanfcn(dataBean,[4:9],[]);

% Removing everything but the No-sup experiment
% This section loads multiple scenarios of experimental situations
% For which to find the optimum parameter set of enzyme kinetics values
% The assumption is that more experimental data in means better kinetic 
% parameter estimates out
dataBean = rmfield(dataBean, 'GIMT_TM'); % commented out means data used
dataBean = rmfield(dataBean, 'GIM_TM');
dataBean = rmfield(dataBean, 'GM_TM');
dataBean = rmfield(dataBean, 'Ino_TM');
dataBean = rmfield(dataBean, 'Gly_TM'); % very bad data. always remove
dataBean = rmfield(dataBean, 'Met_TM'); % very bad data. always remove
dataBean = rmfield(dataBean, 'Thy_TM'); % very bad data. always remove
% dataBean = rmfield(dataBean, 'No_Supp_TM');

%% Get all Species and Parameters (all should be simBiology objects)
% Species should match up with order of the species in dataBean

sOrder = [3	9	10	2	17	18	1	13	14	4	8	5	6	11	12	20	21	22]; %less variables

% Get species from loaded simbiology file
species = m1.Species(sOrder);

%% Parameter objects to be optimized
% Parameter test

% Global parameter list
% These are kinetic parameters such as km values in MM equations
% They do not change between scenarios
gParams = [
sbioselect(m1, 'Name', 'FOLMKI1')
sbioselect(m1, 'Name', 'FOLMKI2')
sbioselect(m1, 'Name', 'FOLMKI3')
sbioselect(m1, 'Name', 'FOLMKM1')
sbioselect(m1, 'Name', 'FOLMKM2')
sbioselect(m1, 'Name', 'FOLMKM3')
sbioselect(m1, 'Name', 'FPGS510KI1')
sbioselect(m1, 'Name', 'FPGS510KI2')
sbioselect(m1, 'Name', 'FPGS510KM1')
sbioselect(m1, 'Name', 'FPGS510KM2')
sbioselect(m1, 'Name', 'FPGSTHFKI1')
sbioselect(m1, 'Name', 'FPGSTHFKI2')
sbioselect(m1, 'Name', 'FPGSTHFKM1')
sbioselect(m1, 'Name', 'FPGSTHFKM2')
sbioselect(m1, 'Name', 'MSEKM2')
sbioselect(m1, 'Name', 'MSEKM3')
sbioselect(m1, 'Name', 'MSEKI2')
sbioselect(m1, 'Name', 'MSEKI3')
sbioselect(m1, 'Name', 'MTHFRKI1')
sbioselect(m1, 'Name', 'MTHFRKI2')
sbioselect(m1, 'Name', 'MTHFRKI3')
sbioselect(m1, 'Name', 'MTHFRKM1')
sbioselect(m1, 'Name', 'MTHFRKM2')
sbioselect(m1, 'Name', 'MTHFRKM3')
sbioselect(m1, 'Name', 'PABSINKKM1')
sbioselect(m1, 'Name', 'PABSINKKM2')
sbioselect(m1, 'Name', 'PABSINKKM3')
sbioselect(m1, 'Name', 'PTESINKKM1')
sbioselect(m1, 'Name', 'PTESINKKM2')
sbioselect(m1, 'Name', 'PTESINKKM3')
sbioselect(m1, 'Name', 'SHMTKM1')
sbioselect(m1, 'Name', 'SHMTKM2')
sbioselect(m1, 'Name', 'SHMTKM3')
sbioselect(m1, 'Name', 'SHMTTHFKI1')
sbioselect(m1, 'Name', 'SHMTTHFKI2')
sbioselect(m1, 'Name', 'SHMTTHFKI3')
sbioselect(m1, 'Name', 'TSKM1')
sbioselect(m1, 'Name', 'TSKM2')
sbioselect(m1, 'Name', 'TSKM3')
sbioselect(m1, 'Name', 'TSPTEKI1')
sbioselect(m1, 'Name', 'TSPTEKI2')
sbioselect(m1, 'Name', 'TSPTEKI3')
];
gParams = gParams';

% VMAX parameters which can change wildly between scenarios
sParams = [
sbioselect(m1, 'Name', 'FOLMVM1')
sbioselect(m1, 'Name', 'FOLMVM2')
sbioselect(m1, 'Name', 'FOLMVM3')
sbioselect(m1, 'Name', 'FPGS510VM1')
sbioselect(m1, 'Name', 'FPGS510VM2')
sbioselect(m1, 'Name', 'FPGSTHFVM1')
sbioselect(m1, 'Name', 'FPGSTHFVM2')
sbioselect(m1, 'Name', 'KIN2')
sbioselect(m1, 'Name', 'MSEVM2')
sbioselect(m1, 'Name', 'MSEVM3')
sbioselect(m1, 'Name', 'MTHFRVM1')
sbioselect(m1, 'Name', 'MTHFRVM2')
sbioselect(m1, 'Name', 'MTHFRVM3')
sbioselect(m1, 'Name', 'PABSINKVM1')
sbioselect(m1, 'Name', 'PABSINKVM2')
sbioselect(m1, 'Name', 'PABSINKVM3')
sbioselect(m1, 'Name', 'PTESINKVM1')
sbioselect(m1, 'Name', 'PTESINKVM2')
sbioselect(m1, 'Name', 'PTESINKVM3')
sbioselect(m1, 'Name', 'SHMTVM1')
sbioselect(m1, 'Name', 'SHMTVM2')
sbioselect(m1, 'Name', 'SHMTVM3')
sbioselect(m1, 'Name', 'TSVM1')
sbioselect(m1, 'Name', 'TSVM2')
sbioselect(m1, 'Name', 'TSVM3')
    ];

sParams = sParams';
%% Set parameter estimates and boundssbioselect(m1, 'Name', 'MTHFRVM3')

% Global estimates and bounds. One for every global parameter. Should be in
% the same order as the parameter objects.

% manual entry
% should probably automate this
gEst = [0.01	0.01	0.01	0.5	0.5	0.5	3.1	3.1	10	1.8	3.1	3.1	10	1.4	12	4.7	173	173	61	41	21	0.6	0.5	0.3	30	30	30	30	30	30	40	30	25	83	63	43	11	4.4	3.7	0.18	1	1];
gLB =  [0.001	0.001	0.001	0.44	0.24	0.14	1	1	8	1.4	3	1	8	1	10	3	150	150	40	20	10	0.5	0.3	0.1	20	10	5	20	10	0	40	20	10	60	40	20	8	3	2	0.1	0.1	0.1];
gUB =  [1	1	1	12	12	12	100	100	60	40	5	10	50	40	40	10	200	200	120	120	120	3	3	3	200	200	200	200	200	200	60	60	60	120	120	120	20	20	20	3	3	3];


% Scenario estimates & lower and upper bounds 
sEst = {[1	1	1	1	1	1	1	0.016666667	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1]};
sLB = {[0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.01	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001]};
sUB = {[5	5	5	5	5	5	5	0.04	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5]};


% make multiples of sEst etc if we are lazy about making sim specific
% parameters
sEst(1:numel(fieldnames(dataBean))) = sEst(1);
sLB(1:numel(fieldnames(dataBean))) = sLB(1);
sUB(1:numel(fieldnames(dataBean))) = sUB(1);

% Lower and Upper detection limits on the species concentrations. They
% should be in the same order as the species
LL = ones(18,1);
LL(1:18) = 1.0000e-9;
UL = ones(18,1);
UL(1:18) = 80000;

tic
[results] = singleDrug_Optimization_GA(m1, dataBean, species, LL, UL, gParams, sParams, gEst, sEst, gLB, sLB, gUB, sUB,sOrder)
toc