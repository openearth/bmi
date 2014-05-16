#include <stdio.h>
#include <stdbool.h>
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

int initialize(char *config_file)
{
  char msg[1024];
  sprintf(msg, "initializing with %s \n", config_file);
  _log(INFO, msg);
  return 0;
}


int update(double dt){
  char msg[1024];
  sprintf(msg, "updating from %f with %f \n", current, (dt != -1 ? dt : timestep));
  _log(DEBUG, msg);
  current += (dt != -1 ? dt : timestep);
  return 0;
}

int finalize()
{
  _log(INFO, "finalizing c model");
  return 0;
}

void get_start_time(double *t)
{
  *t = 0;
}

void get_end_time(double *t)
{
  *t = 10;
}

void get_current_time(double *t)
{
  *t = current;
}

void get_time_step(double *dt)
{
  *dt = timestep;
}


void get_var(char *name, void **ptr)
{
  /* The value referenced to by ptr is the memory address of arr1 */
  *ptr = &arr1;
}

void set_logger(Logger callback)
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

