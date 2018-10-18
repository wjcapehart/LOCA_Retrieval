#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=( "pr" "tasmin" "tasmax" )
  declare -a SCENARIO=(  "historical"  )
  declare -a SCENARIO=(  "historical" "rcp85" "rcp45" )







   export       DATASET="LOCA_NGP"
   export DATASETPREFIX="NGP_LOCA"

   export CLIPPED_INDIR_ROOT="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/${DATASET}"

   export CDO_PCTL_NBINS=21



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

declare -a PERCENTILE=( 005 010 015 020 025 030 035 040 045 050 055 060 065 070 075 080 085 090 095 )
declare -a PERCENTILE=( 005 010         025                 050                 075         090 095 )

   # setting the available variables





for SCEN in "${SCENARIO[@]}"
do
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo

   if [[ ${SCEN} == "historical" ]]; then
      export PERIOD_STRING="1961-1990"
      export    START_DATE="1961-01-01"
      export      END_DATE="1990-12-31"
      export            NY=30

      export PERIOD_STRING="1950-2005"
      export    START_DATE="1950-01-01"
      export      END_DATE="2005-12-31"
      export            NY=56

      export PERIOD_STRING="1961-1990"
      export    START_DATE="1961-01-01"
      export      END_DATE="1990-12-31"
      export            NY=30

   else

      export PERIOD_STRING="2006-2099"
      export    START_DATE="2006-01-01"
      export      END_DATE="2099-12-31"
      export            NY=94


      export PERIOD_STRING="2007-2017"
      export    START_DATE="2007-01-01"
      export      END_DATE="2017-12-31"
      export            NY=11



   fi

   export ENS=${ENSEMBLE[0]}
   export PAR=${PARAM[0]}
   export PTILE=${PERCENTILE[9]}
   export SCEN=${SCENARIO[0]}

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
         echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         echo

         rm -frv ./cdo_period_subset.nc

         export  INFILE=${CLIPPED_INPREFIX}_${PAR}_${ENS}_${SCEN}.nc

         echo processing $INFILE

         export
         export  VARNAME=${PAR}_${ENS}_${SCEN}
         export  MAXFILE=${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}_CDO_PTILE_100_${PERIOD_STRING}.nc
         export  MINFILE=${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}_CDO_PTILE_000_${PERIOD_STRING}.nc
         export  AVGFILE=${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}_CDO____AVG____${PERIOD_STRING}.nc
         export TAVGFILE=${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}_CDO___TAVG____${PERIOD_STRING}.nc
         export TSUMFILE=${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}_CDO___TSUM____${PERIOD_STRING}.nc


         # if the full data period is being used extract annial and monthly series

         if [ ${PERIOD_STRING} ==  "1950-2005" ] || [ ${PERIOD_STRING} ==  "2006-2099" ]; then



            echo Using Full Period String = ${PERIOD_STRING} using original file
            export SUBSETFILE=${INFILE}
            echo


            mkdir -vp CLIPPED_OUTDIR_A
            mkdir -vp CLIPPED_OUTDIR_M

            if [[ ${PAR} == "pr" ]]; then

              export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_YEARLY_TOTAL.nc

              echo cdo -O -b I32 -z zip_8 yearsum  ${SUBSETFILE} ${OUTFILE}
                   cdo -O -b I32 -z zip_8 yearsum  ${SUBSETFILE} ${OUTFILE}

               ncatted -h -O -a     long_name,temporary,m,c,"Total Annual Precipitation" ${TSUMFILE}
               ncatted -h -O -a   description,temporary,m,c,"Total Annual Precipitation" ${TSUMFILE}

               export OUTFILE=${CLIPPED_OUTDIR_A}/${DATASET}_${VARNAME}_${PERIOD_STRING}_CDO_MONTLY_TOTAL.nc

               echo cdo -O -b I32 -z zip_8 monthsum  ${SUBSETFILE} ${OUTFILE}
                    cdo -O -b I32 -z zip_8 monthsum  ${SUBSETFILE} ${OUTFILE}

                ncatted -h -O -a     long_name,temporary,m,c,"Monthly Total Precipitation" ${TSUMFILE}
                ncatted -h -O -a   description,temporary,m,c,"Annual Total Precipitation" ${TSUMFILE}

            else



            fi


         else
            export SUBSETFILE="./cdo_period_subset.nc"
            echo Using Period String = ${PERIOD_STRING} clipping file
            echo Processing ${PAR}_${ENS}_${SCEN} seldate ${START_DATE} - ${END_DATE}
            echo cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INFILE} ${SUBSETFILE}
                 cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INFILE} ${SUBSETFILE}
            echo
         fi

#



         if [[ ${PAR} == "pr" ]]; then
            echo Processing ${PAR}_${ENS}_${SCEN} daysum  ${START_DATE} - ${END_DATE}
            echo cdo -O -b I32 -z zip_8 ydaysum  ${SUBSETFILE} ${SUMFILE}
                 cdo -O -b I32 -z zip_8 ydaysum  ${SUBSETFILE} ${SUMFILE}
            echo
         else
            echo Processing ${PAR}_${ENS}_${SCEN} daymean ${START_DATE} - ${END_DATE}
            echo cdo -O -z zip_8 ydaymean ${SUBSETFILE} ${AVGFILE}
                 cdo -O -z zip_8 ydaymean ${SUBSETFILE} ${AVGFILE}
            echo
         fi
#
#         # Aggregates Totals for Entire Period
#
         if [[ ${PAR} == "pr" ]]; then
            echo Processing ${PAR}_${ENS}_${SCEN} fldsum  ${START_DATE} - ${END_DATE}
            echo cdo -O -b I32 -z zip_8 timsum ${SUMFILE} ${TSUMFILE}
                 cdo -O -b I32 -z zip_8 timsum ${SUMFILE} ${TSUMFILE}
            echo


            echo ncrename -h -v ${VARNAME},temporary ${TSUMFILE}
                 ncrename -h -v ${VARNAME},temporary ${TSUMFILE}
            echo
            formula =
            echo ncap2 --history --deflate 8 --script "where(temporary > 0) temporary=short(round(temporary/${NY}))" ${TSUMFILE} ${TSUMFILE}_short.nc
                 ncap2 --history --deflate 8 --script "where(temporary > 0) temporary=short(round(temporary/${NY}))" ${TSUMFILE} ${TSUMFILE}_short.nc
            mv -v ${TSUMFILE}_short.nc  ${TSUMFILE}

            ncatted -h -O -a     long_name,temporary,m,c,"Mean Annual Total Precipitation" ${TSUMFILE}
            ncatted -h -O -a   description,temporary,m,c,"Mean Annual Total Precipitation" ${TSUMFILE}

            echo
            echo ncrename -h -v temporary,${VARNAME} ${TSUMFILE}
                 ncrename -h -v temporary,${VARNAME} ${TSUMFILE}
            echo

         fi


         if [[ ${PAR} == "tasmax" ]]; then

            echo Processing ${PAR}_${ENS}_${SCEN} fldmean ${START_DATE} - ${END_DATE}
            echo cdo -O -z zip_8 timmean ${AVGFILE} ${TAVGFILE}
                 cdo -O -z zip_8 timmean ${AVGFILE} ${TAVGFILE}
            echo

            ncatted -h -O -a     long_name,temporary,m,c,"Mean Annual Maximum Daily Temperature" ${TAVGFILE}
            ncatted -h -O -a   description,temporary,m,c,"Mean Annual Maximum Daily Temperature" ${TAVGFILE}

         fi

         if [[ ${PAR} == "tasmin" ]]; then

            echo Processing ${PAR}_${ENS}_${SCEN} fldmean ${START_DATE} - ${END_DATE}
            echo cdo -O -z zip_8 timmean ${AVGFILE} ${TAVGFILE}
                 cdo -O -z zip_8 timmean ${AVGFILE} ${TAVGFILE}
            echo

            ncatted -h -O -a     long_name,temporary,m,c,"Mean Annual Minimum Daily Temperature" ${TAVGFILE}
            ncatted -h -O -a   description,temporary,m,c,"Mean Annual Minimum Daily Temperature" ${TAVGFILE}

         fi

         # Percentiles

#         echo Processing ${PAR}_${ENS}_${SCEN} ydaymin ${START_DATE} - ${END_DATE}
#         cdo -z zip_8 ydaymin ${SUBSETFILE} ${MAXFILE}
#         echo
#
#         echo Processing ${PAR}_${ENS}_${SCEN} ydaymax ${START_DATE} - ${END_DATE}
#         cdo -z zip_8 ydaymax ${SUBSETFILE} ${MINFILE}
#         echo
#
#         for PTILE in "${PERCENTILE[@]}"
#         do
#
#            export OUTFILE=${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}_CDO_PTILE_${PTILE}_${PERIOD_STRING}.nc
#
#            echo Processing ${PAR}_${ENS}_${SCEN} pct${PTILE} ${START_DATE} - ${END_DATE}
#            cdo -z zip_8 ydaypctl,${PTILE} ${SUBSETFILE} ${MINFILE} ${MAXFILE} ${OUTFILE}
#            echo
#
#         done

         rm -frv ./cdo_period_subset.nc
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
