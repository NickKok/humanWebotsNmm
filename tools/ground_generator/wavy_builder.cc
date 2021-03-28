#include <Python.h>
#include <iostream>
#include <string>
#include <optimization/webots.hh> //to include the optimizer framework
#include <unistd.h>
#define GetCurrentDir getcwd


using namespace optimization::messages::task;
using namespace std;

string getFullPath(){
	char buf[FILENAME_MAX];
	if (!GetCurrentDir(buf, sizeof(buf)))
		exit;
	std::string str(buf, std::find(buf, buf + FILENAME_MAX, '\0'));
	return str;
	
}

string int2str(int Number){
	return static_cast<ostringstream*>( &(ostringstream() << Number) )->str();
}
int main(int argc, char *argv[])
{
	string data_path = argv[3];
	string world_path = argv[2];
	string generator_path = argv[1];
	
	optimization::TaskReader reader = optimization::TaskReader(cin);
	optimization::messages::task::Task &task = reader.Task();
	
	long unikid = task.uniqueid();
	//long unikid = 0;

	string exec = generator_path + "/wavy_ground/wavy_ground_generator.py" + " " + int2str(unikid) + ".wbt -o " + world_path + " -d " + data_path + "/" +" -p 15 -w 30 -r 1 -m 0.1 ";


	int out = system(exec.c_str());
	

	cout << world_path << unikid << ".wbt" << endl;

	return 0;
}
