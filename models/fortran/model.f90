module demo_model
  use iso_c_binding

  use iso_c_utils
  use logging

  implicit none

  ! This is assumed.....
  integer(c_int), parameter :: MAXDIMS = 6

  double precision, target :: t
  double precision, target :: t_end
  double precision, target :: t_start

  double precision, target :: arr1(3)
  integer, target :: arr2(2,3)
  logical(c_bool), target :: arr3(2,2,3)
contains



  integer(c_int) function finalize() result(ierr) bind(C, name="finalize")
    !DEC$ ATTRIBUTES DLLEXPORT::finalize
    ierr = 0
    call log(LEVEL_INFO, 'Finalize')
  end function finalize


  integer(c_int) function initialize(c_configfile) result(ierr) bind(C, name="initialize")
    !DEC$ ATTRIBUTES DLLEXPORT::initialize

    implicit none

    ! Variables
    character(kind=c_char), intent(in) :: c_configfile(*)
    character(len=strlen(c_configfile)) :: configfile

    ! Convert c string to fortran string
    ierr = 0
    t = 0.0d0
    t_end = 10.0d0
    configfile = char_array_to_string(c_configfile)

    write(msgbuf,*) 'Initializing with ', configfile
    call log(LEVEL_INFO, trim(msgbuf))

    arr1 = (/3,  2, 1/)
  end function initialize


  !> Performs a single timestep with the current model.
  integer(c_int) function update(dt) result(ierr) bind(C,name="update")
    !DEC$ ATTRIBUTES DLLEXPORT::update

    !< Custom timestep size, use -1 to use model default.
    real(c_double), value, intent(in) :: dt


    ierr = 0
    write(msgbuf,*) 'Updating with dt: ', dt
    call log(LEVEL_DEBUG, trim(msgbuf))
    if (dt .eq. -1) then
       t = t + 1.0d0
    else
       t = t + dt
    end if

  end function update


  ! Void function is a subroutine
  subroutine get_var_type(c_var_name, c_type_name)  bind(C, name="get_var_type")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var_type

    character(kind=c_char), intent(in) :: c_var_name(*)
    character(kind=c_char), intent(out) :: c_type_name(MAXSTRINGLEN)

    character(len=strlen(c_var_name)) :: var_name
    character(len=MAXSTRINGLEN) :: type_name

    var_name = char_array_to_string(c_var_name)

    select case(var_name)
    case('arr1')
       type_name = 'double'
    case('arr2')
       type_name = 'int'
    case('arr3')
       type_name = 'bool'
    case default
    end select

    c_type_name = string_to_char_array(trim(type_name))

  end subroutine get_var_type

  subroutine get_var_rank(c_var_name, rank) bind(C, name="get_var_rank")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var_rank

    character(kind=c_char), intent(in) :: c_var_name(*)
    integer(c_int), intent(out) :: rank

    ! The fortran name of the attribute name
    character(len=strlen(c_var_name)) :: var_name
    ! Store the name
    var_name = char_array_to_string(c_var_name)

    select case(var_name)
    case("arr1")
       rank = 1
    case("arr2")
       rank = 2
    case("arr3")
       rank = 3
    case default
       rank = 0
    end select
  end subroutine get_var_rank

  subroutine get_var_shape(c_var_name, shape) bind(C, name="get_var_shape")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var_shape

    character(kind=c_char), intent(in) :: c_var_name(*)
    integer(c_int), intent(inout) :: shape(MAXDIMS)

    character(len=strlen(c_var_name)) :: var_name

    var_name = char_array_to_string(c_var_name)
    shape = (/0, 0, 0, 0, 0, 0/)

    select case(var_name)
    case("arr1")
       shape(1:1) = 3
    case("arr2")
       shape(1:2) = (/2, 3/)
    case("arr3")
       shape(1:3) = (/2, 2, 3/)
    end select
  end subroutine get_var_shape


  subroutine get_var(c_var_name, x) bind(C, name="get_var")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var

    ! Return a pointer to the variable

    character(kind=c_char), intent(in) :: c_var_name(*)
    type(c_ptr), intent(inout) :: x

    character(len=strlen(c_var_name)) :: var_name
    ! Store the name

    var_name = char_array_to_string(c_var_name)

    select case(var_name)
    case("arr1")
       x = c_loc(arr1)
    case("arr2")
       x = c_loc(arr2)
    case("arr3")
       x = c_loc(arr3)
    end select

  end subroutine get_var

  subroutine set_var(c_var_name, xptr) bind(C, name="set_var")
    !DEC$ ATTRIBUTES DLLEXPORT :: set_var
    ! Return a pointer to the variable
    use iso_c_binding, only: c_double, c_char, c_loc, c_f_pointer

    character(kind=c_char), intent(in) :: c_var_name(*)
    type(c_ptr), value, intent(in) :: xptr


    real(c_double), pointer :: x_1d_double_ptr(:)
    real(c_double), pointer :: x_2d_double_ptr(:,:)
    real(c_double), pointer :: x_3d_double_ptr(:,:,:)
    integer(c_int), pointer :: x_1d_int_ptr(:)
    integer(c_int), pointer :: x_2d_int_ptr(:,:)
    integer(c_int), pointer :: x_3d_int_ptr(:,:,:)
    real(c_float), pointer  :: x_1d_float_ptr(:)
    real(c_float), pointer  :: x_2d_float_ptr(:,:)
    real(c_float), pointer  :: x_3d_float_ptr(:,:,:)
    logical(c_bool), pointer  :: x_1d_bool_ptr(:)
    logical(c_bool), pointer  :: x_2d_bool_ptr(:,:)
    logical(c_bool), pointer  :: x_3d_bool_ptr(:,:,:)

    ! The fortran name of the attribute name
    character(len=strlen(c_var_name)) :: var_name
    ! Store the name
    var_name = char_array_to_string(c_var_name)

    select case(var_name)
    case("arr1")
       call c_f_pointer(xptr, x_1d_double_ptr, shape(arr1))
       arr1(:) = x_1d_double_ptr
    case("arr2")
       call c_f_pointer(xptr, x_2d_int_ptr, shape(arr2))
       arr2(:,:) = x_2d_int_ptr
    case("arr3")
       call c_f_pointer(xptr, x_3d_bool_ptr, shape(arr3))
       arr3(:,:,:) = x_3d_bool_ptr
    end select

  end subroutine set_var

  subroutine set_var_slice(c_var_name, c_start, count, xptr) bind(C, name="set_var_slice")
    
    !DEC$ ATTRIBUTES DLLEXPORT :: set_var_slice
    ! Return a pointer to the variable
    use iso_c_binding, only: c_double, c_char, c_loc, c_f_pointer

    integer(c_int) :: c_start(MAXDIMS)
    integer(c_int) :: start(MAXDIMS)
    integer(c_int) :: count(MAXDIMS)
    character(kind=c_char), intent(in) :: c_var_name(*)
    type(c_ptr), value, intent(in) :: xptr


    real(c_double), pointer :: x_1d_double_ptr(:)
    real(c_double), pointer :: x_2d_double_ptr(:,:)
    real(c_double), pointer :: x_3d_double_ptr(:,:,:)
    integer(c_int), pointer :: x_1d_int_ptr(:)
    integer(c_int), pointer :: x_2d_int_ptr(:,:)
    integer(c_int), pointer :: x_3d_int_ptr(:,:,:)
    real(c_float), pointer  :: x_1d_float_ptr(:)
    real(c_float), pointer  :: x_2d_float_ptr(:,:)
    real(c_float), pointer  :: x_3d_float_ptr(:,:,:)
    logical(c_bool), pointer  :: x_1d_bool_ptr(:)
    logical(c_bool), pointer  :: x_2d_bool_ptr(:,:)
    logical(c_bool), pointer  :: x_3d_bool_ptr(:,:,:)

    ! The fortran name of the attribute name
    character(len=strlen(c_var_name)) :: var_name
    ! Store the name
    var_name = char_array_to_string(c_var_name)

    start = c_start + 1

    select case(var_name)
    case("arr1")
       call c_f_pointer(xptr, x_1d_double_ptr, (/count(1)/))
       arr1(start(1):(start(1)+count(1)-1)) = (/ x_1d_double_ptr /)
    case("arr2")
       call c_f_pointer(xptr, x_2d_int_ptr, (/count(1), count(2)/))
       arr2(start(1):(start(1)+count(1)), start(2):(start(2)+count(2))) = x_2d_int_ptr
    case("arr3")
       call c_f_pointer(xptr, x_3d_int_ptr, (/count(1), count(2), count(3)/))
       arr3(start(1):(start(1)+count(1)), start(2):(start(2)+count(2)), start(3):(start(3)+count(3))) = x_3d_bool_ptr
    end select

  end subroutine set_var_slice

  
  subroutine get_current_time(time) bind(C, name="get_current_time")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_current_time

    real(c_double) :: time
    time = t

  end subroutine get_current_time

  subroutine get_start_time(time) bind(C, name="get_start_time")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_start_time

    real(c_double) :: time
    time = t_start

  end subroutine get_start_time

  subroutine get_time_step(time_step) bind(C, name="get_time_step")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_time_step

    real(c_double) :: time_step
    time_step = 1.0

  end subroutine get_time_step
  
  subroutine get_end_time(time) bind(C, name="get_end_time")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_end_time

    real(c_double) :: time
    time = t_end

  end subroutine get_end_time

end module demo_model


