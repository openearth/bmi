subroutine get_var_rank(c_var_name, rank) bind(C, name="get_var_rank")
  !DEC$ ATTRIBUTES DLLEXPORT :: get_var_rank

  use iso_c_binding, only: c_int, c_char
  character(kind=c_char), intent(in) :: c_var_name(*)
  integer(c_int), intent(out) :: rank

  ! The fortran name of the attribute name
  character(len=strlen(c_var_name)) :: var_name
  ! Store the name
  var_name = char_array_to_string(c_var_name)

  select case(var_name)
%for variable in variables:
  case("${variable['name']}")
     rank = ${variable["rank"]}
%endfor
  end select
end subroutine get_var_rank

