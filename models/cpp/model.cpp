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

/* Store callback */
Logger logger = NULL;

/* Logger function */
void _log(Level level, std::string msg);


extern "C" {
  BMI_API int initialize(const char *config_file)
  {
	std::ostringstream msg;
	msg << "initializing with " << config_file;
	_log(INFO, msg.str());
    return 0;
  }

  BMI_API int update(double dt)
  {
    std::ostringstream msg;
    msg << "updating from " << current << " with dt: " << (dt != -1 ? dt : timestep);
    _log(DEBUG, msg.str());
    current += (dt != -1 ? dt : timestep);
    return 0;
  }

  BMI_API int finalize()
  {
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

  BMI_API void get_var(const char *name, void **ptr)
  {
	  /* The value referenced to by ptr is the memory address of arr1 */
	  *ptr = &arr1;
  }

  BMI_API void set_logger(Logger callback)
  {
    Level level = INFO;
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

// placeholder function, all dll's need a main.. in windows only
#if defined _WIN32
void main()
{
}
#endif
