#!/usr/bin/python
import math, sys, shutil, re, sqlite3 as lite
import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("-v", "--verbose", help="active verbosity", action="store_true")
parser.add_argument("world", help="output world name")
parser.add_argument("-o", "--path", help="output world directory", type=str, default='')
parser.add_argument("-d", "--data-path", help="webots data path", type=str, default='')
parser.add_argument("-p", "--slope-starting-pos", help="slope ground start mean position", type=float, default=13)
parser.add_argument("-w", "--slope-number", help="number of slope change", type=int, default=20)
parser.add_argument("-l", "--slope-length", help="slope length (-1 for random, >=0 to specify a distance)", type=float, default=3)
parser.add_argument("-s", "--slope-slope", help="slope slope (-1 for increasing slope, >0 to specify a slope)", type=float, default=-1)
parser.add_argument("-m", "--maximum-slope", help="maximum slope in case of increasing slope", type=float, default=0.3)
parser.add_argument("-r", "--number-of-repeat", help="number of repeat of the slopy ground", type=int, default=1)
parser.add_argument("-i", "--interspace", help="interspace scheme (-1 for random, >=0 to specify a distance)", type=float, default=0)

args = parser.parse_args()


from _world_new import World

from _world_new import SlopyGround

if not args.data_path:
	args.data_path = os.getcwd();
world = World(
	ground_repeat = args.number_of_repeat,
	data_path = args.data_path,
	slopy_ground = SlopyGround(
		data_path = args.data_path,
		number = args.slope_number,
		mean_initial_pos = args.slope_starting_pos,
		repeat = args.number_of_repeat,
		interspace=args.interspace,
		length=args.slope_length,
		slope=args.slope_slope,
		max_slope=args.maximum_slope
	)
)
#path = "/home/efx/Development/PHD/LabImmersion/Ted/global_tools/ground_generator/slopy_ground/"
if not args.path:
	world.write(os.getcwd()+'/'+args.world)
else:
	world.write(args.path+'/'+args.world)
#world.writeWaveData(path+'/webots/worlds'+'/'+args.world+'.data')
