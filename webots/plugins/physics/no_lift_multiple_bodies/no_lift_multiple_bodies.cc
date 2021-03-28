/*
 * File: plugin restraining the body to the sagital plan
 * Date: 28.09.2015
 * Description: 
 * Author: Florin Dzeladini
 * Modifications: 
 */

#include <ode/ode.h>
#include <plugins/physics.h>
#include "../lib/init.hh"
#include "../lib/random_perturbation.hh"
//double start_time = 30.0;
extern double start_time;

void webots_physics_step() {
   if(!ended){
    body_Regis_pos = dBodyGetPosition (body_Regis);
    body_Regis_vel = dBodyGetLinearVel(body_Regis);


    int i=0;
    dBodyID body1=0;
    dBodyID body2=0;
    double pos1=0.0;
    double pos2=0.0;

    double x = 0.0;
    for(auto &kv: bodies){
      if(i==0) {
        body1 = kv.second;
        pos1 = dBodyGetPosition (kv.second)[2];
      }
      else{
        pos2 = pos1;
        body2 = body1;
        pos1 = dBodyGetPosition (kv.second)[2];
        body1 = kv.second;
        x=pos1-pos2;


        if( (int)(dWebotsGetTime())%10==0){
          dWebotsConsolePrintf((kv.first + " position=%f\n").c_str(),x);
        }
//21.610 : position 2.441, k=1
//         position 2.27,  k=10          

    //    double force = pos1-pos2)
    //    dWebotsConsolePrintf((kv.first + " force=%f\n").c_str(),k*(x-2.0));

        double flag=1;
        if( pos2 < pos1  ){
            flag=-1;
        }



        double force = 20*(x-2.3);

        static bool flag2=false;
        if(dWebotsGetTime()/1000.0 > 4.0){
          if(!flag2){
            flag2=true;
            dWebotsConsolePrintf("Attraction starts\n");
          }

        dBodyAddForceAtRelPos(
           body1, 
           0, 0, flag*force,
           0, 0, 0
        );

        dBodyAddForceAtRelPos(
           body2, 
           0, 0, -flag*force,
           0, 0, 0
        );

        }

      }
      i++;
      
    }


    //--------- we get a message from webots ---------------------
  
  //--------- force generation ---------------------
  if(dWebotsGetTime()/1000.0 > start_time){
    //webots_apply_random_force();
  }
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




