#!/usr/bin/env python
# coding: utf-8

# # CDO LOCA yearmax

# ## Libraries

# In[ ]:


import os    as os

import numpy as np


# ## Control Variables and Arrays

# In[ ]:


working_directory = "./"


thredds_root_orig = "/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_NGP/Northern_Great_Plains_Original_Subset/"

thredds_root_new  = "/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_NGP/climatology/ANNUAL/ANN_MAX_SERIES/"


rcps      = ["historical","rcp45","rcp85"]



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

# 

# In[ ]:


thredds_root2 = "/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_NGP/Northern_Great_Plains_Original_Subset/"


print(' ')
print(' ')
print('===============================')

for rcp in rcps:
    print('===============================')

    directory = thredds_root_new + rcp 
    print("cd " + directory)
    os.chdir(directory)

    for ensemble in ensembles:

        print('-------------------------------')

        input_file_nc_name_orig  = thredds_root_orig  + rcp + "/" + \
                                  "NGP_LOCA"    + \
                                  "___"          + \
                                  ensemble  + \
                                  "___"          + \
                                  rcp           + \
                                  ".nc"
        output_file_nc_name_new = thredds_root_new + rcp  + "/" + \
                                  "NGP_LOCA"    + \
                                  "___"          + \
                                  ensemble  + \
                                  "___"          + \
                                  rcp           + \
                                  "___YEARMAX.nc"





        #print('- - - - - - - - - - - - - - - -')
        #print(output_file_nc_name_new)
        #print(    '')
        #print(    'cdo yearmax '+input_file_nc_name_new+' '+output_file_nc_name_new)
        #os.system('cdo yearmax '+input_file_nc_name_new+' '+output_file_nc_name_new)
        
        output_file_nc_name_new_cheyenne = thredds_root_new + rcp  + "/" + \
                                  "CHEYENNE_LOCA"    + \
                                  "___"          + \
                                  ensemble  + \
                                  "___"          + \
                                  rcp           + \
                                  "___YEARMAX.nc"


        print('- - - - - - - - - - - - - - - -')
        print(output_file_nc_name_new)
        print(    '')
        print(    'ncea -h -4 -d lat,139,180 -d lon,131,209 ' + output_file_nc_name_new + " " + output_file_nc_name_new_cheyenne)
        os.system('ncea -h -4 -d lat,139,180 -d lon,131,209 ' + output_file_nc_name_new + " " + output_file_nc_name_new_cheyenne)
        






print(' ')
print(' ')




