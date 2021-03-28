#include "Experiment.hh"
#include "LoggerExtension.hh"
#include <sml/sml-tools/Helper.hh>
#include <sml/sml-tools/FitnessManager.hh>
#include <sml/sml-tools/PhaseManager.hh>

#include "config.hh"

#include <boost/algorithm/string.hpp>

using namespace std;
extern bool debug;

extern EventManager * eventManager;


void BaseExperiment::run(){
	initiation();
	static bool DIE = false;
	static int counter = 0;
	supervisor->step(Settings::get<int>("time_step"));
	while(true) {
#ifdef WEBOTS6
        if(Settings::get<int>("extract_video") == 1)
			supervisor->startMovie(Settings::get<string>("video_name"),500,400,0,100);
#else
		//TODO IMPLEMENT FOR WEBOTS7 and WEBOTS8
#endif
		this->step();
		supervisor->step(Settings::get<int>("time_step"));
		if(eventManager->isRunFinished() && !DIE){
			termination();
			DIE = true;

		}

		
		if(DIE){
			counter = Settings::isOptimization() ? counter+1 : 2001;
		}
		if(counter > 2000)
			break;
	}

	bool endExp = false;
    if(Settings::isOptimization())
    {
        optimizer &opti = tryGetOpti();
        if (opti && !opti.Setting("optiextractor")) endExp = true;
    }
    else
        endExp = true;

    if(endExp){
	    if(Settings::get<int>("restart_simulation_at_end") == 1)
	    {
	        supervisor->simulationRevert();
	    }
	    else
	        supervisor->simulationQuit(EXIT_SUCCESS);    	
    }
	
}

//constructor
Experiment::Experiment(Rob * body) : BaseExperiment(body), body(body){}

void Experiment::step(){
	PhaseManager::update();
	//cout << body->Input[INPUT::THETA_TRUNK] << endl;
	body->step();
    FitnessManager::step(body);
   	LoggerManager::step(); 

    if(!Settings::isOptimizing()){
        body->plotTextInWindow(color);
    }
	
	//debug == true ? cout << "[ok] : one step (Experiment.cc)" << endl:true;
}

void Experiment::initiation(){
	cout << "--------------" << endl;
	color = 0xffffff; // color of the text in the 3d windows
	eventManager->set<bool>(STATES::IS_LAST_PHASE,false);
	PhaseManager::init(this->body);

	LoggerManager::loggers["MusculoSkeletalSystem"] = new MusculoSkeletalLogger(*body);
	LoggerManager::loggers["ReflexSystem"] = new ReflexControllerLogger(body->geyerController);
	LoggerManager::loggers["BodySystem"] = new BodyLogger(*body);
	LoggerManager::loggers["Perturbation"] = new PerturbationLogger(&(body->perturbator));
	LoggerManager::init();
	
}

void Experiment::termination(){
	cout << "--> trial ended" << endl;
	LoggerManager::end();	

	std::map<std::string,double> fitnesses = FitnessManager::buildFitness();
	// Evaluation
	if(Settings::get<string>("extract") != "off")
		FitnessManager::saveToFile();

	if(Settings::get<int>("extract_video") == 1)
		body->stopMovie();
	

    if(Settings::isOptimization())
    {
        optimizer &opti = tryGetOpti();
        opti.Respond(fitnesses);
    }
}


