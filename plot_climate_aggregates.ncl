begin

  prefix   = "LOCA_NGP"

  root_dir = "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/" +  prefix +   "/climatology/"

  variables  = (/ "tasmin",     \
                  "tasmax", \
                  "pr"  /)

  scenarios = (/ "historical", \
                 "rcp85",      \
                 "rcp45"       /)

  do v = 0, dimsizes(variables) - 1

    variable = variables(v)

    print("XXXX "+v+ ":" +(dimsizes(variables) - 1)+ " "+ variables(v) + " XXXX")

    if (variable .eq. "pr") then
      statistic = "CDO_PERIOD_ANNUAL_MEAN"
    else
      statistic = "CDO_PERIOD_ANNUAL_MEAN"
    end if

    do s = 0, dimsizes(scenarios) - 1

      scenario = scenarios(s)
      print("//// "+s+ ":" +(dimsizes(scenarios) - 1)+" "+ scenario + " ////")

      if (scenario .eq. "historical") then
        period   = "1950-2005"
        nyr      = 2005-1950 + 1
      else
        period   = "2006-2099"
        nyr      =  2099 - 2006 + 1
      end if

      ensembles = (/ "ACCESS1-0_r1i1p1",      \
                     "ACCESS1-3_r1i1p1",      \
                     "CCSM4_r6i1p1",          \
                     "CESM1-BGC_r1i1p1",      \
                     "CESM1-CAM5_r1i1p1",     \
                     "CMCC-CMS_r1i1p1",       \
                     "CMCC-CM_r1i1p1",        \
                     "CNRM-CM5_r1i1p1",       \
                     "CSIRO-Mk3-6-0_r1i1p1",  \
                     "CanESM2_r1i1p1",        \
                     "FGOALS-g2_r1i1p1",      \
                     "GFDL-CM3_r1i1p1",       \
                     "GFDL-ESM2G_r1i1p1",     \
                     "GFDL-ESM2M_r1i1p1",     \
                     "HadGEM2-AO_r1i1p1",     \
                     "HadGEM2-CC_r1i1p1",     \
                     "HadGEM2-ES_r1i1p1",     \
                     "IPSL-CM5A-LR_r1i1p1",   \
                     "IPSL-CM5A-MR_r1i1p1",   \
                     "MIROC-ESM-CHEM_r1i1p1", \
                     "MIROC-ESM_r1i1p1",      \
                     "MIROC5_r1i1p1",         \
                     "MPI-ESM-LR_r1i1p1",     \
                     "MPI-ESM-MR_r1i1p1",     \
                     "MRI-CGCM3_r1i1p1",      \
                     "NorESM1-M_r1i1p1",      \
                     "bcc-csm1-1-m_r1i1p1"    /)

      ne = dimsizes(ensembles)

      graphics_file = "./"               +  \
                      prefix     + "_" +  \
                      variable     + "_" +  \
                      scenario     + "_" +  \
                      "climate"    + "_" +  \
                      period

      wks = gsn_open_wks("pdf", graphics_file)


      do i = 0, ne-1

        print("----------")

        filename = root_dir     +               \
                   period       + "/INTERANNUAL/" +  \
                   variable     + "/" +  \
                   prefix       + "_" +  \
                   variable     + "_" +  \
                   ensembles(i) + "_" +  \
                   scenario     + "_" +  \
                   period       + "_" +  \
                   statistic    + ".nc"

         variable_name = variable     + "_" +  \
                         ensembles(i) + "_" +  \
                         scenario


         f = addfile(filename, "r")


         plot_data            := tofloat(f->$variable_name$(0,:,:) ) * \
                                 f->$variable_name$@scale_factor -     \
                                 f->$variable_name$@add_offset

         plot_data@units       = f->$variable_name$@units
         plot_data@description = f->$variable_name$@description
         plot_data@long_name   = f->$variable_name$@long_name

         if (i .eq. 0) then

           lon = f->lon
           lat = f->lat

           nx = dimsizes(lon)
           ny = dimsizes(lat)

           combined_ensembles := new( (/ne, ny, nx /), float)

           combined_ensembles!0 = "ensembles"
           combined_ensembles!1 = "lat"
           combined_ensembles!2 = "lon"

           combined_ensembles&ensembles = ensembles
           combined_ensembles&lat       = lat
           combined_ensembles&lon       = lon
           copy_VarAtts(f->$variable_name$(0,:,:), combined_ensembles)


         end if

         plot_data!1 = "lon"
         plot_data!0 = "lat"

         plot_data&lon = lon
         plot_data&lat = lat



           combined_ensembles@description = plot_data@description
           combined_ensembles@units       = plot_data@units


         combined_ensembles(i,:,:) = (/tofloat((/ plot_data /))/)

         res                       = True     ; plot mods desired

         res@gsnMaximize           = False    ; Make plot fit the frame

         res@cnFillOn              = True     ; turn on color fill
         res@cnLinesOn             = False    ; turn of contour lines
         res@cnFillPalette         = "BlAqGrYeOrRe"
         res@cnFillMode = "RasterFill"
         res@gsnAddCyclic          = False    ; data already has cyclic point
       				                                ; this must also be set for any zoom
         res@mpMinLatF             = min(lat)      ; range to zoom in on
         res@mpMaxLatF             = max(lat)
         res@mpMinLonF             = min(lon)
         res@mpMaxLonF             = max(lon)
         res@mpOutlineBoundarySets = "USStates"

         res@tiMainString          = ensembles(i) + "_" + \
                                     scenario     + " " + \
                                     period

         res@pmTickMarkDisplayMode = "Always"; use NCL default lat/lon labels

         plot = gsn_csm_contour_map(wks, plot_data, res)

         print(" " + variable_name + " " + min(plot_data) + " " + \
                                            avg(plot_data) + " " + \
                                            max(plot_data))


      end do

      print("| | | | | | |")

      print("plotting mean")


      if (variable .eq. "pr") then
        plot2=dim_stddev_n_Wrap(combined_ensembles, 0)
      else
        plot2=dim_stddev_n_Wrap(combined_ensembles, 0)
      end if
      plot2@units = plot_data@units
      plot2@description = plot_data@description
      plot2!1 = "lon"
      plot2!0 = "lat"

      plot2&lon = lon
      plot2&lat = lat

      res@tiMainString          = "Ensemble Standard Deviation " + \
                                scenario     + " " + \
                                period

      plot = gsn_csm_contour_map(wks, plot2, res)

      print("plotting stdev")


      if (variable .eq. "pr") then
        plot2= dim_avg_n_Wrap(combined_ensembles,0)
      else
        plot2=dim_avg_n_Wrap(combined_ensembles, 0)
      end if
      plot2@units = plot_data@units
      plot2@description = plot_data@description
      plot2!1 = "lon"
      plot2!0 = "lat"

      plot2&lon = lon
      plot2&lat = lat

      res@tiMainString          = "Ensemble Mean " + \
                                  scenario     + " " + \
                                  period

        plot = gsn_csm_contour_map(wks, plot2, res)


print("plotting s/m")

      if (variable .eq. "pr") then
        plot2=(dim_stddev_n_Wrap(combined_ensembles, 0) / dim_avg_n_Wrap(combined_ensembles, 0)) * 100.
      else
        denom =  dim_avg_n_Wrap(combined_ensembles+273, 0)
        denom = where(denom.eq.0, denom@_FillValue, denom)
        plot2=(dim_stddev_n_Wrap(combined_ensembles+273, 0) / denom) * 100.
      end if
      plot2@units = plot_data@units
      plot2@description = plot_data@description
      plot2@units = "%"
      plot2!1 = "lon"
      plot2!0 = "lat"

      plot2&lon = lon
      plot2&lat = lat

      res@tiMainString = "Ensemble Stdev/Mean " + \
                         scenario         + " " + \
                         period

      plot = gsn_csm_contour_map(wks, plot2, res)


      delete(wks)
      delete(plot2)
      delete(plot_data)

      delete(combined_ensembles)

      print("///////////////")

    end do
    print("XXXXXXXXXXXXXXXXXXX")

  end do

end
