  subroutine get_var_shape(c_var_name, shape) bind(C, name="get_var_shape")
    !DEC$ ATTRIBUTES DLLEXPORT :: get_var_shape

    ! Include modules?

    use iso_c_binding, only: c_int, c_char, c_loc

    character(kind=c_char), intent(in) :: c_var_name(*)
    integer(c_int), intent(inout) :: shape(MAXDIMS)

    character(len=strlen(c_var_name)) :: var_name

    var_name = char_array_to_string(c_var_name)
    shape = (/0, 0, 0, 0, 0, 0/)

    select case(var_name)

<%!
def shape_expr(variable):
    '''generate lines with shape expressions'''
    if variable['rank'] == 0:
        yield 'shape(1) = 0'
    for dim in range(variable['rank']):
        # return in c memory order
        i = variable['rank'] - dim
        if 'shape' in variable:
            # return shape if available
            shape_i = variable['shape'][dim]
        else:
            # return manual size lookup
            shape_i = "size({name:s}, {dim1:d})".format(name=variable['name'],
                                                        dim1=dim+1)
        yield 'shape({i}) = {shape_i}'.format(i=i, shape_i=shape_i)
%>
%for variable in variables:
    case("${variable['name']}")
%for line in shape_expr(variable):
        ${line}
%endfor
%endfor
    end select

  end subroutine get_var_shape
