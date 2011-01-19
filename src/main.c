#include <stdio.h>

#include "minuit-c.h"

double funcTest(int comp, double * xs, void * data) {
	double ans = 0.;
	int i;
	for (i=0; i<comp; i++)
		ans += (xs[i]-1)*xs[i];
	return ans;
}

int
main() {
	int comp = 4;
	char *names[] = {"t", "x", "y", "z"};
	double init_values[] = {0., 0., 0., 0.};
	double init_errors[] = {0.01, 1., 1., 1.};
	double mini_values[] = {0., 0., 0., 0.};
	double mini_errors[] = {1., 1., 1., 1.};
	double fcn;
	int isValid;
	migrad(comp, &funcTest, names, init_values, init_errors, mini_values, mini_errors, &fcn, &isValid, NULL);
	int i;
	for (i=0; i<comp; i++)
		printf("%f\t%f\n", mini_values[i], mini_errors[i]);
	printf("%d\t%f\n", isValid, fcn);
	return 0;
}

