
#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`

TEST_STRING=`nccopy https://cida.usgs.gov/thredds/dodsC/loca_future?lat[0:1:489] deleteme.nc`

echo ****************
echo ** Test String ||$TEST_STRING|| **
echo *****************

if [[ "$OS_NAME" == 'Darwin' ]];
then
   source ~wjc/.bash_profile
fi


if [ -z "$TEST_STRING" ];
then
  rm -frv deleteme.nc
  echo Working on ${HOST_NAME} using ${OS_NAME}

   declare -a    PARAM=(  "pr"         "tasmin" "tasmax" )
   declare -a SCENARIO=(  "historical" "rcp85"  "rcp45"  )

#
#lon[79]
#-106.09375, -106.03125, -105.96875, -105.90625, -105.84375, -105.78125, -105.71875, -105.65625, -105.59375, -105.53125, -105.46875, -105.40625, -105.34375, -105.28125, -105.21875, -105.15625, -105.09375, -105.03125, -104.96875, -104.90625, -104.84375, -104.78125, -104.71875, -104.65625, -104.59375, -104.53125, -104.46875, -104.40625, -104.34375, -104.28125, -104.21875, -104.15625, -104.09375, -104.03125, -103.96875, -103.90625, -103.84375, -103.78125, -103.71875, -103.65625, -103.59375, -103.53125, -103.46875, -103.40625, -103.34375, -103.28125, -103.21875, -103.15625, -103.09375, -103.03125, -102.96875, -102.90625, -102.84375, -102.78125, -102.71875, -102.65625, -102.59375, -102.53125, -102.46875, -102.40625, -102.34375, -102.28125, -102.21875, -102.15625, -102.09375, -102.03125, -101.96875, -101.90625, -101.84375, -101.78125, -101.71875, -101.65625, -101.59375, -101.53125, -101.46875, -101.40625, -101.34375, -101.28125, -101.21875
#
#lat[42]
#42.65625, 42.71875, 42.78125, 42.84375, 42.90625, 42.96875, 43.03125, 43.09375, 43.15625, 43.21875, 43.28125, 43.34375, 43.40625, 43.46875, 43.53125, 43.59375, 43.65625, 43.71875, 43.78125, 43.84375, 43.90625, 43.96875, 44.03125, 44.09375, 44.15625, 44.21875, 44.28125, 44.34375, 44.40625, 44.46875, 44.53125, 44.59375, 44.65625, 44.71875, 44.78125, 44.84375, 44.90625, 44.96875, 45.03125, 45.09375, 45.15625, 45.21875
#
*/




   ### NCL COMMANDS TO FETCH GRIDCELLS BY LAT/LON
   # f = addfile("http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/Northern_Great_Plains_Original_Subset/historical/NGP_LOCA___ACCESS1-0___historical.nc","r")
   #
   # lon = f->lon
   # lat = f->lat
   #
     min_lat =  42.65625; degrees north
     max_lat =  45.21875; degrees north
      min_lon = -106.09375; degrees east
      max_lon = -101.21875 ; degrees east
   
     deg_target = lon({max_lon})
     index_xx = ind(lon .eq. lon({max_lon}))
     index_xn = ind(lon .eq. lon({min_lon}))
     index_yx = ind(lat .eq. lat({max_lat}))
     index_yn = ind(lat .eq. lat({min_lat}))
     print("LONCLIP=  [" +  (index_xn) + ":1:" + (index_xx) + "] [" +  (lon(index_xn)) + ":1:" + (lon(index_xx)) + "]")
     print("LATCLIP=  [" +  (index_yn) + ":1:" + (index_yx) + "] [" +  lat(index_yn) + ":1:" + lat(index_yx) + "]")
   #
   #
   ##################



   ### NGP
   export LONCLIP="[187:1:636]"  # [-114.28125 : 1 : -86.28125]
   export LATCLIP="[169:1:470]"  # [  33.96875 : 1 :  52.71875]

   ### CRB
   #LONCLIP=  [131:1:209] [-106.09375:1:-101.21875]
   #LATCLIP=  [139:1:180] [42.65625:1:45.21875]

   export NCCOPY="nccopy"

   # CIDA THREDDS Address for both Historical and Future Scenarios

   export     FUTURE_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_future"
   export HISTORICAL_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/loca_historical"

   # Setting Local Points to Revieved Clipped Data

   export CLIPPED_WORKDIR="/projects/ECEP/LOCA_MACA_Ensembles/LOCA/LOCA_OUTPUT/grid_ngp"
   mkdir -vp ${CLIPPED_WORKDIR}

   export CLIPPED_PREFIX=${CLIPPED_WORKDIR}"/NGP_LOCA"

