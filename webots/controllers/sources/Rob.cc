#include "Rob.hh"
#include <sml/sml-tools/Settings.hh>
#include <webots/Node.hpp>
#include <webots/Receiver.hpp>
#include <webots/PositionSensor.hpp>
#include <webots/Motor.hpp>
#include <webots/Emitter.hpp>
#include <webots/Keyboard.hpp>
#include <boost/xpressive/xpressive.hpp>
#include <boost/property_tree/json_parser.hpp>
#include <sstream>

using namespace std;
using namespace webots;
using namespace boost::xpressive;

namespace nmm {
extern bool debug;
extern bool verbose;
extern SmlParameters parameters;
}
extern EventManager* eventManager;
using namespace nmm;

Keyboard *keyboard;

void Rob::ConstantInit(){
    //debug = true;
    //verbose = true;

    // Segment constant
    sml::Constant[CONSTANT::LENGTH_TRUNK] = 0.8;
    sml::Constant[CONSTANT::LENGTH_THIGH] = 0.5;
    sml::Constant[CONSTANT::LENGTH_SHIN] = 0.5;
    sml::Constant[CONSTANT::LENGTH_ANKLE] = 0.1;
    sml::Constant[CONSTANT::LENGTH_FOOT] = 0.16;
    sml::Constant[CONSTANT::WEIGHT_TRUNK] = 53.5;
    sml::Constant[CONSTANT::WEIGHT_THIGH] = 8.5;
    sml::Constant[CONSTANT::WEIGHT_SHIN] = 3.5;
    sml::Constant[CONSTANT::WEIGHT_ANKLE] = 0.0;
    sml::Constant[CONSTANT::WEIGHT_FOOT] = 1.25;
    sml::Constant[CONSTANT::MODEL_WEIGHT] = 70;
    sml::Constant[CONSTANT::MODEL_HEIGHT] = 1.8;


   if(Settings::get<int>("coman")){
    sml::Constant[CONSTANT::LENGTH_TRUNK] = 0.8;
    sml::Constant[CONSTANT::LENGTH_THIGH] = 0.5;
    sml::Constant[CONSTANT::LENGTH_SHIN] = 0.5;
    sml::Constant[CONSTANT::LENGTH_ANKLE] = 0.1;
    sml::Constant[CONSTANT::LENGTH_FOOT] = 0.16;
    sml::Constant[CONSTANT::WEIGHT_TRUNK] = 53.5;
    sml::Constant[CONSTANT::WEIGHT_THIGH] = 8.5;
    sml::Constant[CONSTANT::WEIGHT_SHIN] = 3.5;
    sml::Constant[CONSTANT::WEIGHT_ANKLE] = 0.0;
    sml::Constant[CONSTANT::WEIGHT_FOOT] = 1.25;
    sml::Constant[CONSTANT::MODEL_WEIGHT] = 70;
    sml::Constant[CONSTANT::MODEL_HEIGHT] = 0.9;
   }

   if(Settings::get<int>("verbose") == 1){
      nmm::verbose = true;
   }

   if(Settings::get<int>("debug") == 1){
      nmm::debug = true;
   }


}

void Rob::InputInit(){
        for (unsigned joint_pos=INPUT::FIRST_JOINT, joint=JOINT::FIRST_JOINT; joint_pos<=INPUT::LAST_JOINT; joint_pos++, joint++){
            getPositionSensor(JOINT::toString(joint)+"_POS")->enable(time_step);
        }
        for (unsigned sensor_force=INPUT::FIRST_FORCE_SENSOR; sensor_force<=INPUT::LAST_FORCE_SENSOR; sensor_force++){
            getTouchSensor(INPUT::toString(sensor_force))->enable(time_step);
        }
        if(Settings::get<int>("bumper") == 1){
            getTouchSensor("LEFT_BUMPER")->enable(time_step);
            getTouchSensor("RIGHT_BUMPER")->enable(time_step);
        }
        InputUpdate();
}
void Rob::InputUpdate(){

    // [ 0, 1, 2 
    //   3, 4, 5
    //   6, 7, 8 ]
    //
    // yaw=atan2(R(3),R(0));
    // pitch=atan2(-R(6),sqrt(R(7)^2+R(8)^2)));
    // roll=atan2(R(7),R(8));
    double const *R = supervisor::getFromDef(Settings::get<std::string>("robot_name"))->getOrientation();

    double yaw=atan2(R[3],R[0]);
    double pitch=atan2(-R[6],sqrt(R[7]*R[7]+R[8]*R[8]));
    double roll=atan2(R[7],R[8]);

    sml::Input[INPUT::THETA_TRUNK] = roll;
    sml::Input[INPUT::THETACOR_TRUNK] = yaw;

    for (unsigned joint_pos=INPUT::FIRST_JOINT, joint=JOINT::FIRST_JOINT; joint_pos<=INPUT::LAST_JOINT; joint_pos++, joint++){
         sml::Input[joint_pos] = getPositionSensor(JOINT::toString(joint)+"_POS")->getValue();
    }
    for (unsigned sensor_force=INPUT::FIRST_FORCE_SENSOR; sensor_force<=INPUT::LAST_FORCE_SENSOR; sensor_force++){
        sml::Input[sensor_force] = -getTouchSensor(INPUT::toString(sensor_force))->getValues()[2];
    }

    // if(Settings::get<int>("bumper") == 1){
    //     cout << getTouchSensor("RIGHT_BUMPER")->getValue() << endl;
    // }

    sml::Input[INPUT::NECK_Z]       = supervisor::getFromDef(Settings::get<std::string>("robot_name"))->getPosition()[0];
    sml::Input[INPUT::NECK_Y]       = supervisor::getFromDef(Settings::get<std::string>("robot_name"))->getPosition()[1];
    sml::Input[INPUT::NECK_X]       = supervisor::getFromDef(Settings::get<std::string>("robot_name"))->getPosition()[2];

	sml::Input[INPUT::TOE_LEFT_X] = supervisor::getFromDef("SENSOR_TOE_LEFT")->getPosition()[0];
	sml::Input[INPUT::TOE_LEFT_Y] = supervisor::getFromDef("SENSOR_TOE_LEFT")->getPosition()[1];
	sml::Input[INPUT::TOE_LEFT_Z] = supervisor::getFromDef("SENSOR_TOE_LEFT")->getPosition()[2];


    double * newObstaclePosition = new double[3];
    newObstaclePosition[0] = -0.08;
    newObstaclePosition[1] = 0.0;
    newObstaclePosition[2] = Settings::get<double>("obstacle_1_pos");
    if(supervisor::getFromDef("OBSTACLE_1")){
        supervisor::getFromDef("OBSTACLE_1")->getField("translation")->setSFVec3f(newObstaclePosition);
    }
    
    


	sml::Input[INPUT::TOE_RIGHT_X] = supervisor::getFromDef("SENSOR_TOE_RIGHT")->getPosition()[0];
	sml::Input[INPUT::TOE_RIGHT_Y] = supervisor::getFromDef("SENSOR_TOE_RIGHT")->getPosition()[1];
	sml::Input[INPUT::TOE_RIGHT_Z] = supervisor::getFromDef("SENSOR_TOE_RIGHT")->getPosition()[2];
	sml::Input[INPUT::HEEL_LEFT_X] = supervisor::getFromDef("SENSOR_HEEL_LEFT")->getPosition()[0];
	sml::Input[INPUT::HEEL_LEFT_Y] = supervisor::getFromDef("SENSOR_HEEL_LEFT")->getPosition()[1];
	sml::Input[INPUT::HEEL_LEFT_Z] = supervisor::getFromDef("SENSOR_HEEL_LEFT")->getPosition()[2];
	sml::Input[INPUT::HEEL_RIGHT_X] = supervisor::getFromDef("SENSOR_HEEL_RIGHT")->getPosition()[0];
	sml::Input[INPUT::HEEL_RIGHT_Y] = supervisor::getFromDef("SENSOR_HEEL_RIGHT")->getPosition()[1];
	sml::Input[INPUT::HEEL_RIGHT_Z] = supervisor::getFromDef("SENSOR_HEEL_RIGHT")->getPosition()[2];

    double lefthipx = supervisor::getFromDef("LEFT_LEG")->getPosition()[0];
    double lefthipy = supervisor::getFromDef("LEFT_LEG")->getPosition()[1];
    double lefthipz = supervisor::getFromDef("LEFT_LEG")->getPosition()[2];
    double righthipx = supervisor::getFromDef("RIGHT_LEG")->getPosition()[0];
    double righthipy = supervisor::getFromDef("RIGHT_LEG")->getPosition()[1];
    double righthipz = supervisor::getFromDef("RIGHT_LEG")->getPosition()[2];
	sml::Input[INPUT::MIDHIP_X] = lefthipx/2.0+righthipx/2.0;
	sml::Input[INPUT::MIDHIP_Y] = lefthipy/2.0+righthipy/2.0;
	sml::Input[INPUT::MIDHIP_Z] = lefthipz/2.0+righthipz/2.0;
}

void Rob::initKeyboardControl(){
    keyboard = getKeyboard();
    keyboard->enable(100);
    if(!Settings::isOptimization()){
        parameterControlVec.push_back("amp_change_reflex");
        parameterControlVec.push_back("amp_change_cpg");
        parameterControlVec.push_back("amp_change_cst");
        parameterControlVec.push_back("offset_change_reflex");
        parameterControlVec.push_back("offset_change_cpg");
        parameterControlVec.push_back("offset_change_cst");
        parameterControlVec.push_back("freq_change");
        //parameterControlVec.push_back("trunk_ref");
        parameterControlVec.push_back("stance_end");
        //parameterControlVec.push_back("swing_end");

        parameterControl["amp_change_reflex"]="A sen";
        parameterControl["offset_change_reflex"]="O sen";
        parameterControl["amp_change_cpg"]="A cpg";
        parameterControl["offset_change_cpg"]="O cpg";
        parameterControl["amp_change_cst"]="A bas";
        parameterControl["offset_change_cst"]="O cst";
        parameterControl["freq_change"]="Freq";
        parameterControl["stance_end"]="STend";
        //parameterControl["swing_end"]="SWend";
        //parameterControl["trunk_ref"]="Trunk ref";
    }
    control = 0;
    //parameterControlValue = ;
    counter = 0;
}

void Rob::initWebotsCommunication(){
    // -----------------------------------------------------------
    //get and enable receiver
    receiver = getReceiver("RECEIVER");
    receiver ->enable(time_step);
    emitter  = getEmitter("EMITTER");

    brainReceiver = getReceiver("BRAINRECEIVER");
    brainReceiver->enable(time_step);
    brainEmitter = getEmitter("BRAINEMITTER");
}

void Rob::init(){

    initKeyboardControl();

    //Communication initialisation
    initWebotsCommunication();
    //supervisor::step(time_step);
}


int Rob::step(){
    // FOR DEBUG PURPOSE ONLY
    static int f=0;
    if(f<1){
	if(nmm::verbose){
            parameters.printAll();
            eventManager->printAll();
            //settings::printAll();
        }
        f++;
    }
    /** -------------- listening for packets, updating robots state and sending packets ---- */
    listen_();
    print_debug("[ok] : listening (Rob.cc)");


    while (brainReceiver->getQueueLength()){
      this->rlActions.clear();
      const char *data = (const char*)(brainReceiver->getData());
      int i=0;
      bool gettingDecimals = false;
      bool gettingFloatings = false;
      stringstream decimals;
      stringstream floatings;
      bool decimalsIsEmpty = true;
      bool floatingsIsEmpty = true;


      while(data[i] != '\0'){
        double currentNumber;
        // If we are not trying to get decimals or floatings part
        if(!gettingDecimals && !gettingFloatings){
          // If the current char represents the beginning of a number
          // we start getting decimals
          if(data[i] == '-' || ((int)data[i] >= 48 && (int)data[i] <=57 )){
            //cout << "a(" << i << ") : " << data[i] << endl;
            decimals << data[i];
            gettingDecimals = true;
            decimalsIsEmpty = false;
          }
        }
        // If we are getting decimals but not floating
        else if(gettingDecimals && !gettingFloatings){
          // If its a number then we continue
          if((int)data[i] >= 48 && (int)data[i] <=57 ){
            //cout << "b(" << i << ") : " << data[i] << endl;
            decimals << data[i];
          }
          // If its not a number we stop getting decimals
          else{
            gettingDecimals = false;
            // If its a "." then we wait for floatings
            if(data[i] == '.'){
              gettingFloatings = true;
            }
          }
        }
        else if(!gettingDecimals && gettingFloatings){
          if((int)data[i] >= 48 && (int)data[i] <=57 ){
            //cout << "c(" << i << ") : " << data[i] << endl;
            floatings << data[i];
            floatingsIsEmpty = false;
          }
          else{
            gettingFloatings = false;
          }
        }

        if(!gettingDecimals && !gettingFloatings && !decimalsIsEmpty){
          //cout << "d(" << i << ") : " << data[i] << endl;
          // If we have collected a number
          // We combine floatings if present otherwise use .0
          if(!floatingsIsEmpty){
            decimals << "." << floatings.str();
            string strcpy = decimals.str();
            decimals.str("");
            floatings.str("");
            stringstream(strcpy) >> currentNumber;
            this->rlActions.push_back(currentNumber);
            decimalsIsEmpty = true;
            floatingsIsEmpty = true;
          }
          decimals.str("");
          floatings.str("");

          //cout << "New number : " << currentNumber << endl;
        }


        i++;
      }
      brainReceiver->nextPacket();
    }
    print_debug("[ok] : brain Receiver (Rob.cc)");
    sml::step();
    


    string sendString = sml::getSensoryInformation();
    brainEmitter->send(sendString.c_str(),sendString.size()*sizeof(char));


    //strncpy(sendChar, sendString.c_str(), sizeof(sendChar));
    //sendChar[sizeof(sendChar) - 1] = 0;
    //double array[5] = { 3.0, 0.1, 0.1, -5.5 };
    //brainEmitter->send(array,5*sizeof(double));

    //tab2[sizeof(tab2) - 1] = 0;
    // for(auto kv : rlActions){
    //   cout << kv << endl;
    // }

    int perturbation = Settings::get<int>("perturbation");
    int fixedViewPoint = Settings::get<int>("fixedViewPoint");
    int coman = Settings::get<int>("coman");
    bool finishedPert;
    bool startPert=false;
    bool finishedPertPrinted=false;
    finishedPert = true;

    int rlAction_index=0;
    for (
        unsigned joint=JOINT::FIRST_JOINT,
                 joint_tau=OUTPUT::FIRST_JOINT;
        joint_tau<=OUTPUT::LAST_JOINT;
        joint_tau++,
        joint++
        ){

        double torque;
        torque = sml::Output[joint_tau];
        if(
           perturbation ==1 &&
           perturbator.find(JOINT::Joints(joint))
           )
        {
            if(perturbator[JOINT::Joints(joint)]->doPerturbation() )
            {
               perturbator[JOINT::Joints(joint)]->updatePerturbation();
               torque += perturbator[JOINT::Joints(joint)]->getPerturbation();
               //if ( perturbator[JOINT::Joints(joint)]->getPerturbation() != 0.0)
               //cout << perturbator[JOINT::Joints(joint)]->getPerturbation() << endl;
               startPert = true;
               finishedPert = false;
            }
        }
        torque = max(min(torque,200.0),-200.0);
        getMotor(JOINT::toString(joint))->setTorque(torque);
    }


    if (perturbation == 1){
        if(finishedPert && !finishedPertPrinted && startPert){
            finishedPertPrinted = true;
            cout << "perturbation on one joint ended" << endl;
            //eventManager->set(STATES::STAY_IN_LOOP,false);
        }
    }

    emit_();
    print_debug("[ok] : emitting (Rob.cc)");
    if(fixedViewPoint != 0){
        if(coman)
        {
            fixedYAxis(0.67);
        }
        else
        {
            fixedYAxis(1.2);
        }
    }
    return 0;
}

void Rob::fixedYAxis(double Y){
    Node * viewpoint;
    Field * viewpoint_pos;
    viewpoint = this->getRoot()->getField("children")->getMFNode(1);
    viewpoint_pos = viewpoint->getField("position");


    double * newViewPointPos = new double[3];
    double * actualViewPointPos;

    actualViewPointPos = (double *)viewpoint_pos->getSFVec3f();
    newViewPointPos[0] = actualViewPointPos[0];
    newViewPointPos[1] = Y;
    newViewPointPos[2] = (eventManager->get<double>(STATES::POSITION_X));

    //if(viewpoint->getField("follow")->getSFString() == "")
    viewpoint_pos->setSFVec3f(newViewPointPos);
}
void Rob::listen_(){
    while (receiver->getQueueLength()){
        message_PtoW = (PtoW *)receiver->getData();
        if(Settings::get<string>("extract") == "force"){
            eventManager->dynamicState.getVector<double>("currentForce")[0] = message_PtoW->last_force_y;
            eventManager->dynamicState.getVector<double>("currentForce")[1] = message_PtoW->last_force_z;
            eventManager->dynamicState.getVector<double>("currentPos")[0] = message_PtoW->last_force_pos;;
            eventManager->dynamicState.getVector<double>("lastForce")[0] = eventManager->dynamicState.getVector<double>("currentForce")[0];
            eventManager->dynamicState.getVector<double>("lastForce")[1] = eventManager->dynamicState.getVector<double>("currentForce")[1];
            eventManager->dynamicState.getVector<double>("lastPos")[0] = eventManager->dynamicState.getVector<double>("currentPos")[0];
        }
        eventManager->set(STATES::SELF_CONTACT_COUNT,message_PtoW->self_contact_counter);
        receiver->nextPacket();
    }
}
void Rob::emit_(){
    //------------  we send a message to the physic plugin -------------
    message_WtoP.backward = Settings::get<int>("backward");
    if(Settings::get<string>("extract") == "force" || Settings::get<string>("extract") == "rp_eval"){
        message_WtoP.force_amplitude = Settings::get<double>("force");
    }
    emitter->send(&message_WtoP, sizeof(message_WtoP));
}

void Rob::stepParametersControl(){
    for(auto kv : parameters[1])
        parametersColor[kv.first] = 0x000000;

    // '1' -> 49

    // <- 14
    // ^  15
    // -> 16
    // |  17
    int currentKey = keyboard->getKey();
    if(currentKey > 48 && currentKey < 57){
        control = currentKey-48;
    }
    if(currentKey == 315 && control >= 0)
        control--;
    if(currentKey == 317 && control < (int)parameterControlVec.size())
        control++;
    if(currentKey == 70) fixedViewPoint = !fixedViewPoint;

    //if(currentKey != 0)
    //cout << "Key pressed : " << currentKey << endl;
    double step = 0.01;
    if(control >= 1 && control <= (int)parameterControlVec.size()){
        parameterControlName = parameterControlVec[control-1];
        parameterControlValue = &parameters[1][parameterControlName];
    }
    else{
        control = 0;
        parameterControlName="";
    }
    if(currentKey==316 && control != -1)
        *parameterControlValue += step;
    if(currentKey==314 && control != -1)
        *parameterControlValue -= step;
}

void Rob::plotTextInWindow(int color){
    char label[64];
    int black = 0x000000; // color of the text in the 3d windows
    int red = 0xFF0000; // color of the text in the 3d windows
    //int green = 0x00FF00; // color of the text in the 3d windows
    //int blue = 0x0000FF; // color of the text in the 3d windows
    if((int)(eventManager->get<double>(STATES::TIME)*1000) % 10 == 0){
        sprintf(label, "v=%.2f [m/s]\na=%.1lf [m/s2]\ncycle=%d cycle", eventManager->get<double>(STATES::IN_VELOCITY_FILTERED), eventManager->get<double>(STATES::IN_ACCELERATION_FILTERED),eventManager->get<int>(STATES::CYCLE_COUNT));
        this->setLabel(1, label, 0.01, 0.01, 0.08, color, 0.0);

        if(true)
        {
            sprintf(label, "d=%.1f [m]\nh=%.1f [m]",
            eventManager->get<double>(STATES::DISTANCE) , eventManager->get<double>(STATES::HEIGHT));
            this->setLabel(2, label, 0.01, 0.15, 0.08, color, 0.0);
        }
        else
        {
            sprintf(label, "%.1f [m], %.1f [m] \n%.0f [J] ",
            eventManager->get<double>(STATES::DISTANCE) , eventManager->get<double>(STATES::HEIGHT), eventManager->get<double>(STATES::ENERGY));
            this->setLabel(2, label, 0.01, 0.07, 0.08, color, 0.0);
        }
        double start = 0.3;

        int i=3;
        for(auto &kv : parameterControlVec){
            sprintf(label, "%s, %.2f", parameterControl[kv].c_str(),parameters[1][kv]);
            if(kv== parameterControlName)
                this->setLabel(i, label, 0.01, start, 0.08, black, 0.0);
            else
                this->setLabel(i, label, 0.01, start, 0.08, color, 0.0);
            start+=0.04;
            i++;
        }
    }
}
