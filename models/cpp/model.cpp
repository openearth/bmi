// SampleCppLibrary.cpp : Defines the exported functions for the DLL application.
//

#include <cstdio>
#include <string>
#include "bmi.h"


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
  }

  int finalize()
  {
  }

  void get_start_time(double *t)
  {
  }

  void get_end_time(double *t)
  {
  }

  void get_current_time(double *t)
  {
  }

  void get_time_step(double *dt)
  {
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
