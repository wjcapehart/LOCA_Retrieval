#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}

  declare -a    PARAM=( "pr" "tasmin" "tasmax" )
  declare -a SCENARIO=( "historical" "rcp85" "rcp45" )

  declare -a CLIM_PERIOD="1961-1990"

  declare -a START_YEAR=1950
  declare -a   END_YEAR=2099


  INPUT_SUBSET_TMIN="./INPUT_SUBSET_TMIN.nc"
  INPUT_SUBSET_TMAX="./INPUT_SUBSET_TMAX.nc"
  INPUT_SUBSET_PREC="./INPUT_SUBSET_PREC.nc"

  rm -v ${INPUT_SUBSET_TMIN} ${INPUT_SUBSET_TMAX} ${INPUT_SUBSET_PREC}


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

    declare -a CL_INDEX=(
                            "ECARX1DAY"
                            "ECATN10P"
                            "ECATN90P"
                            "ECATX10P"
                            "ECATX90P" )


   export       DATASET="LOCA_NGP"
   export DATASETPREFIX="NGP_LOCA"

   export CLIPPED_INDIR_ROOT="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/${DATASET}"

   export CLIPPED_CLIMATOLOGY_ROOT=${CLIPPED_INDIR_ROOT}/climatology/${CLIM_PERIOD}/DAILY


   export CLIPPED_OUTDIR_ROOT=${CLIPPED_INDIR_ROOT}/climatology/DERIVED/YEARLY/ETCCDI

   mkdir -vp ${CLIPPED_OUTDIR_ROOT}

   export CDO_PCTL_NBINS=21





   # setting the available variables



    ENS="ACCESS1-0_r1i1p1"
    YEAR=1950
    SCEN="historical"

for ENS in "${ENSEMBLE[@]}"
do

  echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  echo @
  echo @ Processing ${ENS}
  echo @
  echo

  rm -frv ./CLIM_TMIN_P010.nc ./CLIM_TMIN_P090.nc  ./CLIM_TMIN_MEAN.nc

  CLIM_TMIN_P010=${CLIPPED_CLIMATOLOGY_ROOT}/tasmin/${DATASET}_tasmin_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P010.nc
  CLIM_TMIN_P090=${CLIPPED_CLIMATOLOGY_ROOT}/tasmin/${DATASET}_tasmin_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P090.nc
  CLIM_TMIN_MEAN=${CLIPPED_CLIMATOLOGY_ROOT}/tasmin/${DATASET}_tasmin_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_AVERAGES.nc

  cdo -O -z zip_8 addc,273.15 ${CLIM_TMIN_P010} ./CLIM_TMIN_P010.nc
  cdo -O -z zip_8 addc,273.15 ${CLIM_TMIN_P090} ./CLIM_TMIN_P090.nc
  cdo -O -z zip_8 addc,273.15 ${CLIM_TMIN_MEAN} ./CLIM_TMIN_MEAN.nc

  CLIM_TMIN_P010=./CLIM_TMIN_P010.nc
  CLIM_TMIN_P090=./CLIM_TMIN_P090.nc
  CLIM_TMIN_MEAN=./CLIM_TMIN_MEAN.nc


  CLIM_TMAX_P010=${CLIPPED_CLIMATOLOGY_ROOT}/tasmax/${DATASET}_tasmax_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P010.nc
  CLIM_TMAX_P090=${CLIPPED_CLIMATOLOGY_ROOT}/tasmax/${DATASET}_tasmax_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P090.nc
  CLIM_TMAX_MEAN=${CLIPPED_CLIMATOLOGY_ROOT}/tasmax/${DATASET}_tasmax_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_AVERAGES.nc

  rm -frv ./CLIM_TMAX_P010.nc ./CLIM_TMAX_P090.nc  ./CLIM_TMAX_MEAN.nc


  cdo -O -z zip_8 addc,273.15 ${CLIM_TMAX_P010} ./CLIM_TMAX_P010.nc
  cdo -O -z zip_8 addc,273.15 ${CLIM_TMAX_P090} ./CLIM_TMAX_P090.nc
  cdo -O -z zip_8 addc,273.15 ${CLIM_TMAX_MEAN} ./CLIM_TMAX_MEAN.nc

  CLIM_TMAX_P010=./CLIM_TMAX_P010.nc
  CLIM_TMAX_P090=./CLIM_TMAX_P090.nc
  CLIM_TMAX_MEAN=./CLIM_TMAX_MEAN.nc


  rm -frv ./CLIM_TAVG_P010.nc ./CLIM_TAVG_P090.nc  ./CLIM_TAVG_MEAN.nc

  CLIM_TAVG_P010=${CLIPPED_CLIMATOLOGY_ROOT}/tasavg/${DATASET}_tasavg_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P010.nc
  CLIM_TAVG_P090=${CLIPPED_CLIMATOLOGY_ROOT}/tasavg/${DATASET}_tasavg_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P090.nc
  CLIM_TAVG_MEAN=${CLIPPED_CLIMATOLOGY_ROOT}/tasavg/${DATASET}_tasavg_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_AVERAGES.nc

  cdo -O -z zip_8 addc,273.15 ${CLIM_TAVG_P010} ./CLIM_TAVG_P010.nc
  cdo -O -z zip_8 addc,273.15 ${CLIM_TAVG_P090} ./CLIM_TAVG_P090.nc
  cdo -O -z zip_8 addc,273.15 ${CLIM_TAVG_MEAN} ./CLIM_TAVG_MEAN.nc

  CLIM_TAVG_P010=./CLIM_TAVG_P010.nc
  CLIM_TAVG_P090=./CLIM_TAVG_P090.nc
  CLIM_TAVG_MEAN=./CLIM_TAVG_MEAN.nc


  rm -frv ./CLIM_PREC_P075.nc ./CLIM_PREC_P090.nc  ./CLIM_PREC_P095.nc  ./CLIM_PREC_P099.nc



  CLIM_PREC_P075=${CLIPPED_CLIMATOLOGY_ROOT}/pr/${DATASET}_pr_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P075.nc
  CLIM_PREC_P090=${CLIPPED_CLIMATOLOGY_ROOT}/pr/${DATASET}_pr_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P090.nc
  CLIM_PREC_P095=${CLIPPED_CLIMATOLOGY_ROOT}/pr/${DATASET}_pr_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P095.nc
  CLIM_PREC_P099=${CLIPPED_CLIMATOLOGY_ROOT}/pr/${DATASET}_pr_${ENS}_historical_${CLIM_PERIOD}_CDO_DOY_P099.nc


  ls -l ${CLIM_TMIN_P010}
  ls -l ${CLIM_TMIN_P090}

  ls -l ${CLIM_TMAX_P010}
  ls -l ${CLIM_TMAX_P090}

  ls -l ${CLIM_PREC_P075}
  ls -l ${CLIM_PREC_P090}
  ls -l ${CLIM_PREC_P095}
  ls -l ${CLIM_PREC_P099}

  echo

  for SCEN in "${SCENARIO[@]}"
  do

    if [[ ${SCEN} -eq "historical" ]]
    then
      START_YEAR=1950
      END_YEAR=2005
    else
      START_YEAR=2006
      END_YEAR=2099
    fi


    for YEAR in `seq ${START_YEAR} ${END_YEAR}`
    do

      export START_DATE=${YEAR}-01-01

      export END_DATE=${YEAR}-12-31


      echo ---- Processing Year ${START_DATE} - ${END_DATE} ----



      INPUT_TMIN_FILE=${CLIPPED_INDIR_ROOT}/${SCEN}/tasmin/${DATASETPREFIX}_tasmin_${ENS}_${SCEN}.nc
      INPUT_TMAX_FILE=${CLIPPED_INDIR_ROOT}/${SCEN}/tasmax/${DATASETPREFIX}_tasmax_${ENS}_${SCEN}.nc
      INPUT_PREC_FILE=${CLIPPED_INDIR_ROOT}/${SCEN}/pr/${DATASETPREFIX}_pr_${ENS}_${SCEN}.nc



      echo
      echo cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INPUT_TMIN_FILE} ${INPUT_SUBSET_TMIN}
      echo
           cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INPUT_TMIN_FILE} ${INPUT_SUBSET_TMIN}
      echo

      echo cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INPUT_TMAX_FILE} ${INPUT_SUBSET_TMAX}
      echo
           cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INPUT_TMAX_FILE} ${INPUT_SUBSET_TMAX}
      echo

      echo cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INPUT_PREC_FILE} ${INPUT_SUBSET_PREC}
      echo
           cdo -O -z zip_8 seldate,${START_DATE},${END_DATE}  ${INPUT_PREC_FILE} ${INPUT_SUBSET_PREC}
      echo



          cdo -O -z zip_8 addc,273.15 ${INPUT_SUBSET_TMAX}  ./deleteme.nc
          mv -v ./deleteme.nc ./INPUT_SUBSET_TMAX.nc

          cdo -O -z zip_8 addc,273.15 ${INPUT_SUBSET_TMIN}  ./deleteme.nc
          mv -v ./deleteme.nc ./INPUT_SUBSET_TMIN.nc


          INPUT_SUBSET_TMAX=./INPUT_SUBSET_TMAX.nc
          INPUT_SUBSET_TMIN=./INPUT_SUBSET_TMIN.nc

          cdo -O -z zip_8 ensmean ${INPUT_SUBSET_TMAX} ${INPUT_SUBSET_TMIN} ./INPUT_SUBSET_TAVG.nc
          INPUT_SUBSET_TAVG=./INPUT_SUBSET_TAVG.nc




         # 2.0.24 ECARX1DAY - Highest one day precipitation amount per time period
         echo
         PARAM="ECARX1DAY"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 monmax ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
              cdo -O -z zip_8 monmax ${INPUT_SUBSET_PREC} ${OUTCI_FILE}




       # 2.0.30 ECATN10P - Cold nights percent w.r.t. 10th percentile of reference period
       echo
       PARAM="ECATN10P"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_tn10p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P010} ${OUTCI_FILE}
           cdo -O -z zip_8 eca_tn10p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P010} ${OUTCI_FILE}

        # 2.0.31 ECATN90P - Warm nights percent w.r.t. 90th percentile of reference period
        echo
        PARAM="ECATN90P"
        OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
        echo cdo -O -z zip_8 eca_tn90p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P090} ${OUTCI_FILE}
             cdo -O -z zip_8 eca_tn90p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P090} ${OUTCI_FILE}



       # 2.0.33 ECATX10P - Very cold days percent w.r.t. 10th percentile of reference period
       echo
       PARAM="ECATX10P"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_tx10p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P010} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_tx10p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P010} ${OUTCI_FILE}


       # 2.0.34 ECATX90P - Very warm days percent w.r.t. 90th percentile of reference period
       echo
       PARAM="ECATX90P"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_tx90p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P090} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_tx90p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P090} ${OUTCI_FILE}




       #  ECATXN Minimum Annual temperature
       echo
       PARAM="ECATNN"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 yearmin ${INPUT_SUBSET_TMIN}  ${OUTCI_FILE}
            cdo -O -z zip_8 yearmin ${INPUT_SUBSET_TMIN}  ${OUTCI_FILE}


       #  ECATXN Minimum Annual temperature
       echo
       PARAM="ECATXX"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 yearmax ${INPUT_SUBSET_TMAX}  ${OUTCI_FILE}
            cdo -O -z zip_8 yearmax ${INPUT_SUBSET_TMAX}  ${OUTCI_FILE}



      rm -v ${INPUT_SUBSET_TMIN} ${INPUT_SUBSET_TMAX} ${INPUT_SUBSET_PREC}

    done

    for PARAM in "${CL_INDEX[@]}"
    do

      echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
      echo .
      echo . Processing ${ENS} : ${PARAM} : ${SCEN}
      echo .
      echo

      INCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_*.nc

      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}.nc

      echo
      ncrcat  -O --deflate 8 -h ${INCI_FILE} ${OUTCI_FILE}
      echo
      rm -frv ${INCI_FILE}

      echo
      echo .
      echo . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

    done

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
