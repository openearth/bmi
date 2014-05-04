// SampleCppLibrary.cpp : Defines the exported functions for the DLL application.
//

#include <cstdio>
#include <string>
#include <sstream>
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
void _log(Level level, std::string msg);


extern "C" {
  int initialize(char *config_file)
  {
    char msg[1024];
    sprintf(msg, "initializing with %s \n", config_file);
    _log(INFO, msg);
    return 0;
  }

  int update(double dt)
  {
    std::ostringstream msg;
    msg << "updating from " << current << " with dt: " << (dt != -1 ? dt : timestep);
    _log(DEBUG, msg.str());
    current += (dt != -1 ? dt : timestep);
    return 0;
  }

  int finalize()
  {
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
    int level = 3;
    std::string msg = "Logging attached to cxx model";
    logger = callback;
    logger(level, msg.c_str());
  }
}

void _log(Level level, std::string msg) {
  if (logger != NULL) {
    logger(level, msg.c_str());
  }
}
