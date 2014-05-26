#include <stdio.h>
#include <stdbool.h>
#include <stdbool.h>
#include <string.h>
#include "../include/bmi.h"

double current = 0;
double timestep = 1;


// define some arrays for exchange
double arr1[3] = { 3, 2, 1};
int arr2[2][3] =
  {
    { 3, 2, 1},
    { 6, 4, 2}
  };
bool arr3[2][2][3] =
  {
    {
      { true, false, false},
      { false, true, false}
    },
    {
      { false, false, false},
      { false, true, false}
    }
  };

typedef enum {
  NOTSET,
  DEBUG,
  INFO,
  WARN,
  ERROR,
  FATAL
} Level ;

/* Store callback */
Logger logger = NULL;

/* Logger function */
void _log(Level level, char *msg);

BMI_API int initialize(char *config_file)
{
  char msg[MAXSTRINGLEN];
  sprintf(msg, "initializing with %s \n", config_file);
  _log(INFO, msg);
  return 0;
}


BMI_API int update(double dt){
  char msg[MAXSTRINGLEN];
  sprintf(msg, "updating from %f with %f \n", current, (dt != -1 ? dt : timestep));
  _log(DEBUG, msg);
  current += (dt != -1 ? dt : timestep);
  return 0;
}

BMI_API int finalize()
{
  _log(INFO, "finalizing c model");
  return 0;
}

BMI_API void get_start_time(double *t)
{
  *t = 0;
}

BMI_API void get_end_time(double *t)
{
  *t = 10;
}

BMI_API void get_current_time(double *t)
{
  *t = current;
}

BMI_API void get_time_step(double *dt)
{
  *dt = timestep;
}

BMI_API void get_var_count(int *n)
{
  *n = 3;
}

BMI_API void get_var_name(int n, char *name)
{
  char msg[MAXSTRINGLEN];
  switch (n) {
  case 0:
    strncpy(name, "arr1", MAXSTRINGLEN);
    break;
  case 1:
    strncpy(name, "arr2", MAXSTRINGLEN);
    break;
  case 2:
    strncpy(name, "arr3", MAXSTRINGLEN);
    break;
  default:
    strncpy(name, "", MAXSTRINGLEN);
  }
  sprintf(msg, "getting variable %d -> %s\n", n, name);
  _log(DEBUG, msg);

}

BMI_API void get_var(char *name, void **ptr)
{
  /* The value referenced to by ptr is the memory address of arr1 */
  *ptr = &arr1;
}

BMI_API void set_var(char *name, const void *ptr)
{
  /* I think this should be enough */
  
  memcpy(&arr1, ptr, 3*sizeof(double)); 
}

BMI_API void set_logger(Logger callback)
{
  char *msg = "Logger attached to c model.";
  logger = callback;
  _log(INFO, msg);
}

void _log(Level level, char *msg) {
  if (logger != NULL) {
    logger(level, msg);
  }
}

#if defined _WIN32
void main()
{
}
#endif
