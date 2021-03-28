#include "config.h"
void reinitialize();
using namespace std;

//----------- METHODE ----------------------------
extern double ended;
double rnd(){
	return (double)rand()/RAND_MAX;
}

double round(double num) {
    return (num > 0.0) ? floor(num + 0.5) : ceil(num - 0.5);
}

typedef struct{
	int detect_new_fall;  //if we detect a new fall
	int is_in_lift_mode;
	double last_force_y;
	double last_force_z;
	double last_force_pos;
} PtoW; //from Physic plugin to Webots


typedef struct{
	//int reinitialisation;
	int backward;
    double force_amplitude;
} WtoP; //from Webots to Physic plug in



static PtoW message_PtoW;
static WtoP* message_WtoP;

static dBodyID  body_Hip_R;
static dBodyID  body_Knee_R;
static dBodyID  body_Ankle_R;
static dBodyID  body_Hip_L;
static dBodyID  body_Knee_L;
static dBodyID  body_Ankle_L;
static dBodyID  body_Regis;
static dBodyID  body_reference;
static dBodyID  body_slide;

static dJointID joint_fixed;
static dJointID joint_slide_Z;
static dJointID joint_PR_Y;


static const dReal* body_Regis_pos; //position (X,Y,Z) of iCub body in space
static const dReal* body_Regis_vel; //linear velocity

// some parameters
static double time_falling = -100000.0; //time the fall is detected


//static double time_backward = 0.0; //time the backward behavior is detected

static double min_velocity = 1.0; //[m/s]

static double limit_height = 1.0;



/***
*
*
*
****/
void webots_physics_init(dWorldID world, dSpaceID space, dJointGroupID contactJointGroup) {
	
	ended = false;
	reinitialize();
	//find body in the scene tree
	body_Regis = dWebotsGetBodyFromDEF("REGIS");
	if(body_Regis == NULL){ //we check we found the body
		dWebotsConsolePrintf("ERROR: could not find the body_Regis \n    In physic plug-in.\n");
		return;
	}
	
	body_Hip_R = dWebotsGetBodyFromDEF("HIP_RIGHT");
	if(body_Hip_R == NULL){ //we check we found the body
		dWebotsConsolePrintf("ERROR: could not find the body_Hip_R \n    In physic plug-in.\n");
		return;
	}
	
	body_Knee_R = dWebotsGetBodyFromDEF("KNEE_RIGHT");
	if(body_Knee_R == NULL){ //we check we found the body
		dWebotsConsolePrintf("ERROR: could not find the body_Knee_R \n    In physic plug-in.\n");
		return;
	}
	
	body_Ankle_R = dWebotsGetBodyFromDEF("ANKLE_RIGHT");
	if(body_Ankle_R == NULL){ //we check we found the body
		dWebotsConsolePrintf("ERROR: could not find the body_Ankle_R \n    In physic plug-in.\n");
		return;
	}
	
	body_Hip_L = dWebotsGetBodyFromDEF("HIP_LEFT");
	if(body_Hip_L == NULL){ //we check we found the body
		dWebotsConsolePrintf("ERROR: could not find the body_Hip_L \n    In physic plug-in.\n");
		return;
	}
	
	body_Knee_L = dWebotsGetBodyFromDEF("KNEE_LEFT");
	if(body_Knee_L == NULL){ //we check we found the body
		dWebotsConsolePrintf("ERROR: could not find the body_Knee_L \n    In physic plug-in.\n");
		return;
	}
	
	body_Ankle_L = dWebotsGetBodyFromDEF("ANKLE_LEFT");
	if(body_Ankle_L == NULL){ //we check we found the body
		dWebotsConsolePrintf("ERROR: could not find the body_Ankle_L \n    In physic plug-in.\n");
		return;
	}
	
	//we creat a body that will be attached on the world with a fixed joint
	body_reference = dBodyCreate (world);
	joint_fixed    = dJointCreateFixed (world, 0);   //we creat a fixed joint
	dJointAttach   ( joint_fixed, body_reference, 0); //we attache the body_reference to the world with the joint_fixed
	dJointSetFixed ( joint_fixed);                    //we initialise the fixed joint

	//we creat a body that will be attached on the reference body with a slider joint
	body_slide          = dBodyCreate(world);
	joint_slide_Z       = dJointCreateSlider(world,0);
	dJointAttach        ( joint_slide_Z, body_reference, body_slide);
	dJointSetSliderAxis ( joint_slide_Z, 0, 0, 1);
	dJointSetSliderParam (joint_slide_Z, dParamVel  , -min_velocity);
	dJointSetSliderParam( joint_slide_Z, dParamFMax , 0.0); //we set the maximum force the slider can performe
	//we attache the slide body to the iCub with a Prismatic and Rotoide joint
	joint_PR_Y           = dJointCreatePR (world, 0);
	if(false){
	dJointAttach        ( joint_PR_Y, body_slide, body_Regis);
	dJointSetPRAxis1    ( joint_PR_Y, 0, 1, 0); //prismatic articulation
	//dJointSetPRAxis2    ( joint_PR_Y, 1, 0, 0); //rotoide articulation

	}
	
}







