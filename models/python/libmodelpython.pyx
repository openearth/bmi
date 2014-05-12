ctypedef void (*Logger)(int level, char *msg)
cdef Logger logger
cdef double start_time = 0.0
cdef double current_time = 0.0
cdef double end_time = 10.0

cdef extern int initialize(char *configfile):
    logger(3, configfile)
    global current_time
    current_time = start_time
    return 0
cdef extern int update(double dt):
    global current_time
    current_time += dt
    msg = "time is now {}".format(current_time)
    logger(3, msg)
    return 0
cdef extern int finalize():
    global logger
    logger(3, "finalizing")
    return 0

cdef extern get_start_time(double *t):
    global start_time
    t = &start_time

cdef extern get_current_time(double *t):
    global current_time
    t = &current_time

cdef extern get_end_time(double *t):
    global end_time
    msg = 'end time is {:d}'.format(end_time)
    logger(3, msg)
    t = &end_time

cdef extern set_logger(Logger callback):
    global logger
    logger = callback
    logger(3, 'logger set to cython model')

