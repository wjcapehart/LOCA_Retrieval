#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=("tasmin" "tasmax" )
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

   export CLIPPED_INDIR_ROOT="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/${DATASET}"

   export CDO_PCTL_NBINS=21





declare -a PERCENTILE=( 005 010         025                 050                 075         090 095 )

   # setting the available variables



   export ENS=${ENSEMBLE[0]}
   export PAR=${PARAM[0]}
   export PTILE=${PERCENTILE[9]}
   export SCEN=${SCENARIO[0]}

for SCEN in "${SCENARIO[@]}"
do
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo

   if [[ ${SCEN} == "historical" ]]; then
      export PERIOD_STRING="1961-1990"
      export    START_DATE="1961-01-01"
      export      END_DATE="1990-12-31"
      export            NY=30

      export PERIOD_STRING="1961-1990"
      export    START_DATE="1961-01-01"
      export      END_DATE="1990-12-31"
      export            NY=30

      export PERIOD_STRING="1950-2005"
      export    START_DATE="1950-01-01"
      export      END_DATE="2005-12-31"
      export            NY=56

   else



      export PERIOD_STRING="2007-2017"
      export    START_DATE="2007-01-01"
      export      END_DATE="2017-12-31"
      export            NY=11

      export PERIOD_STRING="2006-2099"
      export    START_DATE="2006-01-01"
      export      END_DATE="2099-12-31"
      export            NY=94



   fi



   for PAR in "${PARAM[@]}"
   do
      echo =============================================================
      echo

      export CLIPPED_INPREFIX=${CLIPPED_INDIR_ROOT}/${SCEN}/${PAR}/${DATASETPREFIX}

      echo processing $CLIPPED_INPREFIX

      export   CLIPPED_OUTDIR_ROOT=${CLIPPED_INDIR_ROOT}/climatology/${PERIOD_STRING}


      export   CLIPPED_OUTDIR_I=${CLIPPED_OUTDIR_ROOT}/INTERANNUAL/${PAR}
      export   CLIPPED_OUTDIR_D=${CLIPPED_OUTDIR_ROOT}/DAILY/${PAR}
      export   CLIPPED_OUTDIR_A=${CLIPPED_OUTDIR_ROOT}/ANNUAL/${PAR}
      export   CLIPPED_OUTDIR_M=${CLIPPED_OUTDIR_ROOT}/MONTHLY/${PAR}

      mkdir -vp ${CLIPPED_OUTDIR_ROOT}


      for ENS in "${ENSEMBLE[@]}"
      do
         echo
         echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         echo

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



            else

              if [[ ${PAR} == "tasmax" ]]; then


                export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_MAX.nc

                echo
                echo processing ${OUTFILE}

                echo
                echo cdo  -O  -z zip_8 yearmax ${SUBSETFILE} ${OUTFILE}
                echo
                     cdo  -O  -z zip_8 yearmax  ${SUBSETFILE} ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Max Annual Max Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Max Annual Max Temperature" ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Max Annual Max Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Max Annual Max Temperature" ${OUTFILE}
                echo

                export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_MIN.nc

                echo
                echo processing ${OUTFILE}

                echo
                echo cdo  -O  -z zip_8 yearmin ${SUBSETFILE} ${OUTFILE}
                echo
                     cdo  -O  -z zip_8 yearmin  ${SUBSETFILE} ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Min Annual Max Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Min Annual Max Temperature" ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Min Annual Max Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Min Annual Max Temperature" ${OUTFILE}
                echo



              else



                export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_MAX.nc

                echo
                echo processing ${OUTFILE}

                echo
                echo cdo  -O  -z zip_8 yearmax ${SUBSETFILE} ${OUTFILE}
                echo
                     cdo  -O  -z zip_8 yearmax  ${SUBSETFILE} ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Max Annual Min Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Max Annual Min Temperature" ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Max Annual Min Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Max Annual Min Temperature" ${OUTFILE}
                echo

                export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_MIN.nc

                echo
                echo processing ${OUTFILE}

                echo
                echo cdo  -O  -z zip_8 yearmin ${SUBSETFILE} ${OUTFILE}
                echo
                     cdo  -O  -z zip_8 yearmin  ${SUBSETFILE} ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Min Annual Min Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a     long_name,${VARNAME},m,c,"Min Annual Min Temperature" ${OUTFILE}
                echo

                echo
                echo ncatted -h -O -a   description,${VARNAME},m,c,"Min Annual Min Temperature" ${OUTFILE}
                echo
                     ncatted -h -O -a   description,${VARNAME},m,c,"Min Annual Min Temperature" ${OUTFILE}
                echo




              fi
            fi

































         else

            echo
            echo .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .

            mkdir -vp ${CLIPPED_OUTDIR_D}

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

            export OUTFILE=${CLIPPED_OUTDIR_M}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_DOY_AVERAGES.nc
            echo
            echo processing ${OUTFILE}
            echo
            echo Processing ${PAR}_${ENS}_${SCEN} daymean ${START_DATE} - ${END_DATE}
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
              echo ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}
              echo
                   ncatted -h -O -a     long_name,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}

              echo
              echo ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}
              echo
                   ncatted -h -O -a   description,${VARNAME},m,c,"Mean DOY Max Daily Temperature" ${OUTFILE}
              echo
            fi

            rm -frv ./cdo_period_subset.nc

         fi

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
