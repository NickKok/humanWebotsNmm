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
//double start_time = 30.0;
extern double start_time;
using namespace std;

void webots_physics_step() {
   if(!ended){
	body_Regis_pos = dBodyGetPosition (body_Regis);
	body_Regis_vel = dBodyGetLinearVel(body_Regis);


	//--------- we get a message from webots ---------------------
  
  //--------- force generation ---------------------
  if(dWebotsGetTime()/1000.0 > start_time)
    webots_apply_random_force();
   }
   webots_get_message();
}




void webots_physics_init(dWorldID world_ref, dSpaceID space, dJointGroupID contact_joint_group) {
  
  ended = false;
  reinitialize();
  init_robots();  
}




void webots_physics_draw() {	
	
  webots_draw_force();
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




