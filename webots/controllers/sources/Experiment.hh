#ifndef __EXPERIMENT_HH__
#define __EXPERIMENT_HH__

#include <string>
#include <sstream>
#include <vector>
#include <iostream>
#include <fstream>
#include "Rob.hh"

#include <sml/sml-tools/Logger.hh>

using namespace std;


#include <webots/Supervisor.hpp>
#include <webots/TouchSensor.hpp>


class BaseExperiment{
public:
	webots::Supervisor* supervisor;
	BaseExperiment(webots::Supervisor* supervisor): supervisor(supervisor){};
	virtual void initiation()=0;
	virtual void termination()=0;
	void run();
	virtual void step()=0;
};

class Experiment : public BaseExperiment
{
public:
	Rob *body;
	int color;

	Experiment(Rob * body);
	void initiation();
	void termination();
	
	void step();
};




#endif /* __GRADIENT_HH__ */
