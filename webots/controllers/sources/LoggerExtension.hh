#ifndef __LOGGEREXTENSION_HH__
#define __LOGGEREXTENSION_HH__

#include <string>
#include <sstream>
#include <vector>
#include <iostream>
#include <fstream>
#include "Rob.hh"
#include <sml/sml-tools/Settings.hh>
#include <sml/sml-tools/Logger.hh>

class Phase;
using namespace std;

class BodyLogger: public Logger
{
private: 
	Rob& rob;
public:
	BodyLogger(Rob& rob): rob(rob){
		raw_filesname = {
		"grf",
        "trunk",
		"distance",
		"footfall",
		"energy",
		"touchSensor",
		"bumper"
		};
	}
	void writeHeader();
	void writeContent();
};

class PerturbationLogger: public Logger
{
private: 
	PerturbatorManager* perturbator;
public:
	PerturbationLogger(PerturbatorManager* perturbator): perturbator(perturbator){
		raw_filesname = {
        "perturbation"
		};

	}
	void writeHeader();
	void writeContent();
};


#endif
