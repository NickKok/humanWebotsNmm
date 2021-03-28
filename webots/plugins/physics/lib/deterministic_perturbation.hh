#include <random>
#include <boost/random/normal_distribution.hpp>
#include <boost/math/distributions/fisher_f.hpp>
#include <boost/math/special_functions/gamma.hpp>
#include <boost/random.hpp>


double ended=false;
double start_time=10;


/****
*
*
*   RANDOM FORCE PERTURBATION GENERATOR HEADER
*
*
***/
static dReal  mean_amplitude = 10.0;
static dReal sigma_amplitude = 1;
// force angle with the perpendicular of the gravity (normal distribution)
static dReal  mean_angle = 0.0;
static dReal sigma_angle = 0.8;
// force position in the y-axis (vertical) (normal distribution)
static dReal  mean_position = 0.0;
static dReal  sigma_position = 1.0;
// force duration (F-distribution)
static dReal d1_duration = 50;
static dReal d2_duration = 50;
// force frequency  (G-distribution)
static dReal k=1.0;
static dReal sigma = 2.0;
// forward push probability
static dReal backward_prob=0.0;


typedef boost::mt19937 RandomGenerator;
static RandomGenerator rng(static_cast<unsigned> (time(0)));

// Gaussian
typedef boost::normal_distribution<double> NormalDistribution;
typedef boost::variate_generator<RandomGenerator&, \
                         NormalDistribution> GaussianGenerator;

static NormalDistribution nd_amplitude(mean_amplitude, sigma_amplitude);
static NormalDistribution nd_angle(mean_angle, sigma_angle);
static NormalDistribution nd_position(mean_position, sigma_position);

static GaussianGenerator var_nor_amplitude(rng, nd_amplitude);
static GaussianGenerator var_nor_angle(rng, nd_angle);
static GaussianGenerator var_nor_position(rng, nd_position);
  

// Fisher
std::fisher_f_distribution<double> fisher_distribution(d1_duration,d2_duration);
std::default_random_engine generator;

// Gamma
std::gamma_distribution<> gamma_dist(k, sigma);

static dReal now = 0.0;
dReal get_force_amplitude(){
  return var_nor_amplitude()*(1-exp(-(now-start_time)/(15.0)));
  //return var_nor_amplitude()*(now-start_time)/30.0;
}

dReal get_force_angle(){
  return var_nor_angle();
}
boost::uniform_01<> random_one;
dReal get_force_position(){
  //return var_nor_position();
  return random_one(rng);
}



dReal get_push_duration(){
  //return 0.0;
  return fisher_distribution(generator)/4.;
}
dReal get_nonpush_duration(){
  return 2*fisher_distribution(generator);
  //return gamma_dist(rng);
}



static dReal Force_x=0.0;
static dReal Force_y=0.0;
static dReal Force_z=10;
static dReal Point_x=0.0;
static dReal Point_y=-0.3;
static dReal Point_z=0.0;

static dReal segment_height = 0.6;


void update_force_application(){
  double z = get_force_position();
  
  Point_y = segment_height/2.0*z;
  //printf("%f\n", Point_y);
}
static dReal force_amplitude;
void update_force(){
  
  //printf("alpha %f\n", alpha*180.0/3.14);
  Force_z = force_amplitude;
  Force_y = 0.0;
  update_force_application();
}


static bool pushing = false;
static bool pushed = false;
static dReal last_pushing_time = start_time;
static dReal pushing_duration = 0.0;
dReal non_pushing_duration = 0.0;

string test = "you didn't falled";
void reinitialize(){
	last_pushing_time = now;
	pushing_duration = 0.0;
	non_pushing_duration = 0.0;
	pushing=false;
}

void webots_apply_random_force(){
  now = (double)dWebotsGetTime()/1000.0;
  if(!pushing && !pushed){
    if(now-last_pushing_time > non_pushing_duration){
        update_force();
        pushing_duration = 0.10;//get_push_duration();
        last_pushing_time = now;
        pushing = true;
		cout << Force_x << " " << Force_y << " " << Force_z << endl;
        cout << "pushing start" << endl;
		cout << "-> pushing duration " << pushing_duration << endl;
    }
  }
  if(pushing){
    if(now-last_pushing_time > pushing_duration){
        cout << "pushing end" << endl;
        pushing = false;
		//pushed = true;
        non_pushing_duration = 10+get_nonpush_duration();
		cout << "-> non pushing duration " << non_pushing_duration << endl;
    }
    dBodyAddForceAtRelPos(
      body_Regis, 
      Force_x, Force_y, Force_z,
      Point_x,Point_y,Point_z
    );
  }
}

  void webots_draw_force(){

	body_Regis_pos = dBodyGetPosition (body_Regis);
	body_Regis_vel = dBodyGetLinearVel(body_Regis);
  dReal shift = -0.1;
    if(pushing){
      // setup draw style
      glDisable(GL_LIGHTING);
      glLineWidth(3.0);

        glBegin(GL_LINES);
          glColor3f(1, 0, 0);
          glVertex3f(
            body_Regis_pos[0] + Point_x, 
            body_Regis_pos[1] + Point_y, 
            body_Regis_pos[2] + Point_z + shift
            );
          glVertex3f(
            body_Regis_pos[0] + Point_x - Force_x/10,
            body_Regis_pos[1] + Point_y - Force_y/10,
            body_Regis_pos[2] + Point_z - Force_z/10 + shift
            );
        glEnd();

    }
}

void webots_get_message(){
	int size;
	if(!ended){
		message_WtoP = (WtoP*)dWebotsReceive(&size);
		if(message_WtoP==0){
			//dWebotsConsolePrintf("\n\nError in the physic plugin:\n   message_WtoP is empty\n\n");
		}
		else
		{
			force_amplitude = message_WtoP->force_amplitude;
			if(force_amplitude < 1.0)
				force_amplitude = 70.0;
			if(dWebotsGetTime() > -1){
				message_PtoW.is_in_lift_mode = 0;
				dJointSetPRParam( joint_PR_Y, dParamLoStop2 , -1.57);
				dJointSetPRParam( joint_PR_Y, dParamHiStop2 ,  1.57);
				dJointSetSliderParam( joint_slide_Z, dParamFMax , 0.0);
				
				
				//do we detect a new fall ?
				if(  body_Regis_pos[1] < limit_height ){
					time_falling = dWebotsGetTime();  // we remember when the robot falls
					message_PtoW.detect_new_fall = 1; //we tell webot we detect a new fall
					
					message_PtoW.last_force_z = Force_z;
					message_PtoW.last_force_y = Force_y;
					message_PtoW.last_force_pos = Point_y/segment_height+0.5;
					
					ended = true;
					dWebotsConsolePrintf("the robot falled\n");
					test = "you falled";
				}
				//or do we not ?
				else
					message_PtoW.detect_new_fall = 0;
			}
		}
	}
	// ---------------------------------------------------------------------
	
	//we send the message to Webots
	dWebotsSend(1, &message_PtoW, sizeof(message_PtoW)); 
}
