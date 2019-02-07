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



      ### 2.0.1 ECACDD - Consecutive dry days index per time period
      echo
      PARAM="ECACDD"
      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
      echo cdo -O -z zip_8 eca_cdd ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
           cdo -O -z zip_8 eca_cdd ${INPUT_SUBSET_PREC} ${OUTCI_FILE}


       ### 2.0.2 ECACFD - Consecutive frost days index per time period
       echo
       PARAM="ECACFD"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_cfd ${INPUT_SUBSET_TMIN} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_cfd ${INPUT_SUBSET_TMIN} ${OUTCI_FILE}



       ### 2.0.3 ECACSU - Consecutive summer days index per time period
       echo
       PARAM="ECACSU"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_csu ${INPUT_SUBSET_TMAX} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_csu ${INPUT_SUBSET_TMAX} ${OUTCI_FILE}



       ### 2.0.4 ECACWD - Consecutive wet days index per time period
       echo
       PARAM="ECACWD"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_cwd ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_cwd ${INPUT_SUBSET_PREC} ${OUTCI_FILE}


       ### 2.0.5 ECACWDI - Cold wave duration index w.r.t. mean of reference period
       echo
       PARAM="ECACWDI"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_cwdi ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_MEAN} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_cwdi ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_MEAN} ${OUTCI_FILE}


      ### 2.0.6 ECACWFI - Cold-spell days index w.r.t. 10th percentile of reference period
      echo
      PARAM="ECACWFI"
      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
      echo cdo -O -z zip_8 eca_cwfi ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P010} ${OUTCI_FILE}
           cdo -O -z zip_8 eca_cwfi ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P010} ${OUTCI_FILE}

      ### 2.0.7 ECAETR - Intra-period extreme temperature range
      echo
      PARAM="ECAETR"
      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
      echo cdo -O -z zip_8 eca_etr ${INPUT_SUBSET_TMAX} ${INPUT_SUBSET_TMIN} ${OUTCI_FILE}
           cdo -O -z zip_8 eca_etr ${INPUT_SUBSET_TMAX} ${INPUT_SUBSET_TMIN} ${OUTCI_FILE}


     ### 2.0.8 ECAFD - Frost days index per time period
     echo
     PARAM="ECAFD"
     OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
     echo cdo -O -z zip_8 eca_fd ${INPUT_SUBSET_TAVG} ${OUTCI_FILE}
          cdo -O -z zip_8 eca_fd ${INPUT_SUBSET_TAVG} ${OUTCI_FILE}

     ### 2.0.9 ECAGSL - Thermal Growing season length index
     echo
     PARAM="ECAGSL"
     OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
     echo cdo -O -z zip_8 eca_gsl ${INPUT_SUBSET_TAVG} ./mask_for_cdo.nc3 ${OUTCI_FILE}
          cdo -O -z zip_8 eca_gsl ${INPUT_SUBSET_TAVG} ./mask_for_cdo.nc3 ${OUTCI_FILE}


     ### 2.0.10 ECAHD - Heating degree days per time period
     # needs average temperature
     echo
     PARAM="ECAHD"
     OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
     echo cdo -O -z zip_8 eca_hd ${INPUT_SUBSET_TAVG} ${OUTCI_FILE}
          cdo -O -z zip_8 eca_hd ${INPUT_SUBSET_TAVG} ${OUTCI_FILE}

     # 2.0.11 ECAHWDI - Heat wave duration index w.r.t. mean of reference period
     echo
     PARAM="ECAHWDI"
     OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
     echo cdo -O -z zip_8 eca_hwdi ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_MEAN} ${OUTCI_FILE}
          cdo -O -z zip_8 eca_hwdi ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_MEAN} ${OUTCI_FILE}

      # 2.0.12 ECAHWFI - Warm spell days index w.r.t. 90th percentile of reference period
      echo
      PARAM="ECAHWFI"
      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
      echo cdo -O -z zip_8 eca_hwfi ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P090} ${OUTCI_FILE}
           cdo -O -z zip_8 eca_hwfi ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P090} ${OUTCI_FILE}

      # 2.0.13 ECAID - Ice days index per time period
      echo
      PARAM="ECAID"
      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
      echo cdo -O -z zip_8 eca_id ${INPUT_SUBSET_TMAX} ${OUTCI_FILE}
           cdo -O -z zip_8 eca_id ${INPUT_SUBSET_TMAX} ${OUTCI_FILE}

      # 2.0.14 ECAR75P - Moderate wet days w.r.t. 75th percentile of reference period
      echo
      PARAM="ECAR75P"
      OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
      echo cdo -O -z zip_8 eca_r75p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P075} ${OUTCI_FILE}
           cdo -O -z zip_8 eca_r75p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P075} ${OUTCI_FILE}

       # 2.0.15 ECAR75PTOT - Precipitation percent due to R75p days
       echo
       PARAM="ECAR75PTOT"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_r75ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P075} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_r75ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P075} ${OUTCI_FILE}




        # 2.0.16 ECAR90P - Wet days w.r.t. 90th percentile of reference period
        echo
        PARAM="ECAR90P"
        OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
        echo cdo -O -z zip_8 eca_r90p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P090} ${OUTCI_FILE}
             cdo -O -z zip_8 eca_r90p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P090} ${OUTCI_FILE}

         # 2.0.17 ECAR90PTOT - Precipitation percent due to R90p days
         echo
         PARAM="ECAR90PTOT"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_r90ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P090} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_r90ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P090} ${OUTCI_FILE}


        # 2.0.18 ECAR90P - Wet days w.r.t. 90th percentile of reference period
        echo
        PARAM="ECAR95P"
        OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
        echo cdo -O -z zip_8 eca_r95p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P095} ${OUTCI_FILE}
             cdo -O -z zip_8 eca_r95p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P095} ${OUTCI_FILE}

         # 2.0.19 ECAR90PTOT - Precipitation percent due to R90p days
         echo
         PARAM="ECAR95PTOT"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_r95ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P095} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_r95ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P095} ${OUTCI_FILE}


        # 2.0.20 ECAR90P - Wet days w.r.t. 90th percentile of reference period
        echo
        PARAM="ECAR99P"
        OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
        echo cdo -O -z zip_8 eca_r99p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P099} ${OUTCI_FILE}
             cdo -O -z zip_8 eca_r99p ${INPUT_SUBSET_PREC} ${CLIM_PREC_P099} ${OUTCI_FILE}

         # 2.0.21 ECAR90PTOT - Precipitation percent due to R90p days
         echo
         PARAM="ECAR99PTOT"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_r99ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P099} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_r99ptot ${INPUT_SUBSET_PREC} ${CLIM_PREC_P099} ${OUTCI_FILE}


         # 2.0.22 ECAPD - Precipitation days index per time period
         echo
         PARAM="ECAPD010"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_r10mm ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_r10mm ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
         echo
         PARAM="ECAPD020"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_r20mm ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_r20mm ${INPUT_SUBSET_PREC} ${OUTCI_FILE}


         # 2.0.23 ECARR1 - Wet days index per time period
         echo
         PARAM="ECARR1"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_rr1 ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_rr1 ${INPUT_SUBSET_PREC} ${OUTCI_FILE}


         # 2.0.24 ECARX1DAY - Highest one day precipitation amount per time period
         echo
         PARAM="MONMAX"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 monmax ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
              cdo -O -z zip_8 monmax ${INPUT_SUBSET_PREC} ${OUTCI_FILE}

          # 2.0.25 ECARX5DAY - Highest five-day precipitation amount per time period
          echo
          PARAM="ECAR050-5DAY"
          OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
          echo cdo -O -z zip_8 eca_rx5day ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
               cdo -O -z zip_8 eca_rx5day ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
          echo
          PARAM="ECAR025-5DAY"
          OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
          echo cdo -O -z zip_8 eca_rx5day,25 ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
               cdo -O -z zip_8 eca_rx5day,25 ${INPUT_SUBSET_PREC} ${OUTCI_FILE}

         # 2.0.26 ECASDII - Simple daily intensity index per time period
         echo
         PARAM="ECASDII"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_sdii ${INPUT_SUBSET_PREC} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_sdii ${INPUT_SUBSET_PREC} ${OUTCI_FILE}

        # 2.0.27 ECASU - Summer days index per time period
        echo
        PARAM="ECASU"
        OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
        echo cdo -O -z zip_8 eca_su ${INPUT_SUBSET_TMAX} ${OUTCI_FILE}
             cdo -O -z zip_8 eca_su ${INPUT_SUBSET_TMAX} ${OUTCI_FILE}

       # 2.0.28 ECATG10P - Cold days percent w.r.t. 10th percentile of reference period
       echo
       PARAM="ECATG10P"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_tg10p ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P010} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_tg10p ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P010} ${OUTCI_FILE}

       # 2.0.29 ECATG90P - Warm days percent w.r.t. 90th percentile of reference period
       echo
       PARAM="ECATG90P"
       OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       echo cdo -O -z zip_8 eca_tg90p ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P090} ${OUTCI_FILE}
            cdo -O -z zip_8 eca_tg90p ${INPUT_SUBSET_TAVG} ${CLIM_TAVG_P090} ${OUTCI_FILE}


       # 2.0.30 ECATN10P - Cold nights percent w.r.t. 10th percentile of reference period
       #echo
       #PARAM="ECATN10P"
       #OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
       #echo cdo -O -z zip_8 eca_tn10p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P010} ${OUTCI_FILE}
       #    cdo -O -z zip_8 eca_tn10p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P010} ${OUTCI_FILE}

        # 2.0.31 ECATN90P - Warm nights percent w.r.t. 90th percentile of reference period
        #echo
        #PARAM="ECATN90P"
        #OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
        #echo cdo -O -z zip_8 eca_tn90p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P090} ${OUTCI_FILE}
        #     cdo -O -z zip_8 eca_tn90p ${INPUT_SUBSET_TMIN} ${CLIM_TMIN_P090} ${OUTCI_FILE}

         # 2.0.32 ECATR - Tropical nights index per time period
         echo
         PARAM="ECATR"
         OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
         echo cdo -O -z zip_8 eca_tr ${INPUT_SUBSET_TMIN} ${OUTCI_FILE}
              cdo -O -z zip_8 eca_tr ${INPUT_SUBSET_TMIN} ${OUTCI_FILE}



          # 2.0.33 ECATX10P - Very cold days percent w.r.t. 10th percentile of reference period
          echo
          PARAM="ECATX10P"
          OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
          echo cdo -O -z zip_8 eca_tx10p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P010} ${OUTCI_FILE}
               cdo -O -z zip_8 eca_tx10p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P010} ${OUTCI_FILE}


           # 2.0.34 ECATX90P - Very warm days percent w.r.t. 90th percentile of reference period
           #echo
           #PARAM="ECATX90P"
           #OUTCI_FILE=${CLIPPED_OUTDIR_ROOT}/${DATASET}_ETCCDI_${PARAM}_${ENS}_${SCEN}_${CLIM_PERIOD}_${YEAR}.nc
           #echo cdo -O -z zip_8 eca_tx90p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P090} ${OUTCI_FILE}
           #     cdo -O -z zip_8 eca_tx90p ${INPUT_SUBSET_TMAX} ${CLIM_TMAX_P090} ${OUTCI_FILE}






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
