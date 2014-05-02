#include <string>


extern "C" {

  void initialize(char* name);

  void update(double* dt);

  void finalize();

  void get_start_time(double* t);

  void get_end_time(const double* t);

  void get_current_time(double* t);

  void get_time_step(double* dt);

  void get_var_shape(char* name, int* shape);

  void get_var_rank(char* name, int* rank);

  void get_var_name(int* index, char* name); // non-BMI

  void get_var_count(int* count); // non-BMI

  /* extension, allows for a logger to be set from outside so we can log messages */
  typedef void (*Logger)(int*, const char* msg);

  /* pass a pointer to the function pointer */
  void set_logger(Logger* logger);
}
