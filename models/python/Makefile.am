# run cython to generate a libpython.so
lib_LTLIBRARIES=libmodelpython.la

# compile the c file into a libtool library
libmodelpython_la_SOURCES = \
	libmodelpython.c

libmodelpython_la_CFLAGS=-I$(PYTHON_INCLUDE_DIR) -l$(PYTHON_LIB)

#libmodelpython.la: libmodelpython.c

# Generate c file
libmodelpython.c: libmodelpython.pyx
	cython libmodelpython.pyx
