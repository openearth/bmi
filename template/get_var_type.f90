subroutine get_var_type(c_var_name, c_type_name)  bind(C, name="get_var_type")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var_type

    character(kind=c_char), intent(in) :: c_var_name(*)
    ! make sure you pass a string_buffer from python of len(MAXSTRINGLEN)
    character(kind=c_char), intent(out) :: c_type_name(MAXSTRINGLEN)
    ! Use one of the following types
    ! BMI datatype        C datatype        NumPy datatype
    ! BMI_STRING          char*             S<
    ! BMI_INT             int               int16
    ! BMI_LONG            long int          int32
    ! BMI_FLOAT           float             float32
    ! BMI_DOUBLE          double            float64


    integer(c_int) :: i
    integer :: typeid
    character(len=MAXSTRINGLEN) :: type_name
    character(len=MAXSTRINGLEN) :: var_name

    var_name = char_array_to_string(c_var_name)

    select case(var_name)
%for variable in variables:
    case("${variable['altname'] or variable['name']}")
       type_name = "${variable['type']}"
%endfor
! structures
%for structure in structures:
    case("${structure['name']}")
       type_name = "${structure['type']}"
%endfor
    end select

    c_type_name = string_to_char_array(trim(type_name))

  end subroutine get_var_type
