/*
 * File: my first own physic plug-in !         
 * Date: 25.11.2010     
 * Description: 
 * Author: Steve Berger
 * Modifications: 
 */

#include <ode/ode.h>
#include <plugins/physics.h>
#include "../lib/init.hh"
#include "../lib/random_perturbation.hh"




void webots_physics_init() {
  
  ended = false;
  //find body in the scene tree
  body_Regis = dWebotsGetBodyFromDEF("REGIS");
  if(body_Regis == NULL){ //we check we found the body
    dWebotsConsolePrintf("ERROR: could not find the body_Regis \n    In physic plug-in.\n");
    return;
  }
  

  lift(body_Regis);
}





void webots_physics_step() {

	body_Regis_pos = dBodyGetPosition (body_Regis);
	body_Regis_vel = dBodyGetLinearVel(body_Regis);

	//--------- we get a message from webots ---------------------
	chosen_time_lift = minimum_time_lift + rnd()*(maximum_time_lift - minimum_time_lift); //we set how long we will lift the robot
		lift_force = 40000.0 * (1.95 - body_Regis_pos[1]) - 10000.0 * body_Regis_vel[1];
		dBodyAddForce (body_Regis, 0.0, lift_force, 0.0);
		
		dJointSetPRParam( joint_PR_Y, dParamLoStop2 ,  -0.105);
		dJointSetPRParam( joint_PR_Y, dParamHiStop2 ,  -0.105); //we bring the body rotation to a fixe angle
		
		dJointSetSliderParam( joint_slide_Z, dParamFMax , force_push_forward); //we force the body to a fixed speed
		
		message_PtoW.detect_new_fall = 0;
		message_PtoW.is_in_lift_mode = 1;
		
		// ---------------------------------------------------------------------
		
		//we send the message to Webots
		dWebotsSend(1, &message_PtoW, sizeof(message_PtoW)); 
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

void webots_physics_cleanup() {
	/*
	 * Here you need to free any memory you allocated in above, close files, etc.
	 * You do not need to free any ODE object, they will be freed by Webots.
	 */
}








