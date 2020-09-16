clear all;
%% Load the project/data (Loads a file called m1)
% 3 GLU.
% sbioloadproject('Image_3_28_2015_Split_Eqtns_No_FTHF_3') - gave great
% results!!

% sbioloadproject('Drug_Search_Modified_GCS_Removed_Sink_Vmax')
sbioloadproject('Drug_Search_Modified_Real_VMAXS');
% List an array of parameters
p_array = sbioselect(m1,'Type','parameter');

% Testing 3 Glu, nFTHF
load('databean_nFTHF3GLU.mat');

% Reduce dataBean and all species by lowering # of columns:

% This function reduces the amount of data from 9 columns to something
% else, and rows if needbe.
dataBean = cleanDataBeanfcn(dataBean,[4:9],[]);


% Removing everything but the No-sup experiment
% dataBean = rmfield(dataBean, 'GIMT_TM');
% dataBean = rmfield(dataBean, 'GIM_TM');
% dataBean = rmfield(dataBean, 'GM_TM');
dataBean = rmfield(dataBean, 'Ino_TM');
dataBean = rmfield(dataBean, 'Gly_TM');
dataBean = rmfield(dataBean, 'Met_TM');
dataBean = rmfield(dataBean, 'Thy_TM');
% dataBean = rmfield(dataBean, 'No_Supp_TM');

%% Get all Species and Parameters (all should be simBiology objects)
% Species should match up with order of the species in dataBean
% sOrder = [3	11 12 2 23 24 1 19 20 4 9 5 6 15 16 28 29 30]; %without FTHF, Glu3

sOrder = [3	9	10	2	17	18	1	13	14	4	8	5	6	11	12	20	21	22]; %less variables

% This always stays
species = m1.Species(sOrder);

% Error when your species assignments are bad & don't match Databean
% Attempted to access yPredTemp(:,7); index out of bounds because size(yPredTemp)=[7,6].


% Parameter objects to be optimized
% Parameter test


% GLU3 NFTHF
% gParams = [sbioselect(m1, 'Name', 'FOLMKI1') sbioselect(m1, 'Name', 'FOLMKI2') sbioselect(m1, 'Name', 'FOLMKI3') sbioselect(m1, 'Name', 'FOLMKM1') sbioselect(m1, 'Name', 'FOLMKM2') sbioselect(m1, 'Name', 'FOLMKM3') sbioselect(m1, 'Name', 'FPGSTHFKI1') sbioselect(m1, 'Name', 'FPGSTHFKI2') sbioselect(m1, 'Name', 'FPGSTHFKM2') sbioselect(m1, 'Name', 'FPGSTHFKM1') sbioselect(m1, 'Name', 'FPGS510KM1') sbioselect(m1, 'Name', 'FPGS510KM2') sbioselect(m1, 'Name', 'FPGS510KI1') sbioselect(m1, 'Name', 'FPGS510KI2') sbioselect(m1, 'Name', 'FPGS5CH3KI1') sbioselect(m1, 'Name', 'FPGS5CH3KM1') sbioselect(m1, 'Name', 'TSKM1') sbioselect(m1, 'Name', 'TSKM2') sbioselect(m1, 'Name', 'MTHFRKM1') sbioselect(m1, 'Name', 'MTHFRKM2') sbioselect(m1, 'Name', 'SHMTKM1') sbioselect(m1, 'Name', 'SHMTKM2') sbioselect(m1, 'Name', 'TSPTEKI1') sbioselect(m1, 'Name', 'TSPTEKI2') sbioselect(m1, 'Name', 'SHMTTHFKI1') sbioselect(m1, 'Name', 'SHMTTHFKI2') sbioselect(m1, 'Name', 'MTHFRKI1') sbioselect(m1, 'Name', 'MTHFRKI2') sbioselect(m1, 'Name', 'FPGS5CH3KI2') sbioselect(m1, 'Name', 'FPGS5CH3KM2') sbioselect(m1, 'Name', 'MTHFRKI3') sbioselect(m1, 'Name', 'MTHFRKM3') sbioselect(m1, 'Name', 'SHMTKM3') sbioselect(m1, 'Name', 'SHMTTHFKI3') sbioselect(m1, 'Name', 'TSKM3') sbioselect(m1, 'Name', 'TSPTEKI3') sbioselect(m1, 'Name', 'MSEKM3')];
% 8/22/15 - removing MTHFRKM2, MTHFRKM3, and SHMTVM3 from search to protect
% drug search results.
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
% sbioselect(m1, 'Name', 'MTHFRKM2')
% sbioselect(m1, 'Name', 'MTHFRKM3')
sbioselect(m1, 'Name', 'PABSINKKM1')
sbioselect(m1, 'Name', 'PABSINKKM2')
sbioselect(m1, 'Name', 'PABSINKKM3')
sbioselect(m1, 'Name', 'PTESINKKM1')
sbioselect(m1, 'Name', 'PTESINKKM2')
sbioselect(m1, 'Name', 'PTESINKKM3')
sbioselect(m1, 'Name', 'SHMTKM1')
sbioselect(m1, 'Name', 'SHMTKM2')
% sbioselect(m1, 'Name', 'SHMTKM3')
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

% 3 Glu, NFTHF
% sParams = [sbioselect(m1, 'Name', 'KIN2') sbioselect(m1, 'Name', 'FOLMVM1') sbioselect(m1, 'Name', 'FOLMVM2') sbioselect(m1, 'Name', 'FPGS510VM1') sbioselect(m1, 'Name', 'FPGS5CH3VM1') sbioselect(m1, 'Name', 'FPGSTHFVM1') sbioselect(m1, 'Name', 'MSEVM2') sbioselect(m1, 'Name', 'MTHFRVM1') sbioselect(m1, 'Name', 'MTHFRVM2') sbioselect(m1, 'Name', 'SHMTVM1') sbioselect(m1, 'Name', 'SHMTVM2') sbioselect(m1, 'Name', 'TSVM1') sbioselect(m1, 'Name', 'TSVM2') sbioselect(m1, 'Name', 'FOLMVM3') sbioselect(m1, 'Name', 'FPGS510VM2') sbioselect(m1, 'Name', 'FPGS5CH3VM2') sbioselect(m1, 'Name', 'FPGSTHFVM2') sbioselect(m1, 'Name', 'MSEVM3') sbioselect(m1, 'Name', 'MTHFRVM3') sbioselect(m1, 'Name', 'SHMTVM3') sbioselect(m1, 'Name', 'PTESINKVM1') sbioselect(m1, 'Name', 'PTESINKVM2') sbioselect(m1, 'Name', 'PTESINKVM3') sbioselect(m1, 'Name', 'PABSINKVM1') sbioselect(m1, 'Name', 'PABSINKVM2') sbioselect(m1, 'Name', 'PABSINKVM3') ];
% sParams = [sbioselect(m1, 'Name', 'KIN2') sbioselect(m1, 'Name', 'FOLMVM1') sbioselect(m1, 'Name', 'FOLMVM2') sbioselect(m1, 'Name', 'FPGS510VM1') sbioselect(m1, 'Name', 'FPGS5CH3VM1') sbioselect(m1, 'Name', 'FPGSTHFVM1') sbioselect(m1, 'Name', 'MSEVM2') sbioselect(m1, 'Name', 'MTHFRVM1') sbioselect(m1, 'Name', 'MTHFRVM2') sbioselect(m1, 'Name', 'SHMTVM1') sbioselect(m1, 'Name', 'SHMTVM2') sbioselect(m1, 'Name', 'TSVM1') sbioselect(m1, 'Name', 'TSVM2') sbioselect(m1, 'Name', 'FOLMVM3') sbioselect(m1, 'Name', 'FPGS510VM2') sbioselect(m1, 'Name', 'FPGS5CH3VM2') sbioselect(m1, 'Name', 'FPGSTHFVM2') sbioselect(m1, 'Name', 'MSEVM3') sbioselect(m1, 'Name', 'MTHFRVM3') sbioselect(m1, 'Name', 'SHMTVM3') sbioselect(m1, 'Name', 'PTESINKVM1') sbioselect(m1, 'Name', 'PTESINKVM2') sbioselect(m1, 'Name', 'PTESINKVM3') sbioselect(m1, 'Name', 'PABSINKVM1') sbioselect(m1, 'Name', 'PABSINKVM2') sbioselect(m1, 'Name', 'PABSINKVM3') ];
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
% sbioselect(m1, 'Name', 'MSEVM3')
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
% sbioselect(m1, 'Name', 'SHMTVM3')
sbioselect(m1, 'Name', 'TSVM1')
sbioselect(m1, 'Name', 'TSVM2')
sbioselect(m1, 'Name', 'TSVM3')
    ];

sParams = sParams';
%% Set parameter estimates and boundssbioselect(m1, 'Name', 'MTHFRVM3')

% Global estimates and bounds. One for every global parameter. Should be in
% the same order as the parameter objects.

% 4/2/2015, Parameter test old
% Glu3, nFTHF
% gEst = [5.3E-03	5.7E-03	5.0E-03	1.3E-01	1.8E+01	6.4E-01	4.1E-01	2.2E-02	1.7E+01	1.1E+00	1.3E+00	6.1E-02	4.7E+01	4.7E+01	5.2E-02	1.1E-02	8.7E+00	1.5E+01	6.9E+01	1.0E+00	1.1E-01	4.2E+01	8.3E+00	1.4E-01	3.8E+00	4.5E-01	5.0E+02	5.0E+02	5.0E+02	5.0E+02	5.0E+02	5.0E+02	6.3E+00	2.1E+01	1.1E+01	3.7E+00	1.1E+00	4.3E+00	2.3E+00	7.9E+00	8.7E+00	5.1E+01	5.2E+00	1.0E+00];
% gLB =  [1.1E-03	1.1E-03	1.0E-03	2.6E-02	3.6E+00	1.3E-01	8.2E-02	4.5E-03	3.3E+00	2.2E-01	2.6E-01	1.2E-02	9.4E+00	9.4E+00	1.0E-02	2.2E-03	1.7E+00	2.9E+00	1.4E+01	2.0E-01	2.3E-02	8.5E+00	1.7E+00	2.8E-02	7.6E-01	9.1E-02	1.0E+02	1.0E+02	1.0E+02	1.0E+02	1.0E+02	1.0E+02	1.3E+00	4.1E+00	2.3E+00	7.4E-01	2.2E-01	8.5E-01	4.6E-01	1.6E+00	1.7E+00	1.0E+01	1.0E+00	2.0E-01];
% gUB =  [2.7E-02	2.9E-02	2.5E-02	6.6E-01	9.0E+01	3.2E+00	2.0E+00	1.1E-01	8.4E+01	5.5E+00	6.4E+00	3.0E-01	2.4E+02	2.4E+02	2.6E-01	5.5E-02	4.3E+01	7.3E+01	3.5E+02	5.0E+00	5.7E-01	2.1E+02	4.2E+01	6.9E-01	1.9E+01	2.3E+00	2.5E+03	2.5E+03	2.5E+03	2.5E+03	2.5E+03	2.5E+03	3.1E+01	1.0E+02	5.7E+01	1.9E+01	5.5E+00	2.1E+01	1.2E+01	4.0E+01	4.4E+01	2.6E+02	2.6E+01	5.0E+00];

% 8/5/2015 - got good results w this!
gEst = [0.01	0.01	0.01	0.5	0.5	0.5	3.1	3.1	10	1.8	3.1	3.1	10	1.4	12	4.7	173	173	61	41	21	0.6	0.5	0.3	30	30	30	30	30	30	40	30	25	83	63	43	11	4.4	3.7	0.18	1	1];
gLB =  [0.001	0.001	0.001	0.44	0.24	0.14	1	1	8	1.4	3	1	8	1	10	3	150	150	40	20	10	0.5	0.3	0.1	20	10	5	20	10	0	40	20	10	60	40	20	8	3	2	0.1	0.1	0.1];
gUB =  [1	1	1	12	12	12	100	100	60	40	5	10	50	40	40	10	200	200	120	120	120	3	3	3	200	200	200	200	200	200	60	60	60	120	120	120	20	20	20	3	3	3];

% 8/22/15 gest
gEst = [0.004798605	0.001003918	0.001027555	0.508781505	2.306674778	4.421329058	4.326300022	3.570740222	12.04796042	3.818713915	3.344695599	5.289762554	11.50368965	5.942432071	12.74230672	8.83065795	173.7492377	175.3494095	64.0281983	42.58755204	23.50694792	0.542253471			30.59890194	30.17603862	30.93098109	41.2615258	32.0114013	32.3570613	42.85772957	31.65164985		85.523412	63.52215225	44.38281964	12.77524954	8.172914635	9.164749116	0.100281584	0.632511326	0.132912499];
gLB = [0.001	0.001	0.001	0.44	0.24	0.14	1	1	8	1.4	3	1	8	1	10	3	150	150	40	20	10	0.5			20	10	5	20	10	0	40	20		60	40	20	8	3	2	0.1	0.1	0.1];
gUB = [1	1	1	12	12	12	100	100	60	40	5	10	50	40	40	10	200	200	120	120	120	3			200	200	200	200	200	200	60	60		120	120	120	20	20	20	3	3	3];

% Scenario estimates & lower and upper bounds
% Glu 3, nFTHF - this got good results
sEst = {[1	1	1	1	1	1	1	0.016666667	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1]};
sLB = {[0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.01	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001]};
sUB = {[5	5	5	5	5	5	5	0.04	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5]};

% 8/22/15 attempt to get all scenarios while protecting results for drug
% search
sEst = {[4.989279374	4.220477433	1.899604045	0.001119282	0.072184478	1.56411125	0.001087549	0.010002132	4.471369915		0.001003097	2.86475366	0.063637273	0.007552183	0.005334465	0.004936054	0.001000348	0.001001723	0.001002451	0.571185694	4.981572036		0.081582064	0.08837655	0.379936253]};
sLB = {[0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.01	0.001		0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001	0.001		0.001	0.001	0.001]};
sUB = {[5	5	5	5	5	5	5	0.04	5		5	5	5	5	5	5	5	5	5	5	5		5	5	5]};

% One scenario only: nosup
sEst(1:4) = sEst(1);
sLB(1:4) = sLB(1);
sUB(1:4) = sUB(1);

% Lower and Upper detection limits on the species concentrations. They
% should be in the same order as the species (we can ditch this 6/1/14)
LL = ones(18,1);
LL(1:18) = 1.0000e-9;
UL = ones(18,1);
UL(1:18) = 80000;

tic
[results] = singleDrug_Optimization_GA(m1, dataBean, species, LL, UL, gParams, sParams, gEst, sEst, gLB, sLB, gUB, sUB,sOrder)
%  [results] = singleDrug_Optimization_GA(m1, dataBean, species, LL, UL, gParams, sParams, gEst, sEst, gLB, sLB, gUB, sUB)
toc
% These are other versions of the optimization functions that Inder tried.
% singleDrug_Optimization_fmincon(m1, dataBean, species, LL, UL, gParams, sParams, gEst, sEst, gLB, sLB, gUB, sUB)
% singleDrug_Optimization_fmincon_old(m1, dataBean, species, gParams, sParams, gEst, sEst, gLB, sLB, gUB, sUB)