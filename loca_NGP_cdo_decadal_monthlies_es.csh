#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=("esatmax" "esatmin"  )
  declare -a SCENARIO=("historical" "rcp85" "rcp45" )


  # setting the Setting the Available ensembles
  #   currently only those members that have hits
  #   for all three variables!

  declare -a ENSEMBLE=(   "ACCESS1-0_r1i1p1"
                          "ACCESS1-3_r1i1p1"
                          "CCSM4_r6i1p1"
                          "CESM1-BGC_r1i1p1"
                          "CESM1-CAM5_r1i1p1"
                          "CMCC-CMS_r1i1p1"
                          "CMCC-CM_r1i1p1"
                          "CNRM-CM5_r1i1p1"
                          "CSIRO-Mk3-6-0_r1i1p1"
                          "CanESM2_r1i1p1"
                          "FGOALS-g2_r1i1p1"
                          "GFDL-CM3_r1i1p1"
                          "GFDL-ESM2G_r1i1p1"
                          "GFDL-ESM2M_r1i1p1"
                          "HadGEM2-AO_r1i1p1"
                          "HadGEM2-CC_r1i1p1"
                          "HadGEM2-ES_r1i1p1"
                          "IPSL-CM5A-LR_r1i1p1"
                          "IPSL-CM5A-MR_r1i1p1"
                          "MIROC-ESM-CHEM_r1i1p1"
                          "MIROC-ESM_r1i1p1"
                          "MIROC5_r1i1p1"
                          "MPI-ESM-LR_r1i1p1"
                          "MPI-ESM-MR_r1i1p1"
                          "MRI-CGCM3_r1i1p1"
                          "NorESM1-M_r1i1p1"
                          "bcc-csm1-1-m_r1i1p1" )




   export       DATASET="LOCA_NGP"
   export DATASETPREFIX="NGP_LOCA"

   export CLIMATE_ROOT_DIR="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_NGP/climatology/"
   export INPUT_ESAT_ROOT_DIR="/squall2/LOCA_NGP/derived/"

   export CDO_PCTL_NBINS=21






   # setting the available variables



   export ENS=${ENSEMBLE[0]}
   export PAR=${PARAM[0]}
   export PTILE=${PERCENTILE[9]}
   export SCEN=${SCENARIO[0]}
   export DECADE=0

for SCEN in "${SCENARIO[@]}"
do
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo

   if [[ ${SCEN} == "historical" ]]; then

     export MASTERPERIOD="1950-2005"

     declare -a PERIOD_STRINGS=(   "1951-1960"
                                   "1961-1970"
                                   "1971-1980"
                                   "1981-1990"
                                   "1991-2000"
                                   "2001-2005"
                                   "1976-2005"
                                   "1960-1989"
                                   "1985-2005")

     declare -a    START_DATES=(   "1951-01-01"
                                   "1961-01-01"
                                   "1971-01-01"
                                   "1981-01-01"
                                   "1991-01-01"
                                   "2001-01-01"
                                   "1976-01-01"
                                   "1960-01-01"
                                   "1985-01-01")

     declare -a      END_DATES=(   "1960-12-31"
                                   "1970-12-31"
                                   "1980-12-31"
                                   "1990-12-31"
                                   "2000-12-31"
                                   "2005-12-31"
                                   "2005-12-31"
                                   "2089-12-31"
                                   "2005-12-31")

      export NDECADES=8




   else
          export MASTERPERIOD="2006-2099"

          declare -a PERIOD_STRINGS=(   "2006-2010"
                                        "2011-2020"
                                        "2021-2030"
                                        "2031-2040"
                                        "2041-2050"
                                        "2051-2060"
                                        "2061-2070"
                                        "2071-2090"
                                        "2081-2090"
                                        "2091-2099"
                                        "2035-2064"
                                        "2010-2039"
                                        "2060-2089"
                                        "2070-2099"
                                        "2006-2014")



          declare -a    START_DATES=(   "2006-01-01"
                                        "2011-01-01"
                                        "2021-01-01"
                                        "2031-01-01"
                                        "2041-01-01"
                                        "2051-01-01"
                                        "2061-01-01"
                                        "2071-01-01"
                                        "2081-01-01"
                                        "2091-01-01"
                                        "2035-01-01"
                                        "2010-01-01"
                                        "2060-01-01"
                                        "2070-01-01"
                                        "2006-01-01")

          declare -a      END_DATES=(   "2010-12-31"
                                        "2020-12-31"
                                        "2030-12-31"
                                        "2040-12-31"
                                        "2050-12-31"
                                        "2060-12-31"
                                        "2070-12-31"
                                        "2080-12-31"
                                        "2090-12-31"
                                        "2099-12-31"
                                        "2064-12-31"
                                        "2039-12-31"
                                        "2089-12-31"
                                        "2099-12-31"
                                        "2014-12-31")

          export NDECADES=15



   fi


   for DECADE in $(seq 0 $((NDECADES-1)) )
   do

     export END_DATE=${END_DATES[$DECADE]}
     export START_DATE=${START_DATES[$DECADE]}
     export PERIOD_STRING=${PERIOD_STRINGS[$DECADE]}

     echo Processing Decade ${DECADE} ${START_DATES[${DECADE}]}

     export START_YEAR=`echo $PERIOD_STRING | cut -c1-4`
     export END_YEAR=`echo $PERIOD_STRING | cut -c6-9`
     export PERIOD_LENGTH=`expr ${END_YEAR} - ${START_YEAR} + 1`


     for PAR in "${PARAM[@]}"
     do
        echo =============================================================
        echo

        export  INPUT_DIR=${INPUT_ESAT_ROOT_DIR}/${SCEN}/${PAR}
        export OUTPUT_DIR=${CLIMATE_ROOT_DIR}/${PERIOD_STRING}/MONTHLY_CLIMS/${PAR}

        echo INPUT_DIR $INPUT_DIR
        echo OUTPUT_DIR $OUTPUT_DIR

        mkdir -vp ${OUTPUT_DIR}


        for ENS in "${ENSEMBLE[@]}"
        do
           echo
           echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           echo

           export  VARNAME=${PAR}_${ENS}_${SCEN}


           rm -frv ./cdo_esat_period_subset.nc

           export   INFILE=${INPUT_DIR}/LOCA_NGP_${VARNAME}_${MASTERPERIOD}_CDO_MONTHLY_MEAN.nc

           if [[ ${PAR} == "pr" ]]; then
              export   INFILE=${INPUT_DIR}/LOCA_NGP_${VARNAME}_${MASTERPERIOD}_CDO_MONTHLY_TOTAL.nc
           fi

           export  OUTFILE=${OUTPUT_DIR}/LOCA_NGP_${VARNAME}_${PERIOD_STRING}_CDO_PERIOD_MONTHLY_MEAN.nc


           echo inputfile $INFILE
           echo outputfile $OUTFILE



              echo
              echo .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .


              export SUBSETFILE="./cdo_period_subset.nc"
              echo
              echo Using Period String = ${PERIOD_STRING} clipping file
              echo
              echo Processing ${PAR}_${ENS}_${SCEN} seldate ${START_DATE} - ${END_DATE}
              echo
              echo cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INFILE} ${SUBSETFILE}
              echo
                   cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INFILE} ${SUBSETFILE}
              echo

              ##
              ##  CALCULATE Monthly MEANS
              ##

              echo
              echo processing ${OUTFILE}
              echo
              echo Processing ${PAR}_${ENS}_${SCEN} ymonmean ${START_DATE} - ${END_DATE}
              echo
              echo cdo  -O -z zip_8 ymonmean ${SUBSETFILE} ${OUTFILE}
              echo
                   cdo  -O -z zip_8 ymonmean ${SUBSETFILE} ${OUTFILE}
              echo



              if [[ ${PAR} == "pr" ]]; then

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Total Preciptation" ${OUTFILE}
                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Total Preciptation" ${OUTFILE}
                echo

              fi

              if [[ ${PAR} == "tasmin" ]]; then



                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Min Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Min Daily Temperature" ${OUTFILE}
                echo
              fi

              if [[ ${PAR} == "tasmax" ]]; then

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Max Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Max Daily Temperature" ${OUTFILE}
                echo
              fi


              if [[ ${PAR} == "esatmax" ]]; then
=
                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Max Equilibrium Vapor Pressure" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Max Equilibrium Vapor Pressure" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Max Equilibrium Vapor Pressure" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Max Equilibrium Vapor Pressure" ${OUTFILE}
                echo
              fi


              if [[ ${PAR} == "esatmin" ]]; then

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Min Equilibrium Vapor Pressure" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Min Equilibrium Vapor Pressure" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Min Equilibrium Vapor Pressure" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Min Equilibrium Vapor Pressure" ${OUTFILE}
                echo
              fi

              echo
              echo ncatted -h -O -a     period,global,c,c,${PERIOD_STRING} ${OUTFILE}
                   ncatted -h -O -a     period,global,c,c,${PERIOD_STRING} ${OUTFILE}
              echo

              echo
              echo ncatted -h -O -a     start_date,global,c,c,${START_DATE} ${OUTFILE}
                   ncatted -h -O -a     start_date,global,c,c,${START_DATE} ${OUTFILE}
              echo

              echo
              echo ncatted -h -O -a     end_date,global,c,c,${END_DATE} ${OUTFILE}
                   ncatted -h -O -a     end_date,global,c,c,${END_DATE} ${OUTFILE}
              echo


              echo
              echo ncatted -h -O -a     years_in_calculation,global,c,s,${PERIOD_LENGTH} ${OUTFILE}
                   ncatted -h -O -a     years_in_calculation,global,c,s,${PERIOD_LENGTH} ${OUTFILE}
              echo


              rm -frv ./cdo_period_subset.nc


           echo
        done
        echo
     done
     echo
  done
  echo
done




echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
