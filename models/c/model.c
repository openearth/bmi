/* -*- c-file-style: "stroustrup" -*- */
/* Please use the stroustrup coding standard: */


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
    current = 0;
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
    if (strcmp(name, "arr1") == 0)
    {
        memcpy(arr1, ptr, sizeof(arr1));
    }
    else if (strcmp(name, "arr2") == 0)
    {
        memcpy(arr2, ptr, sizeof(arr2));
    }
    else if (strcmp(name, "arr3") == 0)
    {
        memcpy(arr3, ptr, sizeof(arr3));
    }
}


void ravel_indices(int indices[][MAXDIMS], int n, int *shape, int rank, char order) {
    int i;
    int j;
    int index[MAXDIMS];
    int prod;
    printf("rank: %d\n", rank);
    printf("shape:\n");
    for (j=0; j<rank; j++) {
        printf("%d ", shape[j]);
    }
    
    printf("\n");
    for (i = 0; i < n; i++) {
        index[i] = 0;
        prod=1;
        for (j=0; j<rank; j++) {
            prod = prod * shape[rank-j-1];
            printf("idx %d %d, prod %d, shape %d\n", i, j, prod, shape[rank-j-1]);
            index[i] += (indices[i][j] + prod);
        }
    }
    printf("value\n");
    for (i=0; i < n; i++) {
        printf("%d ", index[i]);
    }
    printf("\n");
};

BMI_API void set_var_slice(const char *name, const int *start, const int *count, const void *ptr)
{
    int rank; 
    int shape[MAXDIMS];
    void *arr;
    int size;

    if (strcmp(name, "arr1") == 0)
    {
        size = sizeof(arr1);
        arr = &arr1;
        get_var_rank(name, &rank);
        get_var_shape(name, shape);
    }
    else if (strcmp(name, "arr2") == 0)
    {
        size = sizeof(arr2);
        arr = &arr2;
        get_var_rank(name, &rank);
        get_var_shape(name, shape);
    }
    else if (strcmp(name, "arr3") == 0)
    {
        size = sizeof(arr3);
        arr = &arr3;
        get_var_rank(name, &rank);
        get_var_shape(name, shape);
    }
    
    const char order='C';
    /* n dims by n points */
    int indices[][MAXDIMS] = {{1}, {10}, {50}, {90}};
    ravel_indices(indices, 4, shape, rank, order);
    
    int indices2[][MAXDIMS]  = {{1,5}, {2,3}, {5,8}, {6,3}};
    shape[0] = 2;
    shape[1] = 10;
    ravel_indices(indices2, 4, shape, 2, order);
    // {15, 16, 26}
    
    
}

BMI_API void set_logger(Logger callback)
{
    char *msg = "Logger attached to c model.";
    logger = callback;
    _log(INFO, msg);
}

/* private log function, which logs to the logging callback */
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
