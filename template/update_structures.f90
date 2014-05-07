## This is a mako template transformed into update_structure.inc by scripts/generate.py

%for structure in structures:
  subroutine update_${structure["name"]}(structures, ${structure["name"]})
    ! convert structures to ${structure["name"]} (fortran to c conversion)
    use m_structure
    use MessageHandling
    use m_${structure["type"]}

    implicit none

    type(t_structureSet), intent(in) :: structures
    type(${structure["type"]}), dimension(:), intent(inout), allocatable :: ${structure["name"]}

    integer :: istruct, i${structure["type"]}

    integer :: n${structure["name"]}
    type(structure_t), pointer :: structure
    type(${structure["type"]}_t), pointer :: fortran${structure["type"]}
    type(${structure["type"]}) :: c_${structure["type"]}
    character(len=MAXSTRINGLEN) :: msg

    n${structure["name"]} = 0

    write(msgbuf,*) 'Searching through', structures%Count, 'structures for ${structure["name"]}'
    call dbg_flush()

    do istruct=1,structures%Count
       structure => structures%struct(istruct)
       if ( structure%st_type .eq. ST_${structure["type"].upper()} ) then
          fortran${structure["type"]} => structure%${structure["type"]}
          n${structure["name"]} = n${structure["name"]} + 1
       end if
    end do

    write(msgbuf,*) 'Checking if  ${structure["name"]} is allocated', allocated(${structure["name"]})
    call dbg_flush()
    if ( allocated(${structure["name"]}) ) then
       write(msgbuf,*) 'Deallocating ${structure["name"]} of size', shape(${structure["name"]})
       call dbg_flush()
       deallocate(${structure["name"]})
    end if

    write(msgbuf,*) 'Allocating  ${structure["name"]} to', n${structure["name"]}
    call dbg_flush()
    allocate(${structure["name"]}(n${structure["name"]}))
    write(msgbuf,*) 'Checking if  ${structure["name"]} is allocated', allocated(${structure["name"]})
    call dbg_flush()


    i${structure["type"]} = 0
    do istruct=1,structures%Count
       structure => structures%struct(istruct)
       if ( structure%st_type .eq. ST_${structure["type"].upper()} ) then
          fortran${structure["type"]} => structure%${structure["type"]}
          i${structure["type"]} = i${structure["type"]} + 1
%for field in structure["fields"]:
%if field["type"] == "char":
          c_${structure["type"]}%${field["name"]} = string_to_char_array(${field["internal"]})
%else:
          c_${structure["type"]}%${field["name"]} = ${field["internal"]}
%endif
%endfor
          ${structure["name"]}(i${structure["type"]}) = c_${structure["type"]}
       end if
    end do

    write(msgbuf,*) 'Allocated ${structure["name"]} to shape', shape(${structure["name"]})
    call dbg_flush()

  end subroutine update_${structure["name"]}
%endfor
