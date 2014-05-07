%for structure in structures:
  type, public, bind(C) :: ${structure["type"]}
     %for field in structure["fields"]:
     ${ISOTYPESMAP[field["type"]]} :: ${field["name"]}${dimstr(field["shape"])}
     %endfor
  end type ${structure["type"]}
%endfor
%for structure in structures:
  type(${structure["type"]}), dimension(:), allocatable, target :: ${structure["name"]}
%endfor
