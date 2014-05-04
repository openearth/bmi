#include <stdio.h>
#include "../include/bmi.h"


double current = 0;
double timestep = 1;

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

void set_logger(Logger callback)
{
  char *msg = "Logger of c model attached.";
  logger = callback;
  _log(INFO, msg);
}

void _log(Level level, char *msg) {
  if (logger != NULL) {
    logger(level, msg);
  }
}

