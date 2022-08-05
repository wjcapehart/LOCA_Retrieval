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
            ensemble_old = ensemble2s[ens_j]
            
            variable_old = variable_new + "_" + ensemble_old + "_" + rcp 

            output_file_nc_name_old = "NGP_LOCA"   + \
                                      "_"          + \
                                      variable_new +  \
                                      "_"          + \
                                      ensemble_old + \
                                      "_"          + \
                                      rcp          + \
                                      ".nc"

            output_file_nc_name_new = "NGP_LOCA"    + \
                                      "___"          + \
                                      variable_new  + \
                                      "___"          + \
                                      ensemble_new  + \
                                      "___"          + \
                                      rcp           + \
                                      ".nc"
            
            full_file_nc_name_old = "./" + output_file_nc_name_old
            full_file_nc_name_new = "./" + output_file_nc_name_new
            
            print(output_file_nc_name_old)
            print(output_file_nc_name_new)
            
            if ((variable_new != "rhmin") and (variable_new != "rhmax")) :
            
                print('- - - - - - - - - - - - - - - -')

                print('ncrename -O -h -v ' + variable_old + ',' + variable_new + ' ' + full_file_nc_name_old)
                os.system('ncrename -O -h -v ' + variable_old + ',' + variable_new + ' ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lat_min,global,o,f,33.9375   ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a geospatial_lat_min,global,o,f,33.9375   ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lat_max,global,o,f,52.8125   ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a geospatial_lat_max,global,o,f,52.8125   ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lon_min,global,o,f,-114.3125 ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a geospatial_lon_min,global,o,f,-114.3125 ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lon_max,global,o,f,-86.1875  ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a geospatial_lon_max,global,o,f,-86.1875  ' + full_file_nc_name_old)



                 
            else:
                
                print('- - - - - - - - - - - - - - - -')
                
                print('ncatted -O -h -a title,global,c,c,"Historical LOCA Statistical Downscaling (Localized Constructed Analogs) Statistically downscaled CMIP5 climate projections for North America" ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a title,global,c,c,"Historical LOCA Statistical Downscaling (Localized Constructed Analogs) Statistically downscaled CMIP5 climate projections for North America" ' + full_file_nc_name_old)
                print('ncatted -O -h -a acknowledgment,global,c,c,"Pierce, D. W. and D. R. Cayan, 2015: Downscaling humidity with Localized Constructed Analogs (LOCA) over the conterminous United States. Climate Dynamics, DOI 10.1007/s00382-015-2845-1" ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a acknowledgment,global,c,c,"Pierce, D. W. and D. R. Cayan, 2015: Downscaling humidity with Localized Constructed Analogs (LOCA) over the conterminous United States. Climate Dynamics, DOI 10.1007/s00382-015-2845-1" ' + full_file_nc_name_old)
                print('ncatted -O -h -a summary,global,c,c,"LOCA is a statistical downscaling technique that uses past history to add improved fine-scale detail to global climate models. We have used LOCA to downscale 32 global climate models from the CMIP5 archive at a 1/16th degree spatial resolution, covering North America from central Mexico through Southern Canada. The historical period is 1950-2005, and there are two future scenarios available: RCP 4.5 and RCP 8.5 over the period 2006-2100 (although some models stop in 2099). The variables currently available are daily minimum and maximum temperature, and daily precipitation. For more information visit: http://loca.ucsd.edu/" ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a summary,global,c,c,"LOCA is a statistical downscaling technique that uses past history to add improved fine-scale detail to global climate models. We have used LOCA to downscale 32 global climate models from the CMIP5 archive at a 1/16th degree spatial resolution, covering North America from central Mexico through Southern Canada. The historical period is 1950-2005, and there are two future scenarios available: RCP 4.5 and RCP 8.5 over the period 2006-2100 (although some models stop in 2099). The variables currently available are daily minimum and maximum temperature, and daily precipitation. For more information visit: http://loca.ucsd.edu/" ' + full_file_nc_name_old)
                print('ncatted -O -h -a keywords,global,c,c,"precipitation, temperature, relative_humidity" ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a keywords,global,c,c,"precipitation, temperature, relative_humidity" ' + full_file_nc_name_old)
                print('ncatted -O -h -a cdm_data_type,global,c,c,"Grid" ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a cdm_data_type,global,c,c,"Grid" ' + full_file_nc_name_old)
                print('ncatted -O -h -a creator_name,global,c,c,"David Pierce" ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a creator_name,global,c,c,"David Pierce" ' + full_file_nc_name_old)
                print('ncatted -O -h -a creator_email,global,c,c,"dpierce@ucsd.edu" ' + full_file_nc_name_old)
                os.system(' ncatted -O -h -a creator_email,global,c,c,"dpierce@ucsd.edu" ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lat_min,global,c,f,33.9375   ' + full_file_nc_name_old)
                os.system(' ncatted -O -h -a geospatial_lat_min,global,c,f,33.9375   ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lat_max,global,c,f,52.8125   ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a geospatial_lat_max,global,c,f,52.8125   ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lon_min,global,c,f,-114.3125 ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a geospatial_lon_min,global,c,f,-114.3125 ' + full_file_nc_name_old)
                print('ncatted -O -h -a geospatial_lon_max,global,c,f,-86.1875  ' + full_file_nc_name_old)
                os.system('ncatted -O -h -a geospatial_lon_max,global,c,f,-86.1875  ' + full_file_nc_name_old)


            print('- - - - - - - - - - - - - - - -')

            print('ncatted -O -h -a SCENARIO,global,c,c,"' + rcp + '" ' + full_file_nc_name_old)
            os.system('ncatted -O -h -a SCENARIO,global,c,c,"' + rcp + '" ' + full_file_nc_name_old)

            print('- - - - - - - - - - - - - - - -')

            print('ncatted -O -h -a ENSEMBLE_LONG,global,c,c,"' + ensemble_old + '" ' + full_file_nc_name_old)
            os.system('ncatted -O -h -a ENSEMBLE_LONG,global,c,c,"' + ensemble_old + '" ' + full_file_nc_name_old)

            print('- - - - - - - - - - - - - - - -')

            print('ncatted -O -h -a ENSEMBLE_SHORT,global,c,c,"' + ensemble_new + '" ' + full_file_nc_name_old)
            os.system('ncatted -O -h -a ENSEMBLE_SHORT,global,c,c,"' + ensemble_new + '" ' + full_file_nc_name_old)

            print('- - - - - - - - - - - - - - - -')

            print('mv -v ' + full_file_nc_name_old + ' ' + full_file_nc_name_new)
            os.system(' mv -v ' + full_file_nc_name_old + ' ' + full_file_nc_name_new)
           
    print('===============================')
    print(' ')
    print(' ')


            
            


# 

# In[ ]:




