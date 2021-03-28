/*
 * File: my first own physic plug-in !         
 * Date: 25.11.2010     
 * Description: 
 * Author: Steve Berger
 * Modifications: 
 */

#include <ode/ode.h>
#include <plugins/physics.h>

typedef struct{
	int detect_new_fall;  //if we detect a new fall
	int is_in_lift_mode;
} PtoW; //from Physic plugin to Webots


typedef struct{
	int reinitialisation;
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
static dJointID joint_slide_X;
static dJointID joint_PR_Y;


static const dReal* body_Regis_pos; //position (X,Y,Z) of iCub body in space
static const dReal* body_Regis_vel; //linear velocity

// some parameters
static double desired_height = 1.44; //Y limit the iCub can reach without help
static double desired_speed = 0.3;
static double time_falling = 0.0; //time the fall is detected

static double minimum_time_lift = 4000.0;//[ms] is the time length we help the robot after a fall is detected
static double maximum_time_lift = 5000.0;
static double chosen_time_lift  = 5.0;
static dReal  lift_force;
static dReal  push_force;


static double min_velocity = 1.0; //[m/s]

static dReal  force_push_forward = 0.0;

static double draw_biais_Y = 0.8;
static double draw_biais_Z = -0.5;



//----------- METHODE ----------------------------

double rnd(){
	return (double)rand()/RAND_MAX;
}



void webots_physics_init(dWorldID world, dSpaceID space, dJointGroupID contactJointGroup) {

	
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
	joint_slide_X       = dJointCreateSlider(world,0);
	joint_slide_Z       = dJointCreateSlider(world,0);
	dJointAttach        ( joint_slide_Z, body_reference, body_slide);
	//dJointAttach        ( joint_slide_X, body_reference, body_slide);
	dJointSetSliderAxis ( joint_slide_Z, 0, 0, 1);
	dJointSetSliderAxis ( joint_slide_X, 1, 0, 0);
	dJointSetSliderParam (joint_slide_Z, dParamVel  , -min_velocity);
	dJointSetSliderParam( joint_slide_Z, dParamFMax , 0.0);
	dJointSetSliderParam (joint_slide_X, dParamVel  , -min_velocity);
	dJointSetSliderParam( joint_slide_X, dParamFMax , 0.0);
	
	//we attache the slide body to the iCub with a Prismatic and Rotoide joint
	joint_PR_Y           = dJointCreatePR (world, 0); 
	dJointAttach        ( joint_PR_Y, body_slide, body_Regis);
	dJointSetPRAxis1    ( joint_PR_Y, 0, 1, 0); //prismatic articulation
	dJointSetPRAxis2    ( joint_PR_Y, 1, 0, 0); //rotoide articulation
	
}















void webots_physics_step() {

	body_Regis_pos = dBodyGetPosition (body_Regis);
	body_Regis_vel = dBodyGetLinearVel(body_Regis);

	//--------- we get a message from webots ---------------------
	int size;
	chosen_time_lift = minimum_time_lift + rnd()*(maximum_time_lift - minimum_time_lift); //we set how long we will lift the robot
	message_WtoP = dWebotsReceive(&size);
	time_falling = 0.0;
	if(message_WtoP==0)
		dWebotsConsolePrintf("\n\nError in the physic plugin:\n   message_WtoP is empty\n\n");
	
	else
	{
		push_force = 1000* ( desired_speed - body_Regis_vel[2]);
		lift_force = 10000.0 * (desired_height - body_Regis_pos[1]) - 1000.0 * body_Regis_vel[1];
		//dBodyAddForce (body_Regis, -0.15, lift_force, -0.15);
		//dWebotsConsolePrintf("%f\n", push_force);
		dBodyAddForce (body_Regis, -0.15, lift_force, push_force);
		dJointSetPRParam( joint_PR_Y, dParamLoStop2 ,  -0.0);
		dJointSetPRParam( joint_PR_Y, dParamHiStop2 ,  -0.0); //we bring the body rotation to a fixe angle
		
		dJointSetSliderParam( joint_slide_Z, dParamFMax , push_force); //we force the body to a fixed speed
		
		message_PtoW.detect_new_fall = 0;
		message_PtoW.is_in_lift_mode = 1;
		
		// ---------------------------------------------------------------------
		
		//we send the message to Webots
		dWebotsSend(1, &message_PtoW, sizeof(message_PtoW)); 
	}
}








void webots_physics_draw() {

	body_Regis_pos = dBodyGetPosition (body_Regis);
	body_Regis_vel = dBodyGetLinearVel(body_Regis);
	
	
	// draw a point
	glPointSize(8.0);
	glBegin(GL_POINTS);
		glVertex3f(body_Regis_pos[0], body_Regis_pos[1] + draw_biais_Y, body_Regis_pos[2] + draw_biais_Z);
	glEnd();

	
	// setup draw style
	glDisable(GL_LIGHTING);
	glLineWidth(3.0);







	// --------------- LIFT -------------------------------------------------

	
	//if we are in lift mode
	if(dWebotsGetTime() - time_falling < chosen_time_lift){
	
		// draw a red forward line
		glBegin(GL_LINES);
			glColor3f(1, 0, 0);
			glVertex3f(body_Regis_pos[0], body_Regis_pos[1] + draw_biais_Y, body_Regis_pos[2] + draw_biais_Z);
			glVertex3f(body_Regis_pos[0], body_Regis_pos[1] + draw_biais_Y, body_Regis_pos[2] + force_push_forward / 20000.0 + draw_biais_Z);
		glEnd();
		// draw a vertical line
		glBegin(GL_LINES);
			glColor3f(1, 0, 1);
			glVertex3f(body_Regis_pos[0], body_Regis_pos[1] + draw_biais_Y                    , body_Regis_pos[2] + draw_biais_Z);
			glVertex3f(body_Regis_pos[0], body_Regis_pos[1] + lift_force/1000.0 + draw_biais_Y, body_Regis_pos[2] + draw_biais_Z);
		glEnd();
		
		
	}
	


}

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
	return 0;
}

void webots_physics_cleanup() {
	/*
	 * Here you need to free any memory you allocated in above, close files, etc.
	 * You do not need to free any ODE object, they will be freed by Webots.
	 */
}








