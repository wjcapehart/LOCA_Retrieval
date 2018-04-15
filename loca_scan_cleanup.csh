#!/bin/bash


unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
   export NCARG_ROOT=/usr/local/ncl-6.4.0
   export NCARG_RANGS=/usr/local/rangs
   export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/Cellar/gcc/7.3.0/lib/gcc/7/:$DYLD_FALLBACK_LIBRARY_PATH
   export PATH=$NCARG_ROOT/bin:"$PATH"
fi

### Environment for Local use on Kyrill file syetem.

export CASE="HISTORICAL"
# export CASE="FUTURE"

# South Dakota with full Cheyenne Basin and Big Sioux Basin

export SODAK_CHEY_CLIP=" -d lat,42.24,46.299 -d lon,253.78,264.59 "
export SODAK_CHEY_CLIP=" -d lat,42.24,46.299 -d lon,-106.220,-95.4100 "

### NCL COMMANDS TO FETCH GRIDCELLS BY LAT/LON
#
#   deg_target = lat({46.299 })
#   index = ind(lat .eq. deg_target)
#   print(index + " " +  lat(index))
#
#
##################

export LONCLIP="[316:1:489]"
export LATCLIP="[302:1:366]"


export NCCOPY="nccopy"

# CIDA THREDDS Address for both Historical and Future Scenarios

export     FUTURE_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_future"
export HISTORICAL_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_historical"

# Setting Local Points to Revieved Clipped Data

export CLIPPED_PREFIX="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_OUTPUT/grid/SODAK_LOCA"

# setting the CIDA THREDDS Address



   declare -a TIND_VALS=(    0
                             1
                             2
                             3
                             4
                             5
                             6
                             7
                             8
                             9
                            10
                            11
                            12
                            13
                            14
                            15
                            16
                            17
                            18
                            19
                            20
                            21
                            22
                            23
                            24
                            25
                            26
                            27
                            28
                            29
                            30
                            31
                            32
                            33
                            34
                            35
                            36
                            37
                            38
                            39
                            40
                            41
                            42
                            43
                            44
                            45
                            46
                            47
                            48
                            49
                            50
                            51
                            52
                            53
                            54
                            55
                            56
                            57
                            58
                            59
                            60
                            61
                            62
                            63
                            64
                            65
                            66
                            67
                            68
                            69
                            70
                            71
                            72
                            73
                            74
                            75
                            76
                            77
                            78
                            79
                            80
                            81
                            82
                            83
                            84
                            85
                            86
                            87
                            88
                            89
                            90
                            91
                            92
                            93
                            94
                            95
                            96
                            97
                            98
                            99
                           100
                           101
                           102
                           103
                           104
                           105
                           106
                           107
                           108
                           109
                           110
                           111 )


declare -a TIMECLIPCODE=(  "__T001"
                           "__T002"
                           "__T003"
                           "__T004"
                           "__T005"
                           "__T006"
                           "__T007"
                           "__T008"
                           "__T009"
                           "__T010"
                           "__T011"
                           "__T012"
                           "__T013"
                           "__T014"
                           "__T015"
                           "__T016"
                           "__T017"
                           "__T018"
                           "__T019"
                           "__T020"
                           "__T021"
                           "__T022"
                           "__T023"
                           "__T024"
                           "__T025"
                           "__T026"
                           "__T027"
                           "__T028"
                           "__T029"
                           "__T030"
                           "__T031"
                           "__T032"
                           "__T033"
                           "__T034"
                           "__T035"
                           "__T036"
                           "__T037"
                           "__T038"
                           "__T039"
                           "__T040"
                           "__T041"
                           "__T042"
                           "__T043"
                           "__T044"
                           "__T045"
                           "__T046"
                           "__T047"
                           "__T048"
                           "__T049"
                           "__T050"
                           "__T051"
                           "__T052"
                           "__T053"
                           "__T054"
                           "__T055"
                           "__T056"
                           "__T057"
                           "__T058"
                           "__T059"
                           "__T060"
                           "__T061"
                           "__T062"
                           "__T063"
                           "__T064"
                           "__T065"
                           "__T066"
                           "__T067"
                           "__T068"
                           "__T069"
                           "__T070"
                           "__T071"
                           "__T072"
                           "__T073"
                           "__T074"
                           "__T075"
                           "__T076"
                           "__T077"
                           "__T078"
                           "__T079"
                           "__T080"
                           "__T081"
                           "__T082"
                           "__T083"
                           "__T084"
                           "__T085"
                           "__T086"
                           "__T087"
                           "__T088"
                           "__T089"
                           "__T090"
                           "__T091"
                           "__T092"
                           "__T093"
                           "__T094"
                           "__T095"
                           "__T096"
                           "__T097"
                           "__T098"
                           "__T099"
                           "__T100"
                           "__T101"
                           "__T102"
                           "__T103"
                           "__T104"
                           "__T105"
                           "__T106"
                           "__T107"
                           "__T108"
                           "__T109"
                           "__T110"
                           "__T111"
                           "__T112" )

# setting the Setting the Available RCP Scenarios

if [ ${CASE} == "FUTURE" ]
then
   declare -a SCENARIO=(  "rcp85"
                          "rcp45" )
else
   declare -a SCENARIO=(  "historical" )
fi



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

declare -a    PARAM=(
                       "pr"
                       "tasmax"
                       "tasmin"
                       "huss"
                       "rhsmax"
                       "rhsmin"
                       "rsds"
                       "uas"
                       "vas"
                       )


declare -a    PARAM=(  "pr"
                       "tasmax"
                       "tasmin"
                     )


declare -a SCENARIO=(  "rcp85" "rcp45"  )


######## Time climate_period_bounds
#   dq ='"'
#   n_cats = round(( (2006d) - (1950d) ) * 2.0)
#   endi   = round( 34697d *  (dindgen(n_cats)+1d)/n_cats )
#   endi   = round( 20453d *  (dindgen(n_cats)+1d)/n_cats )
#   starti = [0, endi(0:n_cats-2)+1]
#   for i = 0, n_cats-1 do print, dq,starti[i],endi[i],dq, format=('(A1,"[",I5.5,":1:",I5.5,"]",A1)')
#   for i = 0, n_cats-1 do print, dq,i+1,dq, format=('(A1,"__T",I3.3,A1)')
#   for i = 0, n_cats-1 do print, (i+1), format=('(I3)')

 declare -a PASSES=(  "1"
                      "2"  )



 for PASS in  "${PASSES[@]}"
 do

    echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    echo
    for SCEN in "${SCENARIO[@]}"
    do

       for PAR in "${PARAM[@]}"
       do

          for ENS in "${ENSEMBLE[@]}"
          do
             echo --------------------------------------
             echo
             echo Processing ${PAR}_${ENS}_${SCEN}
             echo

             for TIND in "${TIND_VALS[@]}"
             do

                export FILENAME=${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                export FILENAME=${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                export  VARNAME=${PAR}_${ENS}_${SCEN}

                ncl -Q -n file_name='"'${FILENAME}'"' variable_name='"'${VARNAME}'"' macaloca_scan_and_check.ncl

             done
             echo
             echo --------------------------------------
             echo
          done
       done
       echo ======================================
       echo ======================================
       echo ======================================
       echo
    done

    echo $PASS COMPLETE
 done

echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
