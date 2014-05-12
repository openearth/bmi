subroutine get_var_type(c_var_name, c_type_name)  bind(C, name="get_var_type")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var_type

    character(kind=c_char), intent(in) :: c_var_name(*)
    ! make sure you pass a string_buffer from python of len(MAXSTRINGLEN)
    character(kind=c_char), intent(out) :: c_type_name(MAXSTRINGLEN)
    ! Use one of the following types

    integer(c_int) :: i
    integer :: typeid
    character(len=MAXSTRINGLEN) :: type_name
    character(len=MAXSTRINGLEN) :: var_name

    var_name = char_array_to_string(c_var_name)

    select case(var_name)
%for variable in variables:
    case("${variable['name']}")
       type_name = "${variable['type']}"
%endfor
    end select

    c_type_name = string_to_char_array(trim(type_name))

  end subroutine get_var_type
