  subroutine get_var_shape(c_var_name, shape) bind(C, name="get_var_shape")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var_shape

    use cpluv
    use modelGlobalData
    use c_structures


    use iso_c_binding, only: c_int, c_char, c_loc

    character(kind=c_char), intent(in) :: c_var_name(*)
    integer(c_int), intent(inout) :: shape(MAXDIMS)

    character(len=strlen(c_var_name)) :: var_name

    var_name = char_array_to_string(c_var_name)
    shape = (/0, 0, 0, 0, 0, 0/)

    select case(var_name)
%for variable in variables:
    case("${variable['altname'] or variable['name']}")
%if variable['rank'] == 0:
       shape(1) = 0
%else:
%for dim in range(variable['rank']):
       ! return in c memory order
       shape(${variable['rank'] - dim}) = size(${variable['name']}, ${dim+1})
%endfor
%endif
%endfor
! structures
%for structure in structures:
    case("${structure['name']}")
       call update_${structure['name']}(network%sts, ${structure['name']})
       if (allocated(${structure['name']})) then
          shape(1) = size(${structure['name']}, 1)
       end if
%endfor
    end select

  end subroutine get_var_shape
