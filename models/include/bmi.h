/* -*- c-file-style: "stroustrup" -*- */

#ifndef BMI_API_H
#define BMI_API_H

#define BMI_API_VERSION_MAJOR 1
#define BMI_API_VERSION_MINOR 0


#if defined _WIN32
#define BMI_API __declspec(dllexport)
/* Calling convention, stdcall in windows, cdecl in the rest of the world */
#define CALLCONV __stdcall
#else
#define BMI_API
#define CALLCONV
#endif


#define MAXSTRINGLEN 1024
#define MAXDIMS 6
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

    /* control functions. These return an error code. */

    /* Initialize the model */
    BMI_API int initialize(const char *config_file);

    /* Update the model with timesep dt (dt==-1 is default) */
    BMI_API int update(double dt);

    /* Finalize the model */
    BMI_API int finalize();

    /* time control functions */

    /* Get the start the time */
    BMI_API void get_start_time(double *t);

    /* Get the end time */
    BMI_API void get_end_time(double *t);

    /* Get the current time  */
    BMI_API void get_current_time(double *t);

    /* Get the current time step  */
    BMI_API void get_time_step(double *dt);

    /* variable info */

    /* Get the shape of variable name */
    BMI_API void get_var_shape(const char *name, int shape[MAXDIMS]);

    /* Return the rank of variable name */
    BMI_API void get_var_rank(const char *name, int *rank);

    /* Return the type name of variable */
    BMI_API void get_var_type(const char *name, char *type);

    /* Get the number of variables  */
    BMI_API void get_var_count(int *count);

    /* Get the name of variable index */
    BMI_API void get_var_name(int index, char *name);

    /* Get a pointer pointer - a reference to a multidimensional array */
    BMI_API void get_var(const char *name, void **ptr);

    /* Set the variable from contiguous memory referenced to by ptr */
    BMI_API void set_var(const char *name, const void *ptr);

    /* Set a slice of the variable from contiguous memory using start / count multi-dimensional indices */
    BMI_API void set_var_slice(const char *name, const int *start, const int *count, const void *ptr);

    /* Set a the variable using a vector of indices, indices are assumed to match the c-continguous flattened indices */
    BMI_API void set_var_at_indices(const char *name, const int *indices, const int count, const void *ptr);


#ifdef __cplusplus
}
#endif

#endif

