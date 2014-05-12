subroutine get_var(c_var_name, x) bind(C, name="get_var")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var
    ! Return a pointer to the variable
    use iso_c_binding, only: c_double, c_char, c_loc

    character(kind=c_char), intent(in) :: c_var_name(*)
    type(c_ptr), intent(inout) :: x

    double precision :: tot
    integer :: i, j, k, l, m, n, noc
    ! The fortran name of the attribute name
    character(len=strlen(c_var_name)) :: var_name
    ! Store the name
    var_name = char_array_to_string(c_var_name)


    select case(var_name)
%for variable in variables:
    case("${variable['name']}")
       x = c_loc(${variable['path'] + "%" if variable['path'] else ''}${variable['name']})
%endfor
    end select

  end subroutine get_var
