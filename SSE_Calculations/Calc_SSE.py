#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

#***************************Function*********************
#To calculate the sum of square errors for experimental and simulation
#data

#**********************Python 3.6 modules**********************
#pandas (0.24.6) to manipulate the tabular data
#**Important**
#The xlrd package may need to be installed in order to use pandas.read_excel()


# __Main Function Algorithm__

# 1. Read in the experimental and simulation data files
# 2. Aggregate the experiemental data to match the simulations, i.e., one data
#    point per time per chemical
# 3. Align the indexes for all of the DataFrames
# 4. Compute the squared error element-by-element, which is defined as:
#               ** sum(obs-sim)^2 / sum(sim-sim)^2 **
# 4. Calculate the sum of the squared error for each chemical
# 5. Save the SSE calculations as a pickle file

"""
#%%**********Import modules and define joinpaths function************
import pandas as pd
#%%*************************Program Begin*************************
#*****************************************************************

#%%***Locate and read in the files to operate on***

# observed data
obs_file = pd.read_csv('Experimental_Data_Replicates.csv')

# tm simulationd ata
tm_df = pd.read_excel('TM_Model_simulation_results.xlsx',index_col='Time')

# rewired simulation data
rw_df = pd.read_excel('Rewired_Model_Search_3_Results.xlsx',index_col='Time')

# kwon simulation data compressed
kwon_df = pd.read_csv('kwon_simulation_compressed.csv',index_col='Time')

#%%***Align indexes for observations and simulation DataFrames****
#1. Drop the replicate column - it's not needed for index alignment
#2. Group by the time column and take the mean for each column
obs_df = obs_file.drop('Replicate#',axis=1)     .groupby('Time')     .agg('mean')

#Capitalize all dataframe columns names for index alignment
obs_df.columns = obs_df.columns.str.upper()
tm_df.columns = tm_df.columns.str.upper()
rw_df.columns = rw_df.columns.str.upper()
kwon_df.columns = kwon_df.columns.str.upper()

obs_df_kwon = pd.DataFrame()
obs_df_kwon['THF_G_1_M'] = obs_df.THF_G_1_M + obs_df.FIVE_10MTHF_G_1_M + obs_df.FIVE_CH3THF_G_1_M
obs_df_kwon['THF_G_2_M'] = obs_df.THF_G_2_M + obs_df.FIVE_10MTHF_G_2_M + obs_df.FIVE_CH3THF_G_2_M
obs_df_kwon['THF_G_3_M'] = obs_df.THF_G_3_M + obs_df.FIVE_10MTHF_G_3_M + obs_df.FIVE_CH3THF_G_3_M
obs_df_kwon['DHF_G_1_M'] = obs_df.DHF_G_1_M
obs_df_kwon['DHF_G_2_M'] = obs_df.DHF_G_2_M
obs_df_kwon['DHF_G_3_M'] = obs_df.DHF_G_3_M

tm_df_kwon = pd.DataFrame()
tm_df_kwon['THF_G_1_M'] = tm_df.THF_G_1_M + tm_df.FIVE_10MTHF_G_1_M + tm_df.FIVE_CH3THF_G_1_M
tm_df_kwon['THF_G_2_M'] = tm_df.THF_G_2_M + tm_df.FIVE_10MTHF_G_2_M + tm_df.FIVE_CH3THF_G_2_M
tm_df_kwon['THF_G_3_M'] = tm_df.THF_G_3_M + tm_df.FIVE_10MTHF_G_3_M + tm_df.FIVE_CH3THF_G_3_M
tm_df_kwon['DHF_G_1_M'] = tm_df.DHF_G_1_M
tm_df_kwon['DHF_G_2_M'] = tm_df.DHF_G_2_M
tm_df_kwon['DHF_G_3_M'] = tm_df.DHF_G_3_M

#%%***Calcalute SSE***

#Calculate sum of squared error for the obs vs TM model (obs-TM)
tm_sse= obs_df.sub(tm_df).pow(2).sum()

#Calculate sum of squared error for the obs vs RW model (obs-RW)
rw_sse = obs_df.sub(rw_df).pow(2).sum()

#Calculate sum of squared error for the TM vs RW model (TM-RW)
sim_sse = tm_df.sub(rw_df).pow(2).sum()

# Calculate kwon's simulation SSE based on observational data summated to KWON standards
kwon_sse = kwon_df.sub(obs_df_kwon).pow(2).sum()

# Calculate TM model's simulation SSE based on observational data summated to KWON standards
tm_kwon_sse = tm_df_kwon.sub(obs_df_kwon).pow(2).sum()

#%%***Turn the DataFrame into tidy data form**********************
sses = pd.concat([tm_sse, rw_sse, sim_sse], axis=1).reset_index()

#Rename the column index names
sses.columns = ['METABOLITE', 'OBS_TM_SSE', 'OBS_RW_SSE', 'TM_RW_SSE']

# calculate new sse's without two worst offenders
sses_sub = sses.drop(axis=1,index=5)
sses_sub = sses_sub.drop(axis=1,index=8)
#%%***Pickle the file***********************

# Inder's note: this should be saved as a pandsas style pickle extension (.p) not a python pickle
# consider:
# sses.to_pickle(joinpaths(pathname, 'Simulation-SSE.p'))

sses.to_pickle('Simulation-SSE_Jan_220.p')
