"""supervisor controller."""

import sys
import os
import json
sys.path.append(os.path.abspath("/home/efx/Development/PHD/RL/deep-rl-biorob/webots_communication_toolbox/tools"))

from abstractbrain import SimpleWebotsPeripheralSystem
import numpy as np

SOLIDS = [
'REGIS',
'LEFT_THIGH',
'LEFT_SHIN',
'LEFT_FOOT',
'RIGHT_THIGH',
'RIGHT_SHIN',
'RIGHT_FOOT',
]




myBrain = SimpleWebotsPeripheralSystem(SOLIDS,"emitter","receiver")


#vTrunk_Pos = [np.random.rand()/5, 1.53, np.random.rand()/5]
#myBrain.supervisor.getFromDef("REGIS").getField("translation").setSFVec3f(vTrunk_Pos)

#vTerrain_Pos = [2*np.random.rand(), -0.58, 2*np.random.rand()]
#myBrain.supervisor.getFromDef("TERRAIN").getField("translation").setSFVec3f(vTerrain_Pos)

Flat = True
#factor = 0.05
#factor = 1.0
factor = 1.0

if np.random.randint(100) >= 0:
  # factor = 0.05
  Flat = False




if Flat:
  vTerrain_Pos = [0, -1.58, 0]
  myBrain.supervisor.getFromDef("TERRAIN").getField("translation").setSFVec3f(vTerrain_Pos)

  vFlat_Pos = [0, 0, 0]
  myBrain.supervisor.getFromDef("GROUND").getField("translation").setSFVec3f(vFlat_Pos)
else:
  vTerrain_Pos = [0, -0.58, 0]
  myBrain.supervisor.getFromDef("TERRAIN").getField("translation").setSFVec3f(vTerrain_Pos)

  vFlat_Pos = [0, -1, -220]
  myBrain.supervisor.getFromDef("GROUND").getField("translation").setSFVec3f(vFlat_Pos)



transitionTime = 0.0 #TODO: This is also defined in the c++ 
                     # controller but shouldn't.
                     
aa = np.zeros([23,1])
                     
# Main loop:
# - perform simulation steps until Webots is stopping the controller
while myBrain.step() != -1:
#    try:
        if(myBrain.time >= transitionTime):
          # We get the signals from the motor cortex and send them to the spinal cord
          aa = factor*(myBrain.getFromMotorCortex()-0.5)
          #print aa
          aa[aa<1e-4] = 0

        #print aa.tolist()
        myBrain.sendToSpinalCord(aa.tolist(), encrypt_with = 'json')

        # We receive signals from sensory cortex and send that to Cortex
        bb = myBrain.receiveFromSensoryCortex()
        #print bb
        
        if(myBrain.time >= transitionTime):
          myBrain.sendToPremotorCortex(bb)
#    except:
#        print "I will restart soon"
