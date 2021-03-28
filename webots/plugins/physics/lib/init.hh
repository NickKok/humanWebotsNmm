#ifndef __Init_HH__
#define __Init_HH__

#include "config.h"
#include <sstream>
#include <map>

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
         int self_contact_counter;
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

static std::map<std::string, dBodyID> bodies;
static dBodyID  body_Regis;
static dBodyID  body_reference;
static dBodyID  body_slide;

static dJointID joint_fixed;
static dJointID joint_slide_Z;
static dJointID joint_PR_Y;


static const dReal* body_Regis_pos; //position (X,Y,Z) of iCub body in space
static const dReal* body_Regis_vel; //linear velocity



//static double time_backward = 0.0; //time the backward behavior is detected

static double min_velocity = 1.0; //[m/s]
static double limit_height = 2.55;//[CHANGE]: 1.0;
static double time_falling = -100000.0;//0.0; //time the fall is detected

static double minimum_time_lift = 4000.0;//[ms] is the time length we help the robot after a fall is detected
static double maximum_time_lift = 5000.0;
static double chosen_time_lift  = 5.0;
static dReal  lift_force;

static dReal  force_push_forward = 0.0;
static double draw_biais_Y = 0.8;
static double draw_biais_Z = -0.5;
static int contact_number = 0;

static dGeomID ground = NULL; 
static dGeomID left_foot = NULL; 
static dGeomID right_foot = NULL; 
static dGeomID  left_bumper;
static dGeomID  right_bumper;



int webots_physics_collide(dGeomID g1, dGeomID g2) {
	/*
	 * This function needs to be implemented if you want to overide Webots collision detection.
	 * It must return 1 if the collision was handled and 0 otherwise. 
	 * Note that contact joints should be added to the contactJointGroup, e.g.
	 *   n = dCollide(g1, g2, MAX_CONTACTS, &contact[0].geom, sizeof(dContact));
	 *   ...
	 *   dJointCreateContact(world, contactJointGroup, &contact[i])
	 *   dJointAttach(contactJoint, body1, body2);
	 *   ...
	 */
          dBodyID b1 = dGeomGetBody(g1);
          dBodyID b2 = dGeomGetBody(g2);
        
          int ground_id = 0;
          int left_bumper_id = 0;
          int right_bumper_id = 0;
        
          if(dAreGeomsSame(g1, ground)){
            ground_id = 1;
          }
          if(dAreGeomsSame(g2, ground)){
            ground_id = 2;
          }
          if(dAreGeomsSame(g1, left_bumper)){
            left_bumper_id = 1;
          }
          if(dAreGeomsSame(g2, left_bumper)){
            left_bumper_id = 2;
          }
          if(dAreGeomsSame(g1, right_bumper)){
            right_bumper_id = 1;
          }
          if(dAreGeomsSame(g2, right_bumper)){
            right_bumper_id = 2;
          }
          
          if(ground_id != 0 && left_bumper_id != 0){
            return 1;
          }
          if(ground_id != 0 && right_bumper_id != 0){
            return 1;
          }
    
    
          if(dAreGeomsSame(g1, ground) || dAreGeomsSame(g2, ground)){
             return 0;
          }
          else if(
            (dAreGeomsSame(g1, left_foot) || dAreGeomsSame(g2, left_foot)) && 
            !(dAreGeomsSame(g1, right_foot) || dAreGeomsSame(g2, right_foot))
          ){
             return 0;
          }
          else if(
            (dAreGeomsSame(g1, right_foot) || dAreGeomsSame(g2, right_foot)) && 
            !(dAreGeomsSame(g1, left_foot) || dAreGeomsSame(g2, left_foot))
          ){
             return 0;
          }
          else{
             contact_number += 1;
             return 0;
          }
          return 0;
}



void sagital(dBodyID body_Regis){
	//we creat a body that will be attached on the world with a fixed joint
	dWorldID world = dBodyGetWorld(body_Regis);
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
	dJointAttach        ( joint_PR_Y, body_slide, body_Regis);
	dJointSetPRAxis1    ( joint_PR_Y, 0, 1, 0); //prismatic articulation
	//dJointSetPRAxis2    ( joint_PR_Y, 1, 0, 0); //rotoide articulation
}
void lift(dBodyID body_Regis){
	//we creat a body that will be attached on the world with a fixed joint
	dWorldID world = dBodyGetWorld(body_Regis);
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
	dJointAttach        ( joint_PR_Y, body_slide, body_Regis);
	dJointSetPRAxis1    ( joint_PR_Y, 0, 1, 0); //prismatic articulation
	dJointSetPRAxis2    ( joint_PR_Y, 1, 0, 0); //rotoide articulation		
	
}




void init_robots(){
  bool found=false;
  dBodyID  tmp_body_Regis;

  tmp_body_Regis = dWebotsGetBodyFromDEF("REGIS");
  right_bumper = dWebotsGetGeomFromDEF("RIGHT_BUMPER");
  left_bumper = dWebotsGetGeomFromDEF("LEFT_BUMPER");
  ground = dWebotsGetGeomFromDEF("GROUND");
  if(tmp_body_Regis != NULL){ //we check we found the body
  	dWebotsConsolePrintf("Found body REGIS\n");
  	sagital(tmp_body_Regis);
  	bodies["REGIS"] = tmp_body_Regis;
  	body_Regis = tmp_body_Regis;
  	found=true;
  }
  
  for(int i=1; i<10; i++){
  	std::stringstream sstm;
	sstm << i;
  	tmp_body_Regis = dWebotsGetBodyFromDEF(("REGIS" + sstm.str()).c_str());
  	if(tmp_body_Regis != NULL){ //we check we found the body
  		dWebotsConsolePrintf(("Found body REGIS" + sstm.str() + "\n").c_str());
  		bodies[("REGIS" + sstm.str()).c_str()] = tmp_body_Regis;
  		sagital(tmp_body_Regis);
  		body_Regis = tmp_body_Regis;
  		found=true;
  	}
  }
  
  if(!found){ //we check we found the body
    //dWebotsConsolePrintf("ERROR: could not find the body_Regis \n    In physic plug-in.\n");
    return;
  }
}





#endif