
<%
   # Get all state variables.
   state_variables = [variable for variable in variables if variable.get("state")]
%>

!> Writes restart data to an already opened NetCDF dataset.
!! Note: currently only works for one-dimensional variables.
!! Note: for some variables the standard_name attribute is a custom standard name,
!! because there is no corresponding standard name in the CF conventions for those variables.
subroutine snc_write_restart_filepointer(irstfile, timestamp)
   implicit none

   integer,          intent(in) :: irstfile
   double precision, intent(in) :: timestamp

   integer :: ierr

   ! Integers to store nc id for each dimension.
   integer :: id_dim_timestamp
%for variable in state_variables:
   integer :: id_dim_${variable["name"]}
%endfor

   ! Integers to store nc id for each variable.
   integer :: id_timestamp
%for variable in state_variables:
   integer :: id_${variable["name"]}
%endfor

   ! --- Write metadata ---

   call snc_addglobalatts(irstfile)
   ! Override Conventions attribute to indicate that this is a 3Di subgrid state file.
   ierr = nf90_put_att(irstfile, nf90_global, 'Conventions', '3Di_subgrid_state_file-0.1')

   ! When no internal cells in model: write nothing. NOTE: nodtot>0 and linall==0 IS allowed.
   if (nodtot <= 0) then
      return
   end if

   ! Create dimensions.
   ierr = nf90_def_dim(irstfile, 'time', 1, id_dim_timestamp)
%for variable in state_variables:
   if (allocated(${variable["name"]})) then
      ierr = nf90_def_dim(irstfile, '${variable["name"]}_dimension', size(${variable["name"]}(${variable["slice"]})), id_dim_${variable["name"]})
   end if
%endfor

   ! Create variables.
   ierr = nf90_def_var(irstfile, 'time', nf90_double, (/ id_dim_timestamp /), id_timestamp)
   ierr = nf90_put_att(irstfile, id_timestamp, 'standard_name', 'time')
   ierr = nf90_put_att(irstfile, id_timestamp, 'long_name'    , 'valid time of state')
   ierr = nf90_put_att(irstfile, id_timestamp, 'units'        , 'seconds since '//RefDate(1:4)//'-'//RefDate(6:7)//'-'//RefDate(9:10)//' 00:00:00')
%for variable in state_variables:
   if (allocated(${variable["name"]})) then
      ierr = nf90_def_var(irstfile, '${variable["name"]}', nf90_${variable["type"]}, (/ id_dim_${variable["name"]} /), id_${variable["name"]})
      ierr = nf90_put_att(irstfile, id_${variable["name"]}, 'standard_name', '${variable["standard_name"]}')
      ierr = nf90_put_att(irstfile, id_${variable["name"]}, 'long_name'    , '${variable["description"]}')
      ierr = nf90_put_att(irstfile, id_${variable["name"]}, 'units'        , '${variable["unit"]}')
      ierr = nf90_put_att(irstfile, id_${variable["name"]}, '_FillValue'   , dmiss)
   end if
%endfor

   ierr = nf90_enddef(irstfile)

   ! --- Write data ---

   ierr = nf90_put_var(irstfile, id_timestamp, (/ timestamp /))
%for variable in state_variables:
   if (allocated(${variable["name"]})) then
      ierr = nf90_put_var(irstfile, id_${variable["name"]}, ${variable["name"]}(${variable["slice"]}))
   end if
%endfor

end subroutine snc_write_restart_filepointer


!> Reads restart data from an already opened NetCDF dataset.
!! Note: currently only works for one-dimensional variables.
subroutine snc_read_restart_filepointer(irstfile, filename, model_start_time, success)
   implicit none

   integer,          intent(in)  :: irstfile         !< Filepointer to restart netcdf file.
   character(len=*), intent(in)  :: filename         !< Filename of restart file (only used for log messages).
   double precision, intent(in)  :: model_start_time !< StartTime of the model from the mdu file (in seconds since midnight before RefDate).
   logical,          intent(out) :: success

   integer, dimension(10) :: dim_ids
   integer                :: dim_count, dim_length
   character(len=100)     :: units
   integer                :: iunit, iyear, imonth, iday, ihour, imin, isec
   double precision       :: timestamp_from_file
!   double precision       :: reference_time_from_file
   double precision       :: t1_from_file
   integer :: ierr

   ! Integers to store nc id for each variable.
   integer :: id_timestamp
%for variable in state_variables:
   integer :: id_${variable["name"]}
%endfor

   success = .true.


   ! --- Validate restart file ---

   ! Get variable time.
   ierr = nf90_inq_varid(irstfile, 'time', id_timestamp)
   if (ierr /= nf90_noerr) then
      call mess(LEVEL_ERROR, 'Variable time not present in restart file '''//trim(filename)//'''.')
      success = .false.
      return
   end if
   ! Read time.
   ierr = nf90_inquire_variable(irstfile, id_timestamp, ndims=dim_count)
   ierr = nf90_inquire_variable(irstfile, id_timestamp, dimids=dim_ids(1:dim_count))
   ierr = nf90_inquire_dimension(irstfile, dim_ids(1), len=dim_length)
   if (dim_length /= 1) then
      call mess(LEVEL_ERROR, 'Variable time contains multiple times in restart file '''//trim(filename)//'''.')
      success = .false.
      return
   end if
   ierr = nf90_get_var(irstfile, id_timestamp, timestamp_from_file)
   ierr = nf90_get_att(irstfile, id_timestamp, 'units', units)
   if (ierr /= nf90_noerr) then
      call mess(LEVEL_ERROR, 'Could not read ''units'' attribute for variable time in restart file '''//trim(filename)//'''.')
      success = .false.
      return
   end if
   !TODO this code assumes that the reference date in the netcdf file equals the reference date in the mdu file
!   ierr = parse_ud_timeunit(trim(units), iunit, iyear, imonth, iday, ihour, imin, isec)
!   t1_from_file = timestamp_from_file*dble(iunit)
   t1_from_file = timestamp_from_file
   ! Check time.
   if (t1_from_file < model_start_time) then
      call mess(LEVEL_ERROR, 'Time in restart file is before the startTime of the model that is specified in the mdu file.')
      success = .false.
      return
   end if

%for variable in state_variables:
   if (allocated(${variable["name"]})) then
      ! Get variable ${variable["name"]}.
      ierr = nf90_inq_varid(irstfile, '${variable["name"]}', id_${variable["name"]})
      if (ierr /= nf90_noerr) then
         call mess(LEVEL_ERROR, 'State variable ${variable["name"]} not present in restart file '''//trim(filename)//'''.')
         success = .false.
         return
      end if
      ! Check dimensions.
      ierr = nf90_inquire_variable(irstfile, id_${variable["name"]}, ndims=dim_count)
      ierr = nf90_inquire_variable(irstfile, id_${variable["name"]}, dimids=dim_ids(1:dim_count))
      ierr = nf90_inquire_dimension(irstfile, dim_ids(1), len=dim_length)
      if (dim_length /= size(${variable["name"]}(${variable["slice"]}))) then
         call mess(LEVEL_ERROR, 'Dimensions in restart file not equal to current model dimensions for variable ${variable["name"]} in restart file ''' &
               //trim(filename)//'''. Please check if the number of nodes/links in the restart file equals the number of nodes/links in the current model.')
         success = .false.
         return
      end if
   end if
%endfor

   ! --- Read data ---

   t1 = t1_from_file
   !TODO read and use _FillValue. AK
%for variable in state_variables:
   if (allocated(${variable["name"]})) then
      ierr = nf90_get_var(irstfile, id_${variable["name"]}, ${variable["name"]}(${variable["slice"]}))
   end if
%endfor

end subroutine snc_read_restart_filepointer
