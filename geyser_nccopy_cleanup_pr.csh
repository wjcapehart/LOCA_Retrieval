#!/bin/bash
#SBATCH --job-name=LOCA_PR_CLIP_RCP45
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
#SBATCH --mem=64000
#SBATCH --account=USDM0005
#SBATCH --output=LOCA_PR_CLIP_RCP45.%J.out
#SBATCH --error=LOCA_PR_CLIP_RCP45.%J.err
#SBATCH --mail-user=William.Capehart@sdsmt.edu
#SBATCH --mail-type=ALL
#SBATCH --verbose


declare -a    PARAM=(   "pr"    )
declare -a SCENARIO=(  "rcp45"  )


### Initialize the Slurm environment
source /glade/u/apps/opt/slurm_init/init.sh



module load nco
module load ncl
module load netcdf/4.4.0



OS_NAME=`uname`
HOST_NAME=`hostname`

echo Working on ${HOST_NAME} using ${OS_NAME}



  echo Working on ${HOST_NAME} using ${OS_NAME}



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



   # CIDA THREDDS Address for both Historical and Future Scenarios

   export     FUTURE_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_future"
   export HISTORICAL_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_historical"

   # Setting Local Points to Revieved Clipped Data

   export CLIPPED_PREFIX="/glade/p/work/capehart/LOCA/SODAK_LOCA"

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
                           "MIROC5_r1i1p1"
                           "MIROC-ESM-CHEM_r1i1p1"
                           "MIROC-ESM_r1i1p1"
                           "MPI-ESM-LR_r1i1p1"
                           "MPI-ESM-MR_r1i1p1"
                           "MRI-CGCM3_r1i1p1"
                           "NorESM1-M_r1i1p1"
                           "bcc-csm1-1-m_r1i1p1" )

   declare -a BADGLOBALS=( "_ChunkSizes"
                           "scale_factor"
                           "_FillValue"
                           "missing_value"
                           "long_name"
                           "units"
                           "history"
                           ""
                           ""
                           ""
                           )

   # setting the available variables


   ######## Time climate_period_bounds
   #   dq ='"'
   #   n_cats = round(( (2006d) - (1950d) ) * 2.0)
   #   endi   = round( 34332d *  (dindgen(n_cats)+1d)/n_cats )
   #   endi   = round( 20453d *  (dindgen(n_cats)+1d)/n_cats )
   #   starti = [0, endi(0:n_cats-2)+1]
   #   for i = 0, n_cats-1 do print, dq,starti[i],endi[i],dq, format=('(A1,"[",I5.5,":1:",I5.5,"]",A1)')
   #   for i = 0, n_cats-1 do print, dq,i+1,dq, format=('(A1,"__T",I3.3,A1)')
   #   for i = 0, n_cats-1 do print, (i+1), format=('(I3)')

    declare -a PASSES=(  "1"  )


   for PASS in  "${PASSES[@]}"
   do

      echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      echo
      for SCEN in "${SCENARIO[@]}"
      do

         if [ ${SCEN} == "historical" ]
         then
            export ORIGINAL_URL=${HISTORICAL_ORIGINAL_URL}
            declare -a TIMECLIP=(   "[00000:1:00183]"
                                    "[00184:1:00365]"
                                    "[00366:1:00548]"
                                    "[00549:1:00730]"
                                    "[00731:1:00913]"
                                    "[00914:1:01096]"
                                    "[01097:1:01278]"
                                    "[01279:1:01461]"
                                    "[01462:1:01644]"
                                    "[01645:1:01826]"
                                    "[01827:1:02009]"
                                    "[02010:1:02191]"
                                    "[02192:1:02374]"
                                    "[02375:1:02557]"
                                    "[02558:1:02739]"
                                    "[02740:1:02922]"
                                    "[02923:1:03104]"
                                    "[03105:1:03287]"
                                    "[03288:1:03470]"
                                    "[03471:1:03652]"
                                    "[03653:1:03835]"
                                    "[03836:1:04018]"
                                    "[04019:1:04200]"
                                    "[04201:1:04383]"
                                    "[04384:1:04565]"
                                    "[04566:1:04748]"
                                    "[04749:1:04931]"
                                    "[04932:1:05113]"
                                    "[05114:1:05296]"
                                    "[05297:1:05478]"
                                    "[05479:1:05661]"
                                    "[05662:1:05844]"
                                    "[05845:1:06026]"
                                    "[06027:1:06209]"
                                    "[06210:1:06392]"
                                    "[06393:1:06574]"
                                    "[06575:1:06757]"
                                    "[06758:1:06939]"
                                    "[06940:1:07122]"
                                    "[07123:1:07305]"
                                    "[07306:1:07487]"
                                    "[07488:1:07670]"
                                    "[07671:1:07852]"
                                    "[07853:1:08035]"
                                    "[08036:1:08218]"
                                    "[08219:1:08400]"
                                    "[08401:1:08583]"
                                    "[08584:1:08766]"
                                    "[08767:1:08948]"
                                    "[08949:1:09131]"
                                    "[09132:1:09313]"
                                    "[09314:1:09496]"
                                    "[09497:1:09679]"
                                    "[09680:1:09861]"
                                    "[09862:1:10044]"
                                    "[10045:1:10227]"
                                    "[10228:1:10409]"
                                    "[10410:1:10592]"
                                    "[10593:1:10774]"
                                    "[10775:1:10957]"
                                    "[10958:1:11140]"
                                    "[11141:1:11322]"
                                    "[11323:1:11505]"
                                    "[11506:1:11687]"
                                    "[11688:1:11870]"
                                    "[11871:1:12053]"
                                    "[12054:1:12235]"
                                    "[12236:1:12418]"
                                    "[12419:1:12601]"
                                    "[12602:1:12783]"
                                    "[12784:1:12966]"
                                    "[12967:1:13148]"
                                    "[13149:1:13331]"
                                    "[13332:1:13514]"
                                    "[13515:1:13696]"
                                    "[13697:1:13879]"
                                    "[13880:1:14061]"
                                    "[14062:1:14244]"
                                    "[14245:1:14427]"
                                    "[14428:1:14609]"
                                    "[14610:1:14792]"
                                    "[14793:1:14975]"
                                    "[14976:1:15157]"
                                    "[15158:1:15340]"
                                    "[15341:1:15522]"
                                    "[15523:1:15705]"
                                    "[15706:1:15888]"
                                    "[15889:1:16070]"
                                    "[16071:1:16253]"
                                    "[16254:1:16435]"
                                    "[16436:1:16618]"
                                    "[16619:1:16801]"
                                    "[16802:1:16983]"
                                    "[16984:1:17166]"
                                    "[17167:1:17349]"
                                    "[17350:1:17531]"
                                    "[17532:1:17714]"
                                    "[17715:1:17896]"
                                    "[17897:1:18079]"
                                    "[18080:1:18262]"
                                    "[18263:1:18444]"
                                    "[18445:1:18627]"
                                    "[18628:1:18809]"
                                    "[18810:1:18992]"
                                    "[18993:1:19175]"
                                    "[19176:1:19357]"
                                    "[19358:1:19540]"
                                    "[19541:1:19723]"
                                    "[19724:1:19905]"
                                    "[19906:1:20088]"
                                    "[20089:1:20270]"
                                    "[20271:1:20453]" )


         else
            export ORIGINAL_URL=${FUTURE_ORIGINAL_URL}
            declare -a TIMECLIP=(   "[00000:1:00307]"
                                    "[00308:1:00613]"
                                    "[00614:1:00920]"
                                    "[00921:1:01226]"
                                    "[01227:1:01533]"
                                    "[01534:1:01839]"
                                    "[01840:1:02146]"
                                    "[02147:1:02452]"
                                    "[02453:1:02759]"
                                    "[02760:1:03065]"
                                    "[03066:1:03372]"
                                    "[03373:1:03678]"
                                    "[03679:1:03985]"
                                    "[03986:1:04292]"
                                    "[04293:1:04598]"
                                    "[04599:1:04905]"
                                    "[04906:1:05211]"
                                    "[05212:1:05518]"
                                    "[05519:1:05824]"
                                    "[05825:1:06131]"
                                    "[06132:1:06437]"
                                    "[06438:1:06744]"
                                    "[06745:1:07050]"
                                    "[07051:1:07357]"
                                    "[07358:1:07663]"
                                    "[07664:1:07970]"
                                    "[07971:1:08276]"
                                    "[08277:1:08583]"
                                    "[08584:1:08890]"
                                    "[08891:1:09196]"
                                    "[09197:1:09503]"
                                    "[09504:1:09809]"
                                    "[09810:1:10116]"
                                    "[10117:1:10422]"
                                    "[10423:1:10729]"
                                    "[10730:1:11035]"
                                    "[11036:1:11342]"
                                    "[11343:1:11648]"
                                    "[11649:1:11955]"
                                    "[11956:1:12261]"
                                    "[12262:1:12568]"
                                    "[12569:1:12875]"
                                    "[12876:1:13181]"
                                    "[13182:1:13488]"
                                    "[13489:1:13794]"
                                    "[13795:1:14101]"
                                    "[14102:1:14407]"
                                    "[14408:1:14714]"
                                    "[14715:1:15020]"
                                    "[15021:1:15327]"
                                    "[15328:1:15633]"
                                    "[15634:1:15940]"
                                    "[15941:1:16246]"
                                    "[16247:1:16553]"
                                    "[16554:1:16859]"
                                    "[16860:1:17166]"
                                    "[17167:1:17473]"
                                    "[17474:1:17779]"
                                    "[17780:1:18086]"
                                    "[18087:1:18392]"
                                    "[18393:1:18699]"
                                    "[18700:1:19005]"
                                    "[19006:1:19312]"
                                    "[19313:1:19618]"
                                    "[19619:1:19925]"
                                    "[19926:1:20231]"
                                    "[20232:1:20538]"
                                    "[20539:1:20844]"
                                    "[20845:1:21151]"
                                    "[21152:1:21458]"
                                    "[21459:1:21764]"
                                    "[21765:1:22071]"
                                    "[22072:1:22377]"
                                    "[22378:1:22684]"
                                    "[22685:1:22990]"
                                    "[22991:1:23297]"
                                    "[23298:1:23603]"
                                    "[23604:1:23910]"
                                    "[23911:1:24216]"
                                    "[24217:1:24523]"
                                    "[24524:1:24829]"
                                    "[24830:1:25136]"
                                    "[25137:1:25442]"
                                    "[25443:1:25749]"
                                    "[25750:1:26056]"
                                    "[26057:1:26362]"
                                    "[26363:1:26669]"
                                    "[26670:1:26975]"
                                    "[26976:1:27282]"
                                    "[27283:1:27588]"
                                    "[27589:1:27895]"
                                    "[27896:1:28201]"
                                    "[28202:1:28508]"
                                    "[28509:1:28814]"
                                    "[28815:1:29121]"
                                    "[29122:1:29427]"
                                    "[29428:1:29734]"
                                    "[29735:1:30041]"
                                    "[30042:1:30347]"
                                    "[30348:1:30654]"
                                    "[30655:1:30960]"
                                    "[30961:1:31267]"
                                    "[31268:1:31573]"
                                    "[31574:1:31880]"
                                    "[31881:1:32186]"
                                    "[32187:1:32493]"
                                    "[32494:1:32799]"
                                    "[32800:1:33106]"
                                    "[33107:1:33412]"
                                    "[33413:1:33719]"
                                    "[33720:1:34025]"
                                    "[34026:1:34332]" )
         fi


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

               #   ncl -Q -n file_name='"'${FILENAME}'"' variable_name='"'${VARNAME}'"'  vartype='"'${PAR}'"' macaloca_scan_and_check.ncl

                  if [ ! -f ${FILENAME} ]; then
                     echo missing ${FILENAME}
                     echo

                     export TYX_COORDS=${TIMECLIP[${TIND}]}${LATCLIP}${LONCLIP}

                     export ALWAYS_GET_US=lon${LONCLIP},lon_bnds${LONCLIP}[0:1:1],lat${LATCLIP},lat_bnds${LATCLIP}[0:1:1],time${TIMECLIP[${TIND}]},time_bnds${TIMECLIP[${TIND}]}[0:1:1]
                     #  export ALWAYS_GET_US=lon${LONCLIP},lat${LATCLIP},time${TIMECLIP[${TIND}]}


                     echo  nohup nccopy -7 -d 8 ${ORIGINAL_URL}?${ALWAYS_GET_US},${PAR}_${ENS}_${SCEN}${TYX_COORDS} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                           nohup nccopy -7 -d 8 ${ORIGINAL_URL}?${ALWAYS_GET_US},${PAR}_${ENS}_${SCEN}${TYX_COORDS} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                     echo

                     echo nohup ncks -h --mk_rec_dmn time  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          nohup ncks -h --mk_rec_dmn time  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo

                     echo  rm -frv   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                           rm -frv   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                     echo

                     echo  nohup ncpdq -h -U   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           nohup ncpdq -h -U   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           mv -fv                           temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo

                     echo nohup ncap2 --history --script 'where(lon>180) lon=lon-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          nohup ncap2 --history --script 'where(lon>180) lon=lon-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo

                     echo nohup ncap2 --history --script 'where(lon_bnds>180) lon_bnds=lon_bnds-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          nohup ncap2 --history --script 'where(lon_bnds>180) lon_bnds=lon_bnds-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo


                     UNITS=`ncdump -h ${FILENAME} | grep ${VARNAME}:units | sed '/.*\"\(.*\)\".*/ s//\1/g' `
                     echo
                     echo ${VARNAME} ${UNITS}
                     echo

                     if [ "${UNITS}" == "C" ];
                     then
                        echo needs to change the units name from C to degC
                        ncatted -h -O -a units,${VARNAME},m,c,"degC" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                     fi


                     if [ "${UNITS}" == "mm" ];
                     then
                        echo needs to change the units name from mm to kg m-2
                        ncatted -h -O -a units,${VARNAME},m,c,"kg m-2" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     fi



                     if [ "${UNITS}" == "K" ];
                     then
                        echo needs to change the units name from K to degC
                        ncatted -h -O -a units,${VARNAME},m,c,"degC" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        echo nohup ncap2 --history --script 'where(temporary != 0) temporary=temporary-273.15' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             nohup ncap2 --history --script 'where(temporary != 0) temporary=temporary-273.15' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                     fi

                     if [ "${UNITS}" == "kg m-2 s-1" ];
                     then
                        echo needs to change the units name from kg m-2 s-1 to kg m-2
                        ncatted -h -O -a units,${VARNAME},m,c,"kg m-2" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        ncrename -h -v ${VARNAME},temporary ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                        echo nohup ncap2 --history --script 'temporary=temporary*86400.' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             nohup ncap2 --history --script 'temporary=temporary*86400.' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                             mv -fv                            temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncrename -h -v temporary,${VARNAME} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     fi

                     if [ "${PAR}" ==  "pr" ];
                     then
                        echo Editing Attributes for ${PAR}
                        ncatted -h -O -a long_name,${VARNAME},m,c,"Total Daily Precipitation" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a description,${VARNAME},c,c,"Total Daily Precipitation" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a standard_name,${VARNAME},c,c,"precipitation_amount" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a cell_methods,${VARNAME},c,c,"time: sum" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     fi


                     if [ "${PAR}" ==  "tasmax" ];
                     then
                        echo Editing Attributes for ${PAR}
                        ncatted -h -O -a long_name,${VARNAME},m,c,"Maximum Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a description,${VARNAME},c,c,"Maximum Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a standard_name,${VARNAME},c,c,"air_temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a cell_methods,${VARNAME},c,c,"time: maximum" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     fi

                     if [ "${PAR}" ==  "tasmin" ];
                     then
                        echo Editing Attributes for ${PAR}
                        ncatted -h -O -a long_name,${VARNAME},m,c,"Minimium Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a description,${VARNAME},c,c,"Minimium Daily Temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a standard_name,${VARNAME},c,c,"air_temperature" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                        ncatted -h -O -a cell_methods,${VARNAME},c,c,"time: minimum" ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     fi
                     ncatted -h -O -a history,,d,, ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc



                 fi


               done
               echo
               echo --------------------------------------
               echo
            done
         done
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo
      done

      echo $PASS COMPLETE
   done

   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   echo

   for SCEN in "${SCENARIO[@]}"
   do

      for PAR in "${PARAM[@]}"
      do
         for ENS in "${ENSEMBLE[@]}"
         do




            echo nohup ncrcat -h ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}.nc
                 nohup ncrcat -h ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}.nc


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
