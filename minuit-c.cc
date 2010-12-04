#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <vector>

#include <gsl/gsl_math.h>

#include <Minuit2/FCNBase.h>
#include <Minuit2/MnUserParameters.h>
#include <Minuit2/MnMigrad.h>
#include <Minuit2/MnMinos.h>
#include <Minuit2/MinosError.h>
#include <Minuit2/FunctionMinimum.h>
#include <Minuit2/MnPrint.h>

#include "minuit-c.h"

using namespace std;
using namespace ROOT::Minuit2;

class FCN : public FCNBase {
	public :
		FCN(Function * s_func, void * s_data) {
			func = s_func;
			data = s_data;
		}
		double 
			operator()(const vector<double>& x) const;
		double
			Up() const { return 1.; }
	private :
		Function * func;
		void * data;
};

double
FCN :: operator () (const vector<double>& x) const {
	int comp = x.size();
	double * xs = new double[comp];
	int i;
	for (i=0; i<comp; i++)
		xs[i] = x[i];
	double fcn = (*func)(comp, xs, data);
	delete[] xs;
	return fcn;
}

class FIT {
	public:
		FIT() {Init();}
		FIT(int s_comp, Function * func, char * names[], double * values, double * errors, void * s_data) {
			Init();
			SetComp(s_comp);
			SetData(s_data);
			SetFunction(func);
			parameters = new MnUserParameters();
			Adds(names, values, errors);
		}
		int
			Migrad() {
				if (minimum)
					delete minimum;
				MnMigrad migrad(*fcn, *parameters);
				minimum = new FunctionMinimum(migrad());
				return 0;
			}
		int
			Minimum(double values[], double errors[], double * fcn, int * isValid) {
				if (!minimum)
					Migrad();
				MnUserParameters * miniParameters =
					new MnUserParameters(minimum -> UserParameters());
				*fcn = minimum -> Fval();
				*isValid = minimum -> IsValid();
				int i;
				for (i=0; i<comp; i++) {
					values[i] = miniParameters -> Value(i);
					errors[i] = miniParameters -> Error(i);
				}
				return 0;
			}
		~FIT() {
			if (parameters)
				delete parameters;
			if (fcn)
				delete fcn;
		}
	protected :
		void
			Init() {
				comp = 0;
				parameters = NULL;
				fcn = NULL;
				minimum = NULL;
				data = NULL;
			};
		void
			SetComp(int s_comp) { comp = s_comp; }
		void
			SetData(void * s_data) { data = s_data; }
		int
			SetFunction(Function * func) {
				if (fcn)
					delete fcn;
				fcn = new FCN(func, data);
				return 0;
			}
		bool
			Add(char * name, double value, double error) {
				return parameters -> Add(name, value, error);
			}
		int
			Adds(char ** name, double * value, double * error) {
				int i;
				for (i=0; i<comp; i++)
					Add(name[i], value[i], error[i]);
				return 0;
			}
	private :
		int comp;
		void * data;
		FCN * fcn;
		FunctionMinimum * minimum;
		MnUserParameters * parameters;
};

int
migrad(int comp, Function * func, char * names[],
		double init_values[], double init_errors[],
		double mini_values[], double mini_errors[],
		double * fcn, int * isValid, void * data) {
	FIT * fit = new FIT(comp, func, names, init_values, init_errors, data);
	fit -> Minimum(mini_values, mini_errors, fcn, isValid);
	delete fit;
	return 0;
}


