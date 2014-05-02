// SampleCppLibrary.cpp : Defines the exported functions for the DLL application.
//

#include <cstdio>
#include <string>

#include "bmi.h"

using namespace std;

// TODO: move to a separate BMI C/C++ project.

void initialize(char* config_file)
{
}

void update(const double* dt)
{
}

void finalize()
{
}

void get_start_time(double* t)
{
}

void get_end_time(const double* t)
{
}

void get_current_time(double* t)
{
}

void get_time_step(double* dt)
{
}

void set_logger(Logger* logger)
{
  int level = 3;
  string msg = "hi hi hi hi hi";
  (*logger)(&level, msg.c_str());
}

