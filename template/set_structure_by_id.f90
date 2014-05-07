## This is a mako template transformed into update_structure.inc by scripts/generate.py


%for structure in structures:
  subroutine set_${structure["type"]}_by_id(id, c_${structure["type"]})
    ! convert structures to pumps (fortran to c conversion)
    use modelGlobalData
    use m_structure
    use m_${structure["type"]}
    use MessageHandling
    use cpluv
    character(len=*), intent(in) :: id

    type(${structure["type"]}), intent(in) :: c_${structure["type"]}

    integer :: istruct, i${structure["name"]}, istage ! counting...

    type(structure_t), pointer :: structure
    type(${structure["type"]}_t), pointer :: fortran${structure["type"]}
    character(len=MAXSTRINGLEN) :: msg


    do istruct=1,network%sts%Count
       structure => network%sts%struct(istruct)
       if (structure%id == id) then
          if (.not. structure%st_type .eq. ST_${structure["type"].upper()}) then
             write(msgbuf,*) "Structure", id, "is not of type ${structure["type"]}"
             call err_flush()
          end if
          fortran${structure["type"]} => structure%${structure["type"]}
          exit
       end if
    end do

%for field in structure["fields"]:
%if field["type"] == "char":
    ${field["internal"]} = char_array_to_string(c_${structure["type"]}%${field["name"]})
%else:
    write(msgbuf,*) 'setting ${field["internal"]} to', c_${structure["type"]}%${field["name"]}
    call dbg_flush()
    ${field["internal"]} = c_${structure["type"]}%${field["name"]}
%endif
%endfor
  end subroutine set_${structure["type"]}_by_id
%endfor
