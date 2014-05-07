## This is a mako template transformed into inq_compound_field.inc by scripts/generate.py

integer(c_int) function inq_compound_field(type_name, index, field_name, &
       field_type, rank, shape) bind(C, name="inq_compound_field")
    !DEC$ ATTRIBUTES DLLEXPORT::inq_compound_field
    use c_structures
    character(c_char), intent(in) :: type_name(MAXSTRINGLEN)
    integer(c_int), intent(in) :: index
    character(c_char), intent(out) :: field_name(MAXSTRINGLEN)
    character(c_char), intent(out) :: field_type(MAXSTRINGLEN)
    integer(c_int), intent(out) :: rank
    integer(c_int), intent(out) :: shape(MAXDIMS)
    shape = 0

    select case(char_array_to_string(type_name))
%for structure in structures:
    case('${structure["type"]}')
       select case(index)
%for i, field in enumerate(structure["fields"]):
       case(${i + 1})
          field_name = string_to_char_array('${field["name"]}')
          field_type = string_to_char_array('${field["type"]}')
          rank = ${len(field["shape"])}
%for j in range(len(field["shape"])):
          shape(${j + 1}) = ${field["shape"][j]}
%endfor
%endfor
       end select
%endfor
    end select
  end function inq_compound_field
