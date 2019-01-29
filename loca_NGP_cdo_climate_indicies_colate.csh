#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=( "pr" "tasmin" "tasmax" )
  declare -a SCENARIO=( "historical" "rcp85" "rcp45" )

  declare -a CLIM_PERIOD="1961-1990"



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

    declare -a ENSEMBLE=(   "ACCESS1-0_r1i1p1"
                            "ACCESS1-3_r1i1p1"
                            "CCSM4_r6i1p1"
                            "CESM1-BGC_r1i1p1"
                            "CESM1-CAM5_r1i1p1"
                            "CMCC-CMS_r1i1p1"
                            "CMCC-CM_r1i1p1"
                            "CNRM-CM5_r1i1p1"
                             )



  declare -a CL_INDEX=(   "ECACDD"
                          "ECACFD"
                          "ECACSU"
                          "ECACWD"
                          "ECACWDI"
                          "ECACWFI"
                          "ECAETR"
                          "ECAFD"
                          "ECAGSL"
                          "ECAHD"
                          "ECAHWDI"
                          "ECAHWFI"
                          "ECAID"
                          "ECAR75P"
                          "ECAR75PTOT"
                          "ECAR90P"
                          "ECAR90PTOT"
                          "ECAR90P"
                          "ECAR90PTOT"
                          "ECAR90P"
                          "ECAR90PTOT"
                          "ECAPD010"
                          "ECAPD020"
                          "ECARR1"
                          "MONMAX"
                          "ECARX5DAY"
                          "ECAR050-5DAY"
                          "ECAR025-5DAY"
                          "ECASDII"
                          "ECATG10P"
                          "ECATG90P"
                          "ECATN10P"
                          "ECATN90P"
                          "ECATR"
                          "ECATX10P"
                          "ECATX90P" )


   export       DATASET="LOCA_NGP"
   export DATASETPREFIX="NGP_LOCA"

   export CLIPPED_INDIR_ROOT="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/${DATASET}"


   export CLIPPED_OUTDIR_ROOT=${CLIPPED_INDIR_ROOT}/climatology/DERIVED/YEARLY/ETCCDI



   # setting the available variables


for ENS in "${ENSEMBLE[@]}"
do

  echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  echo @
  echo @ Processing ${ENS}
  echo @
  echo

  for PARAM in "${CL_INDEX[@]}"
  do

    echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    echo .
    echo . Processing ${ENS} : ${PARAM}
    echo .
    echo

    for SCEN in "${SCENARIO[@]}"
    do

      INCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_*.nc

      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}.nc

      echo $OUTCI_FILE

      echo ncrcat  -O --deflate 8 -h ${INCI_FILE} ${OUTCI_FILE}

    done

    echo
    echo .
    echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . .


  done
  
  echo
  echo @
  echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


done




echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
