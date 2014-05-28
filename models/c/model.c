#include <stdio.h>
#include <stdbool.h>
#include <stdbool.h>
#include <string.h>
#include "../include/bmi.h"

double current = 0;
double timestep = 1;
char msg[MAXSTRINGLEN];
int shape[MAXDIMS] ;

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

/* Store callback */
Logger logger = NULL;

/* Logger function */
void _log(Level level, char *msg);

BMI_API int initialize(const char *config_file)
{
  sprintf(msg, "initializing with %s", config_file);
  _log(INFO, msg);
  return 0;
}


BMI_API int update(double dt){
  sprintf(msg, "updating from %f with %f", current, (dt != -1 ? dt : timestep));
  _log(DEBUG, msg);
  current = current + (dt != -1 ? dt : timestep);
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
  sprintf(msg, "getting variable %d -> %s", n, name);
  _log(DEBUG, msg);
}


BMI_API void get_var_rank(const char *name, int *rank)
{
  /* The value referenced to by ptr is the memory address of arr1 */
  if (strcmp(name, "arr1") == 0)
    {
      *rank = 1;
    } 
  else if (strcmp(name, "arr2") == 0)
    {
      *rank = 2;
    } 
  else if (strcmp(name, "arr3") == 0)
    {
      *rank = 3;
    } 
  else 
    {
      *rank = 0;
    }
  sprintf(msg, "variable %s has rank %d", name, *rank);
  _log(DEBUG, msg);
}


BMI_API void get_var_shape(const char *name, int shape[MAXDIMS])
{
  
  int rank = 0;
  int i;
  for (i = 0; i < MAXDIMS; i++) {
    shape[i] = 0;
  }

  get_var_rank(name, &rank);
  /* The value referenced to by ptr is the memory address of arr1 */
  if (strcmp(name, "arr1") == 0)
    {
      shape[0] = 3;
    } 
  else if (strcmp(name, "arr2") == 0)
    {
      shape[0] = 2;
      shape[1] = 3;

    } 
  else if (strcmp(name, "arr3") == 0)
    {
      shape[0] = 2;
      shape[1] = 2;
      shape[2] = 3;
    } 
  else 
    {
      
    }
  sprintf(msg, "variable %s has shape %d", name, *shape);
  _log(DEBUG, msg);
}

BMI_API void get_var_type(const char *name, char *type)
{
  /* The value referenced to by ptr is the memory address of arr1 */
  if (strcmp(name, "arr1") == 0)
    {
      strncpy(type, "double", MAXSTRINGLEN);
    } 
  else if (strcmp(name, "arr2") == 0)
    {
      strncpy(type, "int", MAXSTRINGLEN);
    } 
  else if (strcmp(name, "arr3") == 0)
    {
      strncpy(type, "bool", MAXSTRINGLEN);
    } 
  else 
    {
      strncpy(type, "", MAXSTRINGLEN);
    }
  sprintf(msg, "variable %s has type %s", name, type);
  _log(DEBUG, msg);
}

BMI_API void get_var(const char *name, void **ptr)
{
  /* The value referenced to by ptr is the memory address of arr1 */
  if (strcmp(name, "arr1") == 0)
    {
      *ptr = &arr1;
    } 
  else if (strcmp(name, "arr2") == 0)
    {
      *ptr = &arr2;
    } 
  else if (strcmp(name, "arr3") == 0)
    {
      *ptr = &arr3;
    } 
  else 
    {
      *ptr = NULL;
    }
  sprintf(msg, "variable %s is at location %p", name, *ptr);
  _log(DEBUG, msg);
}

BMI_API void set_var(const char *name, const void *ptr)
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
