#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}



   export CLIPPED_WORKDIR="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_OUTPUT/grid_ngp"
   export CLIPPED_OUTDIR_ROOT="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_NGP"
   mkdir -vp ${CLIPPED_WORKDIR}

   export CLIPPED_PREFIX=${CLIPPED_WORKDIR}"/NGP_LOCA"



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




   # setting the available variables

   declare -a    PARAM=( "tasmin" "tasmax" "pr")

   declare -a SCENARIO=( "historical" "rcp45" "rcp85" )





echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
for SCEN in "${SCENARIO[@]}"
do


   for PAR in "${PARAM[@]}"
   do

      export CLIPPED_OUTPREFIX=${CLIPPED_OUTDIR_ROOT}/${SCEN}/${PAR}/NGP_LOCA

      for ENS in "${ENSEMBLE[@]}"
      do

         echo nohup ncrcat -O --deflate 8 -h ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc ${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}.nc
              nohup ncrcat -O --deflate 8 -h ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc ${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}.nc

         # echo rm -frv ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc
         #    rm -frv ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc


         echo
         echo - - - - - - - - - - - - - - - - - - -
         echo

      done
      echo --------------------------------------
      echo
   done
   echo ======================================
   echo
done




echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
