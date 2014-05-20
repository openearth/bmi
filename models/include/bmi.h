#ifndef BMI_API_H
#define BMI_API_H

#define BMI_API_VERSION_MAJOR 1
#define BMI_API_VERSION_MINOR 0

#if defined _WIN32
#define BMI_API __declspec(dllexport)
#else
#define BMI_API
#endif

#include <stddef.h>
/*
  Control function.
  These return an error code.
*/
#ifdef __cplusplus
extern "C" {
#endif

  BMI_API int initialize(char *config_file);

  BMI_API int update(double dt);

  BMI_API int finalize();

  /*
    Time control functions
  */
  BMI_API void get_start_time(double *t);

  BMI_API void get_end_time(double *t);

  BMI_API void get_current_time(double *t);

  BMI_API void get_time_step(double *dt);


  BMI_API void get_var_shape(char *name, int *shape);

  BMI_API void get_var_rank(char *name, int *rank);

  BMI_API void get_var_name(int *index, char *name);

  BMI_API void get_var_count(int *count);


  /* get a pointer pointer - a reference to a multidimensional array */
  BMI_API void get_var(char *name, void **ptr);


  /* Set the variable from contiguous memory referenced to by ptr */
  BMI_API void set_var(char *name, const void *ptr);

  /* Set the variable from contiguous memory, using a stride */
  BMI_API void set_var_strided(char *name, const size_t *startp, const size_t *countp, const ptrdiff_t *stridep, const void *ptr);

  /* logger to be set from outside so we can log messages */
  typedef void (*Logger)(int level, const char *msg);

  /* set logger by setting a pointer to the log function */
  BMI_API void set_logger(Logger logger);


#ifdef __cplusplus
}
#endif

#endif
