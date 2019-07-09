
###################################################
##
## Libraries
##

library(package = "tidyverse")
library(package = "tidypredict")
library(package = "ncdf4")
library(package = "ncdf4.helpers")

library(package = "lubridate") # processing dates and time
library(package = "stringr")
library(package = "abind")
library(package = "reshape2")  # manipulating data frames
library(package =  "anytime")

##
##  print(as.Date( sub("\uFEFF", "", x$Time)))
####################################################


###################################################
##
## IO URLs
##

root_input_URL  = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/"

root_output_URL = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climate_divisions/"

##
##
####################################################


###################################################
##
## LOCA Scenarios, Variables, and Ensemble
##

  Scenario = c("historical",
               "rcp45",
               "rcp85")
  
  Variable = c("tasmax",
               "tasmin",
               "pr")  
  
  
  Ensemble       =  c("ACCESS1-0_r1i1p1",
                      "ACCESS1-3_r1i1p1",
                      "CCSM4_r6i1p1",
                      "CESM1-BGC_r1i1p1",
                      "CESM1-CAM5_r1i1p1",
                      "CMCC-CMS_r1i1p1",
                      "CMCC-CM_r1i1p1",
                      "CNRM-CM5_r1i1p1",
                      "CSIRO-Mk3-6-0_r1i1p1",
                      "CanESM2_r1i1p1",
                      "FGOALS-g2_r1i1p1",
                      "GFDL-CM3_r1i1p1",
                      "GFDL-ESM2G_r1i1p1",
                      "GFDL-ESM2M_r1i1p1",
                      "HadGEM2-AO_r1i1p1",
                      "HadGEM2-CC_r1i1p1",
                      "HadGEM2-ES_r1i1p1",
                      "IPSL-CM5A-LR_r1i1p1",
                      "IPSL-CM5A-MR_r1i1p1",
                      "MIROC-ESM_r1i1p1",
                      "MIROC-ESM-CHEM_r1i1p1",
                      "MIROC5_r1i1p1",
                      "MPI-ESM-LR_r1i1p1",
                      "MPI-ESM-MR_r1i1p1",
                      "MRI-CGCM3_r1i1p1",
                      "NorESM1-M_r1i1p1",
                      "bcc-csm1-1-m_r1i1p1")
  
##
##
####################################################



###################################################
##
## Pull Climate Divisions 
##


  ncngp  = nc_open(filename = "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/CLASS_Examples/NGP_Climate_Zones.nc") 
  
  lon         =  ncvar_get(nc    = ncngp, 
                           varid = "lon")
  lat         =  ncvar_get(nc    = ncngp,
                           varid = "lat")
  
  climate_regions  =  array(data     = NA,
                            dim      = c(length(lon),
                                         length(lat)),
                            dimnames = list("lon" = lon,
                                            "lat" = lat))
  
  climate_regions[,]    = ncvar_get(nc    = ncngp,
                                    varid = "US_CAN_Zones")
  
  climate_regions = t(apply(X      = climate_regions,
                            MARGIN = 1, 
                            FUN    = rev))
  nc_close(nc = ncngp)
  
  remove(ncngp)
  
  Climate_Zones = as.numeric(levels(unique(as.factor(climate_regions))))
  
  
  Climate_Zones = Climate_Zones[Climate_Zones>3900]
  Climate_Zones = Climate_Zones[Climate_Zones<4000]
  
  
  climate_regions_table = melt(data       = climate_regions,
                               value.name = "Climate_Zone")
  
  climate_regions_table$Climate_Zone = as.factor(climate_regions_table$Climate_Zone)
  
  

##
##
####################################################

  
  
  


###################################################
##
## Extract Time Series
##
  
  scenario = Scenario[1]
  for (scenario in Scenario)
  {
    first    = TRUE
    variable = Variable[1]
    for (variable in Variable)
    {
      ensemble = Ensemble[1]
      for (ensemble in Ensemble)
      {
        
        variable_name = str_c(variable,
                              "_",
                              ensemble,
                              "_",
                              scenario,
                              sep = "")
        
        print(variable_name)
        
        
        
        input_URL =  str_c(root_input_URL,
                           scenario,
                           "/",
                           variable,
                           "/",
                           "NGP_LOCA_",
                           variable_name,
                           ".nc",
                           sep = "")
        

        
        nc_loca = nc_open(filename = input_URL)

          for (k in seq(from = 1,
                        to   = length(time),
                        by   = 1))
          {
        
            input_2d = ncvar_get(nc    = nc_loca,
                                        varid = variable_name,
                                        start = c(1,                     1, k),
                                        count = c(length(lon), length(lat), 1))

            
            cli_div = Climate_Zones[1]
            for (cli_div in Climate_Zones)
            {
              
              output_URL = str_c(root_output_URL,
                                 "NGP_LOCA_",
                                 variable_name,
                                 "_nCLIMDIV_",
                                 sprintf("%04d",
                                         cli_div),
                                 ".csv",
                                 sep = "")
              

              if (k == 1) {
                 fileConn = file(description = output_URL)
                writeLines(text = "Time,Division,Ensemble,Scenario,Variable,P000,P025,P500,P075,P100", 
                           con  = fileConn)
                close(con = fileConn)
                
              }
                
              
              
              mask = climate_regions
              mask[] = NA
              
              mask[climate_regions == 205] = 1

              masked_data = mask * input_2d
              
              masked_data = quantile(x     = masked_data,
                                     na.rm = TRUE)
              
              mask_data = tibble(Time     = as.character(time[k], format="%Y-%m-%d"),
                                 Division = sprintf("%04d",cli_div),
                                 Ensemble = ensemble,
                                 Scenario = scenario,
                                 Variable = variable,
                                 P000     = round(masked_data[1],1),
                                 P025     = round(masked_data[2],1),
                                 P050     = round(masked_data[3],1),
                                 P075     = round(masked_data[4],1),
                                 P100     = round(masked_data[5],1))
              

              
              write_excel_csv(x      = mask_data,
                        path   = output_URL,
                        append = TRUE)  
              
              
            } # cli_div
            
            
            
          }  # day

      } # ensemble
    } # scenario
  } # variable

##
####################################################
  
  
  
