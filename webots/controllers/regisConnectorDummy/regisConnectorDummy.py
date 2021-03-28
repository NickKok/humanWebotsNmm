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

aa = np.zeros([23,1])
                     
# Main loop:
# - perform simulation steps until Webots is stopping the controller
while myBrain.step() != -1:
        myBrain.sendToSpinalCord(aa.tolist(), encrypt_with = 'json')
        # We receive signals from sensory cortex and send that to Cortex
        bb = myBrain.receiveFromSensoryCortex()
