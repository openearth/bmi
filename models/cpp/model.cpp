// SampleCppLibrary.cpp : Defines the exported functions for the DLL application.
//

#include <cstdio>
#include <string>
#include "bmi.h"


extern "C" {
  int initialize(char *config_file)
  {
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

  void set_logger(Logger logger)
  {
    int level = 3;
    std::string msg = "logging from cxx";
    (*logger)(level, msg.c_str());
  }
}
