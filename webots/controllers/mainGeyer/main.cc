#include <stdio.h>
#include <sml/sml.hh>

#include "../sources/Experiment.hh"
#include <string>
#include <vector>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>




using namespace std;

CentralClock * centralclock;
namespace nmm {
bool debug=false;
bool verbose=false;
SmlParameters parameters;
}
using namespace nmm;
std::map<std::string, double_int_string> Settings::sets;


void loadControlParametersName(std::map<std::string, std::map<std::string, double> >& param);
void loadGeyerParametersName(std::map<std::string, std::map<std::string, double > > & param);

int main(int argc, char* argv[])
{
	if(argc >= 2)
		Settings::filename = argv[1];
	if(argc >= 3){
		Settings::prefix = argv[2];
	}
	Settings settings;
	if(argc >= 4){
		Settings::set<std::string>("robot_name", argv[3]);
	}
	if(Settings::get<int>("log_webots") == 2){
		ofstream out("../../../log/webots_log.txt", ios::app);
		streambuf *coutbuf = cout.rdbuf(); //save old buf
		cout.rdbuf(out.rdbuf()); //redirect std::cout to out.txt!
	}
	srand(time(0));
	
	cout << Settings::prefix << endl;
	
	centralclock = new CentralClock(parameters[1]["freq_change"]);
        cout << "Creating ROBOT" << endl;
        Rob *Regis = new Rob();
        cout << "ROBOT created" << endl;
        cout << "Creating EXPERIMENT" << endl;
	Experiment exp(Regis);
        cout << "Running EXPERIMENT" << endl;
	exp.run();
    delete Regis;
	return 0;
}
