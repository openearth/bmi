## This is a make template transformed into set_structure_field.inc by scripts/generate.py

  integer(c_int) function set_structure_field(c_var_name, c_id, c_field_name, x) result(ierr) bind(C, name="set_structure_field")
    !DEC$ ATTRIBUTES DLLEXPORT::set_structure_field
    use MessageHandling
    use c_structures
    use m_structure
%for structure in structures:
    use m_${structure["type"]}
%endfor

    character(c_char), intent(in) :: c_var_name(MAXSTRINGLEN)
    character(c_char), intent(in) :: c_id(MAXSTRINGLEN)
    character(c_char), intent(in) :: c_field_name(MAXSTRINGLEN)
    type(c_ptr), intent(inout) :: x

    character(len=MAXSTRINGLEN) :: var_name !pumps
    character(len=MAXSTRINGLEN) :: id       !pump01
    character(len=MAXSTRINGLEN) :: field_name !capacity

    ! used for looking for field name
    integer :: index
    character(c_char) :: c_type_name_lookup(MAXSTRINGLEN)
    integer :: n_fields
    character(c_char) :: c_field_name_lookup(MAXSTRINGLEN)
    character(c_char) :: c_field_type_lookup(MAXSTRINGLEN)
    integer(c_int) :: rank
    integer(c_int) :: shape(MAXDIMS)
    character(len=MAXSTRINGLEN) :: type_name_lookup !pump
    character(len=MAXSTRINGLEN) :: field_name_lookup !capacity
    character(len=MAXSTRINGLEN) :: field_type_lookup !double

    integer :: structure_index
    type(structure_t), pointer          :: structure


    ! Internal storage for casting

%for type in ISOTYPESMAP:
%for i in range(4):
    ${ISOTYPESMAP[type]}, pointer     :: x_${i}d_${type}_ptr${"({})".format(",".join(":"*i)) if i else ""}
%endfor
%endfor

%for structure in structures:
    type(${structure["type"]})          :: c_${structure["type"]}
%endfor


    var_name = trim(char_array_to_string(c_var_name))  !variable to update
    id = trim(char_array_to_string(c_id))  !id to update
    field_name = trim(char_array_to_string(c_field_name))  ! capacity


    structure_index = -1

    select case(var_name)
%for structure in structures:
    case("${structure["name"]}")
        do index = 1, size(${structure["name"]}, 1)
           if (trim(char_array_to_string(${structure["name"]}(index)%id)) == trim(id) ) then
              structure_index = index
              c_${structure["type"]} = ${structure["name"]}(index)
              exit
           end if
        end do
%endfor
    end select
    if (structure_index == -1) then
       write(msgbuf, *) "structure with id ", trim(id), "not found"
       call warn_flush()
    end if

    ! Lookup type of variable
    call get_var_type(c_var_name, c_type_name_lookup)
    type_name_lookup = char_array_to_string(c_type_name_lookup)
    ! Lookup number of fields
    ierr = inq_compound(c_type_name_lookup, n_fields)
    do index = 1, n_fields
       ! query the type
       ierr = inq_compound_field(c_type_name_lookup, index, c_field_name_lookup, c_field_type_lookup, rank, shape)
       field_name_lookup = trim(char_array_to_string(c_field_name_lookup))
       field_type_lookup = trim(char_array_to_string(c_field_type_lookup))
       if (field_name == field_name_lookup) then
          select case(type_name_lookup)
%for structure in structures:
          case("${structure["type"]}")
             ! lookup c+ structure in vector

             ! transfer the C pointer
             select case(field_name)
%for field in structure["fields"]:
             case("${field["name"]}")
<% rank = len(field["shape"]) %>
<% ptr = "x_{}d_{}_ptr".format(rank, field["type"]) %>
%if rank > 0:
                call c_f_pointer(x, ${ptr}, shape)
%else:
                call c_f_pointer(x, ${ptr})
%endif
                c_${structure["type"]}%${field["name"]} = ${ptr}
                ${structure["name"]}(structure_index) = c_${structure["type"]}
                exit                  ! stop looping
%endfor
             end select
%endfor
          end select
       end if

    end do

    ! this copied it into the c structure

    select case(var_name)
%for structure in structures:
    case("${structure["name"]}")
       call set_${structure["type"]}_by_id(trim(char_array_to_string(c_id)), c_${structure["type"]})
%endfor
    end select
  end function set_structure_field
