/* -*- c-file-style: "stroustrup" -*- */

#ifndef BMI_EXT_H
#define BMI_EXT_H

#define BMI_EXT_VERSION_MAJOR 1
#define BMI_EXT_VERSION_MINOR 0

#if defined _WIN32
#define BMI_EXT __declspec(dllexport)
/* Calling convention, stdcall in windows, cdecl in the rest of the world */
#define CALLCONV __stdcall
#else
#define BMI_EXT
#define CALLCONV
#endif


#define MAXSTRINGLEN 1024
#define MAXDIMS 6
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef enum {
        ALL,
        DEBUG,
        INFO,
        WARN,
        ERROR,
        FATAL
    } Level;

    /* logger to be set from outside so we can log messages */
    typedef void (CALLCONV *Logger)(Level level, const char *msg);

    /* set logger by setting a pointer to the log function */
    BMI_API void set_logger(Logger logger);


#ifdef __cplusplus
}
#endif

#endif
