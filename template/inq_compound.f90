## This is a mako template transformed into inq_compound.inc by scripts/generate.py

integer(c_int) function inq_compound(name, n_fields) bind(C,name="inq_compound")
  !DEC$ ATTRIBUTES DLLEXPORT::inq_compound

  character(c_char), intent(in) :: name(MAXSTRINGLEN)
  integer(c_int), intent(out) :: n_fields

  n_fields = 0
  select case(char_array_to_string(name))
     %for structure in structures:
  case('${structure["type"]}')
     n_fields = ${len(structure["fields"])}
     %endfor
  end select
end function inq_compound
