
begin

   print(" ")
   print("::::  REPORT " + file_name)

   if (fileexists(file_name) .and. isfilepresent(file_name))

      f = addfile(file_name,"r")

      array = f->$variable_name$
      time  = f->time

      print("....                       Range Values : " + min(array) + " " + max(array) + " " + array@units)

        if (vartype .eq. "pr") then
          sumbytime := dim_sum_n_Wrap(array, (/ 1, 2 /) )
          sumbytime := runave(sumbytime, 8, 1)
        else
          sumbytime = dim_sum_n_Wrap(array, (/ 1, 2 /) )
        end if

      number_of_missing_time_slots = sum(time( 1 : (dimsizes(time)-1) ) -  time( 0 : (dimsizes(time)-2 ) ) - 1)

      number_of_missing_values = num(ismissing(array))

      number_of_zero_gridcells = num(sumbytime .eq. 0)

      print("....     Total Number of Missing Values : " + number_of_missing_values)
      print(".... Total Number of Missing Time Slots : " + number_of_missing_time_slots)
      print("....  Total Number of Zeroed Time Slots : " + number_of_zero_gridcells + " | " + min(sumbytime)  + " | " + typeof(array) )

   else

      print(".... "    + file_name + " is missing or damaged")
      system("rm  " + file_name)

      number_of_missing_values     = -1
      number_of_missing_time_slots = -1
      number_of_zero_gridcells     = -1

   end if

   if ( (number_of_missing_values .gt. 0) .or. (number_of_missing_time_slots .gt. 0) .or. (number_of_zero_gridcells .gt. 0) ) then
      system("rm  "+file_name)

      print(":::: Redo-ing " + file_name)

   end if
   print(" ")

end
