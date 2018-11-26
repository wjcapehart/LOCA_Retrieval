#!/bin/bash


## ETCCDI https://code.mpimet.mpg.de/projects/cdo/embedded/cdo_eca.pdf

OS_NAME=`uname`
HOST_NAME=`hostname`


  declare -a DECADES=( 1950
                       1960
                       1970
                       1980
                       1990
                       2000
                       2010
                       2020
                       2030
                       2040
                       2050
                       2060
                       2070
                       2080
                       2090 )

   declare -a DECADES=( 1961 )


  export NY=29


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=( "pr" "tasmin" "tasmax" )
  declare -a SCENARIO=( "historical" "rcp85" "rcp45" )


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

   export CLIPPED_INDIR_ROOT="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/${DATASET}"

   export CDO_PCTL_NBINS=21




# 010 075 090 095 099 ptiles are the ones we really need.
declare -a PERCENTILE=( 010 075 090 095 099 )

   # setting the available variables



   export ENS=${ENSEMBLE[0]}
   export PAR=${PARAM[0]}
   export PTILE=${PERCENTILE[9]}
   export SCEN=${SCENARIO[0]}

for DEC in "${DECADES[@]}"
do

  export PERIOD_STRING=$DEC-$(( $DEC+$NY ))

  export START_DATE=$DEC-01-01

  export END_DATE=$(( $DEC+$NY ))-12-31

  if [[ $DEC < 2000 ]]; then
    export SCEN="historical"
  else
    export SCEN="rcp45"
  fi




     for ENS in "${ENSEMBLE[@]}"
     do
        echo =============================================================
        echo


        for PAR in "${PARAM[@]}"
        do

           echo
           echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           echo

           export CLIPPED_INPREFIX=${CLIPPED_INDIR_ROOT}/${SCEN}/${PAR}/${DATASETPREFIX}

           echo processing $CLIPPED_INPREFIX

           export   CLIPPED_OUTDIR_ROOT=${CLIPPED_INDIR_ROOT}/climatology/${PERIOD_STRING}


           export   CLIPPED_OUTDIR_I=${CLIPPED_OUTDIR_ROOT}/INTERANNUAL/${PAR}
           export   CLIPPED_OUTDIR_D=${CLIPPED_OUTDIR_ROOT}/DAILY/${PAR}
           export   CLIPPED_OUTDIR_A=${CLIPPED_OUTDIR_ROOT}/ANNUAL/${PAR}
           export   CLIPPED_OUTDIR_M=${CLIPPED_OUTDIR_ROOT}/MONTHLY/${PAR}

           mkdir -vp ${CLIPPED_OUTDIR_ROOT}

           rm -frv ./cdo_period_subset.nc

           export  INFILE=${CLIPPED_INPREFIX}_${PAR}_${ENS}_${SCEN}.nc

           echo processing $INFILE

           export  VARNAME=${PAR}_${ENS}_${SCEN}



           # if the full data period is being used extract annial and monthly series

           if [ ${PERIOD_STRING} ==  "1950-2005" ] || [ ${PERIOD_STRING} ==  "2006-2099" ]; then


              echo
              echo Using Full Period String = ${PERIOD_STRING} using original file
              echo
              export SUBSETFILE=${INFILE}
              echo ${SUBSETFILE}
              echo
              echo .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .

              mkdir -v -p ${CLIPPED_OUTDIR_A}
              mkdir -v -p ${CLIPPED_OUTDIR_M}
              mkdir -v -p ${CLIPPED_OUTDIR_I}

              if [[ ${PAR} == "pr" ]]; then

                 export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_TOTAL.nc

                 echo
                 echo processing ${OUTFILE}

                 echo
                 echo cdo -b I32 -O  -z zip_8 yearsum  ${SUBSETFILE} ${OUTFILE}
                 echo
                      cdo -b I32 -O  -z zip_8 yearsum  ${SUBSETFILE} ${OUTFILE}
                 echo

                 echo
                 echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Total Annual Precipitation" ${OUTFILE}
                 echo
                      ncatted -h -O -a     long_name,${VARNAME},m,c,"Total Annual Precipitation" ${OUTFILE}
                 echo

                 echo
                 echo ncatted -h -O -a   description,${VARNAME},m,c,"Total Annual Precipitation" ${OUTFILE}
                 echo
                      ncatted -h -O -a   description,${VARNAME},m,c,"Total Annual Precipitation" ${OUTFILE}
                 echo

                 export MIDFILE=${OUTFILE}

                 export OUTFILE=${CLIPPED_OUTDIR_I}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_PERIOD_ANNUAL_MEAN.nc

                 echo
                 echo processing ${OUTFILE}

                 echo
                 echo cdo -b I32 -O  -z zip_8 timmean  ${MIDFILE} ${OUTFILE}
                 echo
                      cdo -b I32 -O  -z zip_8 timmean  ${MIDFILE} ${OUTFILE}
                 echo

                 echo
                 echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Precipitation" ${OUTFILE}
                 echo
                      ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Precipitation" ${OUTFILE}
                 echo

                 echo
                 echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Precipitation" ${OUTFILE}
                 echo
                      ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Precipitation" ${OUTFILE}
                 echo

                 export OUTFILE=${CLIPPED_OUTDIR_M}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_MONTLY_TOTAL.nc

                 echo
                 echo processing ${OUTFILE}
                 echo

                 echo
                 echo cdo -b I32 -O  -z zip_8 monsum  ${SUBSETFILE} ${OUTFILE}
                 echo
                      cdo -b I32 -O  -z zip_8 monsum  ${SUBSETFILE} ${OUTFILE}
                 echo

                 echo
                 echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Total Monthly Precipitation" ${OUTFILE}
                 echo
                      ncatted -h -O -a     long_name,${VARNAME},m,c,"Total Monthly Precipitation" ${OUTFILE}
                 echo

                 echo
                 echo ncatted -h -O -a   description,${VARNAME},m,c,"Total Monthly Precipitation" ${OUTFILE}
                 echo
                      ncatted -h -O -a   description,${VARNAME},m,c,"Total Monthly Precipitation" ${OUTFILE}
                 echo

              else

                if [[ ${PAR} == "tasmax" ]]; then

                  export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_MEAN.nc

                  echo
                  echo processing ${OUTFILE}

                  echo
                  echo cdo -O  -z zip_8 yearmean ${SUBSETFILE} ${OUTFILE}
                  echo
                       cdo -O  -z zip_8 yearmean ${SUBSETFILE} ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo

                  export MIDFILE=${OUTFILE}

                  export OUTFILE=${CLIPPED_OUTDIR_I}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_PERIOD_ANNUAL_MEAN.nc

                  echo
                  echo processing ${OUTFILE}

                  echo
                  echo cdo -b I32 -O  -z zip_8 timmean  ${MIDFILE} ${OUTFILE}
                  echo
                       cdo -b I32 -O  -z zip_8 timmean  ${MIDFILE} ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Max Temperature" ${OUTFILE}
                  echo

                  export OUTFILE=${CLIPPED_OUTDIR_M}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_MONTLY_MEAN.nc

                  echo
                  echo processing ${OUTFILE}

                  echo
                  echo cdo -b I32 -O  -z zip_8 monmean  ${SUBSETFILE} ${OUTFILE}
                  echo
                       cdo -b I32 -O  -z zip_8 monmean  ${SUBSETFILE} ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Max Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Max Temperature" ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Max Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Max Temperature" ${OUTFILE}
                  echo

                else
                  export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_MEAN.nc

                  echo
                  echo processing ${OUTFILE}

                  echo
                  echo cdo  -O  -z zip_8 yearmean ${SUBSETFILE} ${OUTFILE}
                  echo
                       cdo  -O  -z zip_8 yearmean  ${SUBSETFILE} ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo

                  export MIDFILE=${OUTFILE}

                  export OUTFILE=${CLIPPED_OUTDIR_I}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_PERIOD_ANNUAL_MEAN.nc

                  echo
                  echo processing ${OUTFILE}

                  echo
                  echo cdo  -O  -z zip_8 timmean  ${MIDFILE} ${OUTFILE}
                  echo
                       cdo  -O  -z zip_8 timmean  ${MIDFILE} ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,"Mean Annual Min Temperature" ${OUTFILE}
                  echo

                  export OUTFILE=${CLIPPED_OUTDIR_M}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_MONTLY_MEAN.nc

                  echo
                  echo processing ${OUTFILE}

                  echo
                  echo cdo  -O  -z zip_8 monmean  ${SUBSETFILE} ${OUTFILE}
                  echo
                       cdo  -O  -z zip_8 monmean  ${SUBSETFILE} ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Min Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean Monthly Min Temperature" ${OUTFILE}
                  echo

                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Min Temperature" ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,"Mean Monthly Min Temperature" ${OUTFILE}
                  echo
                fi
              fi


           else  #  offmvycle

             mkdir -v -p ${CLIPPED_OUTDIR_D}

              # Calculating Daily Means

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
              ##  CALCULATE DOY MEANS
              ##

              export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_AVERAGES.nc
              echo
              echo processing ${OUTFILE}
              echo
              echo Processing ${PAR}_${ENS}_${SCEN} ydaymean ${START_DATE} - ${END_DATE}
              echo
              echo cdo  -O -z zip_8 ydaymean ${SUBSETFILE} ${OUTFILE}
              echo
                   cdo  -O -z zip_8 ydaymean ${SUBSETFILE} ${OUTFILE}
              echo

              if [[ ${PAR} == "pr" ]]; then
                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Total Preciptation" ${OUTFILE}
                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Total Preciptation" ${OUTFILE}
                echo
              fi

              if [[ ${PAR} == "tasmin" ]]; then

                echo
                echo cp -frv ${SUBSETFILE} ./TEMP_tasmin.nc
                echo
                     cp -frv ${SUBSETFILE} ./TEMP_tasmin.nc

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Min Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Min Daily Temperature" ${OUTFILE}
                echo
              fi

              if [[ ${PAR} == "tasmax" ]]; then

                echo
                echo cp -frv ${SUBSETFILE} ./TEMP_tasmax.nc
                echo
                     cp -frv ${SUBSETFILE} ./TEMP_tasmax.nc

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}
                echo
              fi



              ##
              ##  CALCULATE DOY Min
              ##

              export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_P000.nc
              export MINFILE=${OUTFILE}
              echo
              echo processing ${OUTFILE}
              echo
              echo Processing ${PAR}_${ENS}_${SCEN} ydaymin ${START_DATE} - ${END_DATE}
              echo
              echo cdo  -O -z zip_8 ydaymin ${SUBSETFILE} ${OUTFILE}
              echo
                   cdo  -O -z zip_8 ydaymin ${SUBSETFILE} ${OUTFILE}
              echo

              if [[ ${PAR} == "pr" ]]; then
                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Total Preciptation" ${OUTFILE}
                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Total Preciptation" ${OUTFILE}
                echo
              fi

              if [[ ${PAR} == "tasmin" ]]; then

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Min Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Min Daily Temperature" ${OUTFILE}
                echo
              fi

              if [[ ${PAR} == "tasmax" ]]; then

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Max Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Max Daily Temperature" ${OUTFILE}
                echo
              fi




              ##
              ##  CALCULATE DOY Max
              ##

              export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_P100.nc
              export MAXFILE=${OUTFILE}
              echo
              echo processing ${OUTFILE}
              echo
              echo Processing ${PAR}_${ENS}_${SCEN} ydaymax ${START_DATE} - ${END_DATE}
              echo
              echo cdo  -O -z zip_8 ydaymax ${SUBSETFILE} ${OUTFILE}
              echo
                   cdo  -O -z zip_8 ydaymax ${SUBSETFILE} ${OUTFILE}
              echo

              if [[ ${PAR} == "pr" ]]; then
                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Total Preciptation" ${OUTFILE}
                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Total Preciptation" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Total Preciptation" ${OUTFILE}
                echo
              fi

              if [[ ${PAR} == "tasmin" ]]; then

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Min Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Min Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Min Daily Temperature" ${OUTFILE}
                echo
              fi

              if [[ ${PAR} == "tasmax" ]]; then

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Max Daily Temperature" ${OUTFILE}

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Max Daily Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Max Daily Temperature" ${OUTFILE}
                echo
              fi


              ##
              ##  CALCULATE DOY Ptiles
              ##

              for PER in "${PERCENTILE[@]}"
              do
                ##
                ##  CALCULATE DOY Ptiles
                ##

                export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_P${PER}.nc

                echo
                echo processing ${OUTFILE}
                echo
                echo Processing ${PAR}_${ENS}_${SCEN} ydaypctl @ ${PER}% ${START_DATE} - ${END_DATE}
                echo
                echo cdo  -O -z zip_8 ydaypctl ${SUBSETFILE} ${MINFILE} ${MAXFILE} ${OUTFILE}
                echo
                     cdo  -O -z zip_8 ydaypctl ${SUBSETFILE} ${MINFILE} ${MAXFILE} ${OUTFILE}
                echo

                if [[ ${PAR} == "pr" ]]; then
                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Total Preciptation'"' ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Total Preciptation'"' ${OUTFILE}
                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Total Preciptation'"' ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Total Preciptation'"' ${OUTFILE}
                  echo
                fi

                if [[ ${PAR} == "tasmin" ]]; then

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Min Daily Temperature'"' ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Min Daily Temperature'"' ${OUTFILE}
                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Min Daily Temperature'"' ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Min Daily Temperature'"' ${OUTFILE}
                  echo
                fi

                if [[ ${PAR} == "tasmax" ]]; then

                  echo
                  echo ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Max Daily Temperature'"' ${OUTFILE}
                  echo
                       ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Max Daily Temperature'"' ${OUTFILE}
                  echo
                  echo ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Max Daily Temperature'"' ${OUTFILE}
                  echo
                       ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Max Daily Temperature'"' ${OUTFILE}
                  echo
                fi
              done


              rm -frv ./cdo_period_subset.nc

           fi

           echo

        done #parameter




        # process daily average temperature

        export VARNAME="tasavg"

        export CLIPPED_OUTDIR_D=${CLIPPED_OUTDIR_ROOT}/DAILY/tasavg

        mkdir -v -p ${CLIPPED_OUTDIR_D}

        rm -frv ./cdo_period_subset.nc

        export SUBSETFILE="./cdo_period_subset.nc"

        ncflint -w 0.5,0.5 ./TEMP_tasmin.nc ./TEMP_tasmax.nc ${SUBSETFILE}

        ##
        ##  CALCULATE DOY MEANS
        ##

        export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_AVERAGES.nc
        echo
        echo processing ${OUTFILE}
        echo
        echo Processing ${PAR}_${ENS}_${SCEN} ydaymean ${START_DATE} - ${END_DATE}
        echo
        echo cdo  -O -z zip_8 ydaymean ${SUBSETFILE} ${OUTFILE}
        echo
             cdo  -O -z zip_8 ydaymean ${SUBSETFILE} ${OUTFILE}
        echo



          echo
          echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Mean Daily Temperature" ${OUTFILE}
          echo
               ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Mean Daily Temperature" ${OUTFILE}
          echo
          echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Mean Daily Temperature" ${OUTFILE}
          echo
               ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Mean Daily Temperature" ${OUTFILE}
          echo



        ##
        ##  CALCULATE DOY Min
        ##

        export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_P000.nc
        export MINFILE=${OUTFILE}
        echo
        echo processing ${OUTFILE}
        echo
        echo Processing ${PAR}_${ENS}_${SCEN} ydaymin ${START_DATE} - ${END_DATE}
        echo
        echo cdo  -O -z zip_8 ydaymin ${SUBSETFILE} ${OUTFILE}
        echo
             cdo  -O -z zip_8 ydaymin ${SUBSETFILE} ${OUTFILE}
        echo

          echo
          echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Mean Daily Temperature" ${OUTFILE}
          echo
               ncatted -h -O -a     long_name,${VARNAME},m,c,"Min DOY Mean Daily Temperature" ${OUTFILE}

          echo
          echo ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Mean Daily Temperature" ${OUTFILE}
          echo
               ncatted -h -O -a   description,${VARNAME},m,c,"Min DOY Mean Daily Temperature" ${OUTFILE}
          echo




        ##
        ##  CALCULATE DOY Max
        ##

        export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_P100.nc
        export MAXFILE=${OUTFILE}
        echo
        echo processing ${OUTFILE}
        echo
        echo Processing ${PAR}_${ENS}_${SCEN} ydaymax ${START_DATE} - ${END_DATE}
        echo
        echo cdo  -O -z zip_8 ydaymax ${SUBSETFILE} ${OUTFILE}
        echo
             cdo  -O -z zip_8 ydaymax ${SUBSETFILE} ${OUTFILE}
        echo

          echo
          echo cp -frv ${SUBSETFILE} ./TEMP_tasmin.nc
          echo
               cp -frv ${SUBSETFILE} ./TEMP_tasmin.nc

          echo
          echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Mean Daily Temperature" ${OUTFILE}
          echo
               ncatted -h -O -a     long_name,${VARNAME},m,c,"Max DOY Mean Daily Temperature" ${OUTFILE}
          echo
          echo ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Mean Daily Temperature" ${OUTFILE}
          echo
               ncatted -h -O -a   description,${VARNAME},m,c,"Max DOY Mean Daily Temperature" ${OUTFILE}
          echo


        ##
        ##  CALCULATE DOY Ptiles
        ##

        for PER in "${PERCENTILE[@]}"
        do
          ##
          ##  CALCULATE DOY Ptiles
          ##

          export OUTFILE=${CLIPPED_OUTDIR_D}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_P${PER}.nc

          echo
          echo processing ${OUTFILE}
          echo
          echo Processing ${PAR}_${ENS}_${SCEN} ydaypctl @ ${PER}% ${START_DATE} - ${END_DATE}
          echo
          echo cdo  -O -z zip_8 ydaypctl,${PER} ${SUBSETFILE} ${MINFILE} ${MAXFILE} ${OUTFILE}
          echo
               cdo  -O -z zip_8 ydaypctl,${PER} ${SUBSETFILE} ${MINFILE} ${MAXFILE} ${OUTFILE}
          echo


            echo
            echo ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Mean Daily Temperature'"' ${OUTFILE}
            echo
                 ncatted -h -O -a     long_name,${VARNAME},m,c,'"'P${PER} DOY Mean Daily Temperature'"' ${OUTFILE}
            echo
            echo ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Mean Daily Temperature'"' ${OUTFILE}
            echo
                 ncatted -h -O -a   description,${VARNAME},m,c,'"'P${PER} DOY Mean Daily Temperature'"' ${OUTFILE}
            echo

        done

        rm -frv ./TEMP_tasmin.nc ./TEMP_tasmax.nc ./cdo_period_subset.nc

        echo

  done
echo
done



echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
