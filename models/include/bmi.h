
/*
   Control function.
   These return an error code.
 */
#ifdef __cplusplus
extern "C" {
#endif

int initialize(char *config_file);

int update(double dt);

int finalize();

/*
   Time control functions
 */
void get_start_time(double *t);

void get_end_time(double *t);

void get_current_time(double *t);

void get_time_step(double *dt);



void get_var_shape(char *name, int *shape);

void get_var_rank(char *name, int *rank);

void get_var_name(int *index, char *name); // non-BMI

void get_var(char *name, void *ptr);




void get_var_count(int *count); // non-BMI



/* extension, allows for a logger to be set from outside so we can log messages */
typedef void (*Logger)(int level, const char *msg);

/* pass a pointer to the function pointer */
void set_logger(Logger logger);


#ifdef __cplusplus
}
#endif

