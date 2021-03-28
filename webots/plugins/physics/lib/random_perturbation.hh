#include <random>
#include <boost/random/normal_distribution.hpp>
#include <boost/math/distributions/fisher_f.hpp>
#include <boost/math/special_functions/gamma.hpp>
#include <boost/random.hpp>


double ended=false;
double start_time=3;

/****
*
*
*   RANDOM FORCE PERTURBATION GENERATOR HEADER
*
*
***/
static dReal  mean_amplitude = 50.0;
static dReal sigma_amplitude = 1;
// force angle with the perpendicular of the gravity (normal distribution)
static dReal  mean_angle = 0.0;
static dReal sigma_angle = 0.4;
// force position in the y-axis (vertical) (normal distribution)
static dReal  mean_position = 0.0;
static dReal  sigma_position = 0.5;
// force duration (F-distribution)
static dReal d1_duration = 100;
static dReal d2_duration = 100;
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
  return 4*fisher_distribution(generator);
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

void update_force(){
  dReal F = get_force_amplitude();
  cout << F << endl;
  dReal alpha = get_force_angle();
  
  //printf("alpha %f\n", alpha*180.0/3.14);
  Force_z = F*cos(alpha);
  Force_y = -F*sin(alpha);
  update_force_application();
}


static bool pushing = false;
static dReal last_pushing_time = start_time;
static dReal pushing_duration = 0.0;
static dReal non_pushing_duration = 0.0;
string test = "you didn't falled";
void reinitialize(){
	last_pushing_time = now;
	pushing_duration = 0.0;
	non_pushing_duration = 0.0;
	pushing=false;
}

void webots_apply_random_force(){
  now = (double)dWebotsGetTime()/1000.0;
  if(!pushing){
    if(now-last_pushing_time > non_pushing_duration){
        update_force();
        pushing_duration = get_push_duration();
        last_pushing_time = now;
        pushing = true;
        dWebotsConsolePrintf("pushing start\n");
		dWebotsConsolePrintf("-> pushing duration %f\n", pushing_duration);
		dWebotsConsolePrintf("-> pushing force %f\n", pushing_duration);
    }
  }
  if(pushing){
    if(now-last_pushing_time > pushing_duration){
        dWebotsConsolePrintf("pushing end");
        pushing = false;
        non_pushing_duration = get_nonpush_duration();
		dWebotsConsolePrintf("-> non pushing duration %f\n",non_pushing_duration);
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
/*
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
*/

    }
}
void webots_physics_draw(int pass, const char *view) {
  	if (pass == 1 && view == NULL) {
  		webots_draw_force();
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
			if(dWebotsGetTime() > -1){
				message_PtoW.is_in_lift_mode = 0;
				dJointSetPRParam( joint_PR_Y, dParamLoStop2 , -1.57);
				dJointSetPRParam( joint_PR_Y, dParamHiStop2 ,  1.57);
				dJointSetSliderParam( joint_slide_Z, dParamFMax , 0.0);
				message_PtoW.last_force_z = Force_z;
				message_PtoW.last_force_y = Force_y;
				message_PtoW.last_force_pos = Point_y/segment_height+0.5;
				
				//do we detect a new fall ?
                /*
				if(  body_Regis_pos[1] < limit_height ){
					time_falling = dWebotsGetTime();  // we remember when the robot falls
					message_PtoW.detect_new_fall = 1; //we tell webot we detect a new fall
					
					ended = true;
					dWebotsConsolePrintf("the robot falled\n");
					test = "you falled";
				}
				//or do we not ?
				else
                */
					message_PtoW.detect_new_fall = 0;
			}
		}
	}
	// ---------------------------------------------------------------------
	
	//we send the message to Webots
	dWebotsSend(1, &message_PtoW, sizeof(message_PtoW)); 
}


/*
class RandomForce{
private:
	dReal  mean_amplitude;
	dReal sigma_amplitude;
	// force angle with the perpendicular of the gravity (normal distribution)
	dReal  mean_angle;
	dReal sigma_angle;
	// force position in the y-axis (vertical) (normal distribution)
	dReal  mean_position;
	dReal  sigma_position;
	// force duration (F-distribution)
	dReal d1_duration;
	dReal d2_duration;
	// force frequency  (G-distribution)
	dReal k;
	dReal sigma;
	// forward push probability
	dReal backward_prob;
	
	
	// Uniform
	boost::uniform_01<> random_one;
	
	// Gaussian
	NormalDistribution nd_amplitude;
	NormalDistribution nd_angle;
	NormalDistribution nd_position;
	GaussianGenerator var_nor_amplitude;
	GaussianGenerator var_nor_angle;
	GaussianGenerator var_nor_position;
	
	
	// Fisher
	std::fisher_f_distribution<double> fisher_distribution(50.0,50.0);
	std::default_random_engine generator;
	
	// Gamma
	std::gamma_distribution<> gamma_distribution(k, sigma);
	
public:
	bool apply;
	RandomForce(){
		mean_amplitude = 50.0;
		sigma_amplitude = 1;
		mean_angle = 0.0;
		sigma_angle = 0.8;
		mean_position = 0.0;
		sigma_position = 1.0;
		d1_duration = 50;
		d2_duration = 50;
		k=1.0;
		sigma = 2.0;
		backward_prob=0.0;
		
		apply=false;
		
		nd_amplitude(mean_amplitude, sigma_amplitude);
		nd_angle(mean_angle, sigma_angle);
		nd_position(mean_position, sigma_position);
		
		var_nor_amplitude(rng, nd_amplitude);
		var_nor_angle(rng, nd_angle);
		var_nor_position(rng, nd_position);
	}
	
	dReal get_force_amplitude(){
		return var_nor_amplitude()*(now-start_time)/30.0;
	}
	
	dReal get_force_angle(){
		return var_nor_angle();
	}
	
	
	dReal get_force_position(){
		//return var_nor_position();
		return random_one(rng);
	}
	
	
	
	dReal get_push_duration(){
		//return 0.0;
		return fisher_distribution(generator)/2.;
	}
	
	
};
*/
