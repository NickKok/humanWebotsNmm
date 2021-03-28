#!/usr/bin/python
import math, sys, shutil, re, sqlite3 as lite
import argparse
import os
import socket
from job_manager_option import options

GITBRANCH = "master" 
parser = argparse.ArgumentParser()
parser.add_argument("-v", "--verbose", help="active verbosity", action="store_true")
parser.add_argument("-m", "--multiplerun", help="enable multiple run, the wrost fitness is kept", action="store_true")
parser.add_argument("-w", "--webotsWorldName", help="active verbosity", type=str)
parser.add_argument("-b", "--worldbuilder", help="enable the world builder to use for wavy ground", action="store_true")
parser.add_argument("-i", "--initialpopulation", help="start from initial population", action="store_true")
parser.add_argument("-n", "--initialpopulationname", help="initial population name", type=str)
parser.add_argument("-e", "--experimenttype", help="either IP, FBL or 3FBL", type=str, default='FBL')
parser.add_argument("-s", "--speed", help="speed to converge to", type=float, default=1.3)
parser.add_argument("-a", "--algorithm", help="optimization algorithm (cmaes or pso)", type=str)
parser.add_argument("-l", "--launchinggate", help="launching gate file name", type=str)
parser.add_argument("-p", "--smlpath", help="the path to the sml repository", type=str, default="")


parser.add_argument("webotsVersion", help="webots version (without . e.g. 644 for version 6.4.4)")

#parser.add_argument("-l", "--slope-length", help="slope length (-1 for random, >=0 to specify a distance)", type=int, default=3)
#parser.add_argument("-s", "--slope-slope", help="slope slope (-1 for increasing slope, >0 to specify a slope)", type=int, default=-1)
#parser.add_argument("-r", "--number-of-repeat", help="number of repeat of the slopy ground", type=int, default=1)
#parser.add_argument("-i", "--interspace", help="interspace scheme (-1 for random, >=0 to specify a distance)", type=int, default=0)

args = parser.parse_args()


phases = {
	'3FBL' : 
		[
			{'type' : 'initialPhase'},
			{'type' : 'fullReflex', 'name' : 'saved', 'steps' : 5},
			{'type' : 'semiCpg', 'option' : 'replace', 'steps' : 5}
		],
	'FBL' : 
		[
			{'type' : 'initialPhase'},
			{'type' : 'fullReflex', 'steps' : 3},
		],
	'IP' : 
		[
			{'type' : 'initialPhase'}
		]
}

def generate_phase_description(phases):
	descriptor = '';
	for p in phases:
		if p['type'] == 'initialPhase':
			if len(phases) == 1:
				return 'initialPhase'
		else:
			descriptor += p['type']
			if p['type'] or p['steps'] or p['options']:
				descriptor += '{'


			if p['type'] == 'fullReflex' and p.get('name',None):
				descriptor += 'p_file={},'.format(p['name'])
			if p['type'] == 'semiCpg' and p.get('option',None):
				descriptor += 'cpg_option={},'.format(p['option'])
			if p.get('steps',None):
				descriptor += 'start_after_step={},'.format(p['steps'])

			descriptor = descriptor[0:-1]

			if p['type'] or p['steps'] or p['options']:
				descriptor += '}'
			descriptor += '|'
	
	if descriptor[-1] == '|':
		descriptor = descriptor[0:-1]
	return descriptor
	

sml_path_biorob = '/home/dzeladin/Development/sml/sml'
sml_path_local = '/home/efx/Development/PHD/Airi'

home_path_biorob = '/home/dzeladin/'
home_path_local = '/home/efx/'

libsml_path_biorob = home_path_biorob + '.local/usr/lib'
libsml_path_local = home_path_local + '.local/usr/lib'


options.update( {
	'git_branch' : GITBRANCH.lower(),
	'webots_version' : args.webotsVersion,
	'webots_version_dot' : ''.join([i+'.' for i in args.webotsVersion])[0:-1],
	'webots_world_name' : args.webotsWorldName if args.webotsWorldName else "{}".format(args.webotsVersion),
	'data_folder' : 'data',
	'data_path' : sml_path_local if not 'biorob' in socket.gethostname() else sml_path_biorob,
	'sml_path' : sml_path_local if not 'biorob' in socket.gethostname() else sml_path_biorob,
	'libsml_path' : libsml_path_local if not 'biorob' in socket.gethostname() else libsml_path_biorob,
	'home_path' : home_path_local if not 'biorob' in socket.gethostname() else home_path_biorob
	})

if args.algorithm:
	options['algorithm'] = args.algorithm

options['max_iterations'] = options['evaluation_number']/options['population_size']

if args.speed:
	options['desired_speed'] = args.speed

if args.experimenttype:
	options["experiment_type"] = args.experimenttype

if args.launchinggate:
	options["launching_gate"] = args.launchinggate

if args.smlpath:
	options["sml_path"] = args.smlpath

if args.multiplerun:
	options["multiple_run"] = True

if args.worldbuilder:
	options["world_builder"] = True

if args.initialpopulation:
	options["initial_population"] = True

if args.initialpopulationname:
	options["initial_population_name"] = args.initialpopulationname

if not  "max_distance" in options:
	options["max_distance"] = options["desired_speed"]*options["desired_duration"];

xml_job_data = ''
with open("{}/tools/job_tools/job_generator/{}/base.xml".format(
	options['data_path'],
	options['data_folder'],
	)) as f:
	xml_job_data = f.read();

token = ''
with open("{}/tools/job_tools/job_generator/{}/global/_tokenNode.xml".format(
	options['data_path'],
	options['data_folder']
	)) as f:
	token = f.read();

parameters = ''
#with open("{}/tools/job_tools/job_generator/{}/global/{}/_parameterNodeGeyerRange.xml".format(
with open("{}/tools/job_tools/job_generator/{}/global/{}/_parameterNode.xml".format(
        options['data_path'],
        options['data_folder'],
	options['git_branch']
        )) as f:
        parameters = '\n' + f.read() + '    ';

fitnessExpression = ''
with open("{}/tools/job_tools/job_generator/{}/global/_fitnessNode.xml".format(
        options['data_path'],
        options['data_folder']
        )) as f:
        fitnessExpression = '\n' + f.read();

stageExtension = ''
with open("{}/tools/job_tools/job_generator/{}/global/_stageExtensionNode.xml".format(
        options['data_path'],
        options['data_folder']
        )) as f:
        stageExtension = '\n' + f.read() + '  ';

settingDispatcher = ''
with open("{}/tools/job_tools/job_generator/{}/global/_settingDispatcher.xml".format(
        options['data_path'],
        options['data_folder']
        )) as f:
        settingDispatcher = '\n' + f.read();

settingOptimizer = ''
with open("{}/tools/job_tools/job_generator/{}/{}/setting.xml".format(
        options['data_path'],
        options['data_folder'],
	options['algorithm']
        )) as f:
        settingOptimizer = '\n' + f.read();


xml_job_data = xml_job_data\
	.replace('__PARAMETERS__',parameters)\
	.replace('__SETTING_OPTIMIZER__', settingOptimizer)\
	.replace('__FITNESS_EXPRESSION__',fitnessExpression)\
	.replace('__STAGE_EXTENSION__',stageExtension)\
	.replace('__SETTING_DISPATCHER__', settingDispatcher)\
	.replace('__TOKEN__', token)

print xml_job_data\
	.replace('__GITBRANCH__', str(options['git_branch'])) \
	.replace('__OPTIMIZER__',str(options['algorithm'])) \
	.replace('__DESIREDSPEED__',str(options['desired_speed'])) \
	.replace('__EXPERIMENTTYPE__',str(options['experiment_type'])) \
	.replace('__JOBNAME__',str("{}_{}".format(options['algorithm'],options['desired_speed']))) \
	.replace('__MAXITERATIONS__',str(options['max_iterations'])) \
	.replace('__POPULATIONSIZE__',str(options['population_size'])) \
	.replace('__MAXDISTANCE__',str(options['max_distance'])) \
	.replace('__MAXDURATION__',str(options['desired_duration'])) \
	.replace('__PHASESDESCRIPTOR__',generate_phase_description(phases[options['experiment_type']])) \
	.replace('__WEBOTSWORLDNAME__',str(options['webots_world_name'])) \
	.replace('__WEBOTSVERSION__',str(options['webots_version'])) \
	.replace('__WEBOTSVERSION_DOT__',str(options['webots_version_dot'])) \
	.replace('__LAUNCHINGGATE__',str(options['launching_gate'])) \
	.replace('__SMLPATH__',str(options['sml_path'])) \
	.replace('__WORLD_BUILDER_START__','<!--' if not options['world_builder'] else '') \
	.replace('__WORLD_BUILDER_END__','-->' if not options['world_builder'] else '') \
	.replace('__WORLD_START__','<!--' if options['world_builder'] else '') \
	.replace('__WORLD_END__','-->' if options['world_builder'] else '') \
	.replace('__MULTIPLERUN_START__','<!--' if not options['multiple_run'] else '') \
	.replace('__MULTIPLERUN_END__','-->' if not options['multiple_run'] else '')\
	.replace('__INITIALPOPULATION_START__','<!--' if not options['initial_population'] else '') \
	.replace('__INITIALPOPULATION_END__','-->' if not options['initial_population'] else '') \
	.replace('__INITDBNAME__', options['initial_population_name']) \
	.replace('__HOMEPATH__', options['home_path']) \
	.replace('__LIBSMLPATH__', options['libsml_path'])
