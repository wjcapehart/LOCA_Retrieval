#!/usr/bin/env python
# coding: utf-8

# # Renaming LOCA Repositories

# ## Libraries

# In[1]:


import os    as os

import numpy as np


# ## Control Variables and Arrays

# In[2]:


working_directory = "./"

ftp_prefix = "http://loca.ucsd.edu/public/LOCA_relative_humid_v2/"

thredds_root = "/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_NGP/Northern_Great_Plains_Original_Subset/"

rcps      = ["historical","rcp45","rcp85"]

variables = ["tasmax", "tasmin", "pr", "rhmin", "rhmax"]


ensembles =  ["ACCESS1-0" ,     \
              "ACCESS1-3",      \
              "CCSM4",          \
              "CESM1-BGC",      \
              "CESM1-CAM5",     \
              "CMCC-CMS",       \
              "CMCC-CM",        \
              "CNRM-CM5",       \
              "CSIRO-Mk3-6-0",  \
              "CanESM2",        \
              "FGOALS-g2",      \
              "GFDL-CM3",       \
              "GFDL-ESM2G",     \
              "GFDL-ESM2M",     \
              "HadGEM2-AO",     \
              "HadGEM2-CC",     \
              "HadGEM2-ES",     \
              "IPSL-CM5A-LR",   \
              "IPSL-CM5A-MR",   \
              "MIROC-ESM-CHEM", \
              "MIROC-ESM",      \
              "MIROC5",         \
              "MPI-ESM-LR",     \
              "MPI-ESM-MR",     \
              "MRI-CGCM3",      \
              "NorESM1-M",      \
              "bcc-csm1-1-m"    ]


# ## Processing Loop

# In[4]:


### CRB
#LONCLIP=  [131:1:209] [-106.09375:1:-101.21875]
#LATCLIP=  [139:1:180] [  42.65625:1:  45.21875]



print(' ')
print(' ')
print('===============================')

for rcp in rcps:
 print('===============================')

 directory = thredds_root + rcp 
 print("cd " + directory)
 os.chdir(directory)

 for ensemble in ensembles:

     print('-------------------------------')


     input_file_nc_name_new = "./NGP_LOCA"    + \
                               "___"          + \
                               ensemble  + \
                               "___"          + \
                               rcp           + \
                               ".nc"

     output_file_nc_name_new = "./CHEYENNE_LOCA"    + \
                               "___"          + \
                               ensemble  + \
                               "___"          + \
                               rcp           + \
                               ".nc"


     print(output_file_nc_name_new)


     print('- - - - - - - - - - - - - - - -')
     print(    '')
     print(    'ncea -h -4 -d lat,139,180 -d lon,131,209 ' + input_file_nc_name_new + " " + output_file_nc_name_new)
     os.system('ncea -h -4 -d lat,139,180 -d lon,131,209 ' + input_file_nc_name_new + " " + output_file_nc_name_new)
     







print(' ')
print(' ')






# 

# In[ ]:




