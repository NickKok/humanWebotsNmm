#ifndef __Rob_HH__
#define __Rob_HH__


#include <string>
#include <math.h>
#include <vector>
#include <fstream>
#include <map>

//#include <boost/algorithm/string.hpp>


#include <webots/Supervisor.hpp>
#include <webots/TouchSensor.hpp>

#include <sml/types/types.h>
#include <sml/sml-tools/PerturbationManager.hh>
#include <sml/sml-tools/Settings.hh>
#include <sml/body/GeyerSml.hh>

#define DEBUG 0


typedef struct{
  int detect_new_fall;  //if we detect a new fall
  int is_in_lift_mode;
  int self_contact_counter;
  double last_force_y;
  double last_force_z;
  double last_force_pos;
} PtoW; //from Physic plugin to Webots

typedef struct{
//  int reinitialisation;
  int backward;
  double force_amplitude;
} WtoP; //from Webots to Physic plug in

typedef struct{
  double muscle_signal;
  double muscle_activity;
} WtoM; //from Webots to Raw supervisor

class Rob: public webots::Supervisor, public GeyerSml
{
private:
    int time_step;
    bool fixedViewPoint;
    int counter;

    void ConstantInit();
    void InputInit();
    void InputUpdate();

    std::vector<std::string> parameterControlVec;
    std::map<std::string, std::string> parameterControl;
    int control;
    double* parameterControlValue;
    std::string parameterControlName;
    std::map<std::string, int> parametersColor;

public:
    typedef Supervisor supervisor;
    typedef GeyerSml sml;
    int step();

    //Receiver

    webots::Receiver* receiver;
    PtoW *message_PtoW;
    webots::Emitter* emitter;
    WtoP message_WtoP;

    // C++ communication with RLbrain
    webots::Receiver* brainReceiver;
    webots::Emitter* brainEmitter;
    WtoM message_WtoM;


  //-----------------------------------

    //constructor
    Rob(): GeyerSml(),time_step(Settings::get<int>("time_step")){
        sml::init();
        init();
        }

    //destructor
    //~Rob();
    void initKeyboardControl();
    void initWebotsCommunication();
    void init();

    void listen_();
    void emit_();
    void fixedYAxis(double Y);
    void plotTextInWindow(int color);
    void stepParametersControl();
};

#endif /* __ROB_HH__ */
