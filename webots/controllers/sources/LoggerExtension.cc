#include "LoggerExtension.hh"

using namespace std;
extern EventManager * eventManager;
extern bool debug;


void BodyLogger::writeHeader(){
	*raw_files["trunk"] << "THETA_TRUNK" << " "
                       << "THETACOR_TRUNK" << " "
                           // << "trunk_x" << " "
                           // << "trunk_y" << " "
                           // << "trunk_z" << " "
                           // << "hip_left_x" << " "
                           // << "hip_left_y" << " "
                           // << "hip_left_z" << " "
                           // << "knee_left_x" << " "
                           // << "knee_left_y" << " "
                           // << "knee_left_z" << " "
                           // << "ankle_left_x" << " "
                           // << "ankle_left_y" << " "
                           // << "ankle_left_z" << " "
                           // << "toe_left_x" << " "
                           // << "toe_left_y" << " "
                           // << "toe_left_z" << " "
                           // << "heel_left_x" << " "
                           // << "heel_left_y" << " "
                           // << "heel_left_z" << " "
                           // << "hip_right_x" << " "
                           // << "hip_right_y" << " "
                           // << "hip_right_z" << " "
                           // << "knee_right_x" << " "
                           // << "knee_right_y" << " "
                           // << "knee_right_z" << " "
                           // << "ankle_right_x" << " "
                           // << "ankle_right_y" << " "
                           // << "ankle_right_z" << " "
                           // << "toe_right_x" << " "
                           // << "toe_right_y" << " "
                           // << "toe_right_y" << " "
                           // << "heel_right_x" << " "
                           // << "heel_right_y" << " "
                           // << "heel_right_y" << " "
                           ;
	
	*raw_files["distance"] << "distance";
	*raw_files["footfall"] << "left right";
	*raw_files["energy"] << "energy";
	

   *raw_files["grf"] 
         << "grf_X_left" << " " << "grf_Y_left" << " "
         << "grf_X_right" << " " << "grf_Y_right";

   *raw_files["touchSensor"] << 
      "sensor_heel_left"
      << " " << 
      "sensor_toe_left"
      << " " << 
      "sensor_heel_right"
      << " " << 
      "sensor_toe_right";

   *raw_files["bumper"] << 
      "bumper_left"
      << " " <<
      "bumper_right";

	for(auto &kv : raw_files)
		*kv.second << endl;
}

void BodyLogger::writeContent(){
	*raw_files["trunk"] << rob.Input[INPUT::THETA_TRUNK] << " " << rob.Input[INPUT::THETACOR_TRUNK];
                           // << rob.supervisor::getFromDef("REGIS")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("REGIS")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("REGIS")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("LEFT_THIGH")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("LEFT_THIGH")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("LEFT_THIGH")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("LEFT_SHIN")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("LEFT_SHIN")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("LEFT_SHIN")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("LEFT_FOOT")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("LEFT_FOOT")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("LEFT_FOOT")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("SENSOR_TOE_LEFT")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("SENSOR_TOE_LEFT")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("SENSOR_TOE_LEFT")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("SENSOR_HEEL_LEFT")->getPosition()[0]<< " "
                           // << rob.supervisor::getFromDef("SENSOR_HEEL_LEFT")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("SENSOR_HEEL_LEFT")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("RIGHT_THIGH")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("RIGHT_THIGH")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("RIGHT_THIGH")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("RIGHT_SHIN")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("RIGHT_SHIN")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("RIGHT_SHIN")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("RIGHT_FOOT")->getPosition()[0] << " "
                           // << rob.supervisor::getFromDef("RIGHT_FOOT")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("RIGHT_FOOT")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("SENSOR_TOE_RIGHT")->getPosition()[0]<< " "
                           // << rob.supervisor::getFromDef("SENSOR_TOE_RIGHT")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("SENSOR_TOE_RIGHT")->getPosition()[2] << " "
                           // << rob.supervisor::getFromDef("SENSOR_HEEL_RIGHT")->getPosition()[0]<< " "
                           // << rob.supervisor::getFromDef("SENSOR_HEEL_RIGHT")->getPosition()[1] << " "
                           // << rob.supervisor::getFromDef("SENSOR_HEEL_RIGHT")->getPosition()[2] << " " 
                           //<< endl;
	print_debug("--writing segments");

	*raw_files["distance"] << eventManager->get<double>(STATES::DISTANCE);
	*raw_files["footfall"] << rob.left_foot->inStance() << " " <<rob.right_foot->inStance();
	*raw_files["energy"] << eventManager->get<double>(STATES::ENERGY);

   // GRF : 
   
   //         local coordinate frame of the leg. 
   //         X axis : frontal plane (left-right), when looking back on the positive to the left
   //         Y axis : sagital plane (back-front), positive forward  
   //         Z axis : vertical plane (bottom-top), positive downward
   
   // What we want : 
   
   //         X' axis : positive forward
   //         Y' axis : positive upward 
   
   //         Y' = -Z
   //         X' = Y 

   *raw_files["touchSensor"] << 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_LEFT))->getValues()[2]
      << " " << 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_LEFT))->getValues()[2]
      << " " << 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_RIGHT))->getValues()[2]
      << " " << 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_RIGHT))->getValues()[2];

	*raw_files["grf"] << 
		rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_LEFT))->getValues()[1] 
		+
		rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_LEFT))->getValues()[1] 
		<< " " << 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_LEFT))->getValues()[2] 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_LEFT))->getValues()[2] 
      << " " << 
      rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_RIGHT))->getValues()[1] 
      +
      rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_RIGHT))->getValues()[1] 
      << " " << 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_RIGHT))->getValues()[2] 
      -rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_RIGHT))->getValues()[2]; 

   if(Settings::get<int>("bumper") == 1){
      *raw_files["bumper"] << 
         rob.getTouchSensor("LEFT_BUMPER")->getValue()
         << " " << 
         rob.getTouchSensor("RIGHT_BUMPER")->getValue();
   }

	for(auto &kv : raw_files)
		*kv.second << endl;


   // cout << 
   //          rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_RIGHT))->getValues()[0]
   //          +
   //          rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_RIGHT))->getValues()[0]
   //          << " " <<
   //          rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_RIGHT))->getValues()[1] 
   //          +
   //          rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_TOE_RIGHT))->getValues()[1]
   //          << " " <<
   //          rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_RIGHT))->getValues()[2] 
   //          +
   //          rob.getTouchSensor(INPUT::toString(INPUT::SENSOR_HEEL_RIGHT))->getValues()[2] 
   //          <<
   //       endl;
}

void PerturbationLogger::writeHeader(){
   //cout << "perturbationLogger writeHeader: " << perturbator->getHeader() << endl;
   //cout << "perturbationLogger writeHeader: " << perturbator->getHeader() << endl;
	//*raw_files["perturbation"] << "hello" << endl;
   *raw_files["perturbation"] << perturbator->getHeader();
	for(auto &kv : raw_files) 
		*kv.second << endl;
}

void PerturbationLogger::writeContent(){
	*raw_files["perturbation"] << perturbator->getRow();
	for(auto &kv : raw_files)
	  *kv.second << endl;
}

