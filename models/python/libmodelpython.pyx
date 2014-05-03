cdef extern int initialize(char *configfile):
    print('hi')
cdef extern update(double dt):
    print('hi')
cdef extern finalize():
    print('hi')

ctypedef void (*Logger)(const int *level, const char *msg)
cdef extern set_logger(Logger logger):
    cdef int level
    level = 1
    logger(&level, 'hi')

