#!/usr/bin/env python
# coding: utf-8

# # Renaming LOCA Repositories

# ## Libraries

# In[ ]:


import os    as os

import numpy as np


# ## Control Variables and Arrays

# In[ ]:


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

ensemble2s = ["ACCESS1-0_r1i1p1" ,     \
              "ACCESS1-3_r1i1p1",      \
              "CCSM4_r6i1p1",          \
              "CESM1-BGC_r1i1p1",      \
              "CESM1-CAM5_r1i1p1",     \
              "CMCC-CMS_r1i1p1",       \
              "CMCC-CM_r1i1p1",        \
              "CNRM-CM5_r1i1p1",       \
              "CSIRO-Mk3-6-0_r1i1p1",  \
              "CanESM2_r1i1p1",        \
              "FGOALS-g2_r1i1p1",      \
              "GFDL-CM3_r1i1p1",       \
              "GFDL-ESM2G_r1i1p1",     \
              "GFDL-ESM2M_r1i1p1",     \
              "HadGEM2-AO_r1i1p1",     \
              "HadGEM2-CC_r1i1p1",     \
              "HadGEM2-ES_r1i1p1",     \
              "IPSL-CM5A-LR_r1i1p1",   \
              "IPSL-CM5A-MR_r1i1p1",   \
              "MIROC-ESM-CHEM_r1i1p1", \
              "MIROC-ESM_r1i1p1",      \
              "MIROC5_r1i1p1",         \
              "MPI-ESM-LR_r1i1p1",     \
              "MPI-ESM-MR_r1i1p1",     \
              "MRI-CGCM3_r1i1p1",      \
              "NorESM1-M_r1i1p1",      \
              "bcc-csm1-1-m_r1i1p1"    ]


# ## Processing Loop

# In[ ]:


for variable_new in variables:
    
    print(' ')
    print(' ')
    print('===============================')
    
    for rcp in rcps:
        
        directory = thredds_root + rcp + "/" + variable_new 
        print("cd " + directory)
        os.chdir(directory)

        for ens_j in range(len(ensembles)):
            
            print('-------------------------------')

            ensemble_new = ensembles[ens_j]
            
            output_file_nc_name_new = "NGP_LOCA"    + \
                                      "___"          + \
                                      variable_new  + \
                                      "___"          + \
                                      ensemble_new  + \
                                      "___"          + \
                                      rcp           + \
                                      ".nc"
            
            full_file_nc_name_new = "./" + output_file_nc_name_new
            

            print(output_file_nc_name_new)
            
           
            print('- - - - - - - - - - - - - - - -')
            print(    'ncatted -O -h -a ,lon_bnds,d,,  ' + full_file_nc_name_new)
            os.system('ncatted -O -h -a ,lon_bnds,d,,  ' + full_file_nc_name_new)
            print(    'ncatted -O -h -a ,lat_bnds,d,,  ' + full_file_nc_name_new)
            os.system('ncatted -O -h -a ,lat_bnds,d,,  ' + full_file_nc_name_new)
            print(    'ncatted -O -h -a ,time_bnds,d,, ' + full_file_nc_name_new)
            os.system('ncatted -O -h -a ,time_bnds,d,, ' + full_file_nc_name_new)
            print(    'ncatted -O -h -a history,,d,,   ' + full_file_nc_name_new)
            os.system('ncatted -O -h -a history,,d,,   ' + full_file_nc_name_new)
            
            if (variable_new == "rhmin"):
                print(    'ncatted -O -h -a cell_methods,rhmin,o,c,"time: minimum" ' + full_file_nc_name_new)
                os.system('ncatted -O -h -a cell_methods,rhmin,o,c,"time: minimum" ' + full_file_nc_name_new)  
            if (variable_new == "rhmax"):
                print(    'ncatted -O -h -a cell_methods,rhmax,o,c,"time: maximum" ' + full_file_nc_name_new)
                os.system('ncatted -O -h -a cell_methods,rhmax,o,c,"time: maximum" ' + full_file_nc_name_new) 

                 

                

           
    print('===============================')
    print(' ')
    print(' ')


            
            


# 

# In[ ]:




