#!/usr/bin/python
import math, sys, shutil, re, sqlite3 as lite
import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("-v", "--verbose", help="active verbosity", action="store_true")
parser.add_argument("world", help="output world name")
parser.add_argument("-o", "--path", help="output world directory", type=str, default='')
parser.add_argument("-d", "--data-path", help="webots data path", type=str, default='')
parser.add_argument("-p", "--wave-starting-pos", help="first wave mean position", type=float, default=13)
parser.add_argument("-x", "--random-initial-pos", help="first wave mean position", type=int, default=-1)
parser.add_argument("-w", "--wave-number", help="number of waves", type=int, default=20)
parser.add_argument("-l", "--wave-length", help="wave length (-1 for random, >=0 to specify a distance)", type=float, default=-1)
parser.add_argument("-s", "--wave-slope", help="wave slope (-1 for increasing slope, >0 to specify a slope)", type=int, default=-1)
parser.add_argument("-m", "--max-slope", help="max slope", type=float, default=0.2)
parser.add_argument("-r", "--number-of-repeat", help="number of repeat of the wavy ground", type=int, default=1)

parser.add_argument("-i", "--interspace", help="interspace scheme (-1 for random, >=0 to specify a distance)", type=float, default=-1)

args = parser.parse_args()


from _world import World
#from _world import path

from _world import WavyGround


if not args.data_path:
	args.data_path = os.getcwd();
world = World(
	ground_repeat = args.number_of_repeat,
	data_path = args.data_path,
	wavy_ground = WavyGround(
		data_path = args.data_path,
		number = args.wave_number,
		mean_initial_pos = args.wave_starting_pos,
		random_initial_pos = args.random_initial_pos,
		repeat = args.number_of_repeat,
		interspace=args.interspace,
		length=args.wave_length,
		slope=args.wave_slope,
		max_slope=args.max_slope
	)
)
#path = "/home/efx/Development/PHD/LabImmersion/Ted/global_tools/ground_generator/slopy_ground/"
if not args.path:
	world.write(os.getcwd()+'/'+args.world)
else:
	world.write(args.path+'/'+args.world)
#world.writeWaveData(path+'/webots/worlds'+'/'+args.world+'.data')
