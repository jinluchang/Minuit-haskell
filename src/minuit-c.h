#ifdef __cplusplus
extern "C" {
#endif

typedef double
Function(int comp,
		double * xs,
		void * data);

int
migrad(int comp,
		Function * func,
		char * names[],
		double init_values[], double init_errors[],
		double mini_values[], double mini_errors[],
		double * fcn, int * isValid,
		void * data);

#ifdef __cplusplus
}
#endif


