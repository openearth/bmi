# Process this file with autoconf to produce a configure script.
AC_PREREQ(2.59)
AC_INIT([BMI demo models], 0.1.1)
AC_CONFIG_SRCDIR([fortran/model.f90])

AC_CONFIG_HEADER([config.h])
dnl Store generated files in config dir
AC_CONFIG_AUX_DIR([config])

dnl m4 macro's in m4 directory.
AC_CONFIG_MACRO_DIR([m4])

dnl Initialise automake
AM_INIT_AUTOMAKE

dnl Initialize LIBTOOL
dnl Make sure we have an up to date version.
dnl We're going to make it work with older versions also, this might not work (libtool < 2.2, not sure how to check)
LT_PREREQ(2.4)
LT_INIT

# c, c++ and c preprocessor
AC_PROG_CXX
AC_PROG_CC
AC_PROG_FC

# Other programs
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET


## This is copied from the libtool examples
## -------------------------- ##
## Fortran90 compiler checks. ##
## -------------------------- ##
AC_LANG_PUSH([Fortran])
# gfortran-mp-4.6 gfortran-mp-4.5 gfortran-mp-4.4 gfortran g95])
dnl Check the flags needed to link fc programs with ld (i.e. cc)
AC_FC_LIBRARY_LDFLAGS
dnl Check for underscoring of external names
AC_FC_WRAPPERS
dnl We need to use .f90 and not .f to enable Automake FC support
dnl Some Intel ifc/ifort do not understand .f95.  :-/
AC_FC_SRCEXT([f90])
dnl Yes, we want free form Fortran!
AC_FC_FREEFORM
dnl Set unlimited line length (don't create lines longer than 132, because it breaks on some compilers,
dnl but because ifort and gfortran allow it let's not raise errors by default)
AC_FC_LINE_LENGTH([unlimited])

AC_LANG_POP

#-------------------------------------------------------------------------------
#   List of makefiles to generate.  This list can be created with the command:
#   find . -name Makefile.am | egrep '/.+/' | sort | sed 's/.am$//'
AC_CONFIG_FILES(Makefile
        c/Makefile
        cpp/Makefile
        fortran/Makefile
        python/Makefile
)

AC_OUTPUT
