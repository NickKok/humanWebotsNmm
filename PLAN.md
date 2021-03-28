SML : Spinal Cord Enabled Model of Locomotion

Introduction
============

Todo
====

User Interface extension (branch UI)
------------

-- Add possibility to load parameters on the fly
- Create a GUI to handle online communication with the model
- The GUI will give the possibility to :
	- load a control layer architecture and control it
	- load geyer parameters
	- load spinal cord interneuron topology

Online gait discovery (branch OGD)
------------
The online gait discovery starts with an existing set of parameters
and incrementaly update them based on a simple random perturbation.
The algorithm used will be the SPSA [wikipedia](http://en.wikipedia.org/wiki/Simultaneous_perturbation_stochastic_approximation)
[official website](http://www.jhuapl.edu/SPSA/)


Implement Wangs extension (branch wangExtension)
------------

- Seperation of the cycle on four different phases (addition of a swing end phase)
- Add parameters to control the entering on swing/stance phase based on the horizontal distance to the center of mass of the model
> The default parameters value should be 
> choose such it doesn't interfer with FBL 
> swing/stance phase entering rule

Enable 3D (branch 3D)
-------------
Two different strategies are enviseable to control the Coronal plan. Either using a reflex based approach comparable 
to the one used to control the Sagittal plan or either use a robotic control strategy based on simple PD control loop

### Reflex based control
### PD control loop

Coman Model (branch Coman)
-------------
The first in the implementation of the model on the coman is to:
- look how to restrict the model to the sagittal plane
- separate the controllers implementation that is robot specific to the rest, this will facilitate the creation of a coman controller


World Generation (branch Environment)
----------------
- Downward increasing slope
- Up and Downstairs
- Backward gait
