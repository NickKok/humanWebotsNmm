#!/usr/bin/python

# Script that generates a set of experiment xml files from a sample experiment xml file. 
# Usage : generate_file.py xml_file n1 n2


import math, sys, shutil, re, sqlite3 as lite
import os
import argparse



def generate_parameters_file(cursor,folder,stagepso,filename,generate_header=False,ordering='col',append=False,best=True,iteration=-1,index=-1):
	if append:
		bestparam = open(folder + '/'+filename, 'a')
	else:
		bestparam = open(folder + '/'+filename, 'w')
		
	if stagepso:
		cur.execute("select `data`.`_d_StagePSO::stage` from data ORDER by `data`.`_d_StagePSO::stage` DESC limit 0,1;")
		maxstage = cur.fetchone()[0]

		cur.execute("select max(`iteration`) from data")
		maxiteration = cur.fetchone()[0]
		#print "select `data`.`iteration`,`data`.`index`,fitness.value from data JOIN fitness ON `fitness`.`index` = `data`.`index` AND `fitness`.`iteration` = `data`.`iteration` WHERE `data`.`_d_StagePSO::stage` = "+str(maxstage)+" ORDER BY fitness.value DESC limit 0,1;"
		#str_sql = "select `data`.`iteration`,`data`.`index`,fitness.value,`_f_energy`,`_f_steplengthSNR`,`_f_human_hip_correlation`,`_f_human_knee_correlation`, `_f_human_ankle_correlation`,`_f_distance`,`_f_duration` from data JOIN fitness ON `fitness`.`index` = `data`.`index` AND `fitness`.`iteration` = `data`.`iteration` WHERE `data`.`_d_StagePSO::stage` = "+str(maxstage)+" ORDER BY fitness.value DESC limit 0,1;"
		str_sql = "select `data`.`iteration`,`data`.`index`,fitness.value,`_f_energy`,`_f_distance`,`_f_duration` from data JOIN fitness ON `fitness`.`index` = `data`.`index` AND `fitness`.`iteration` = `data`.`iteration` WHERE `data`.`_d_StagePSO::stage` = "+str(maxstage)+" ORDER BY fitness.value DESC limit 0,1;"
		cur.execute(str_sql);
		#sql = 'SELECT * FROM fitness WHERE iteration=16 and index=42 ORDER by value DESC limit 0,1';
		#import ipdb; ipdb.set_trace()
		fitness = cur.fetchone()
		import sys
		verbose = False;
		if verbose:
			sys.stdout.write('\titer.')
			for i in range(maxstage+1):
				sys.stdout.write('\tst.{0}'.format(i))
				sys.stdout.write('\n')
			for j in range(maxiteration+1):
				sys.stdout.write('\t{0}\t'.format(j))
				for i in range(maxstage+1):
					cur.execute("select count(`_d_StagePSO::stage`) from data WHERE iteration={1} and `_d_StagePSO::stage`={0} ORDER BY `_d_StagePSO::stage`;".format(i,j))
					sys.stdout.write('{0}\t'.format(cur.fetchone()[0]))
				sys.stdout.write('\n')
		cur.execute("select count(`_d_StagePSO::stage`) from data WHERE iteration={1} and `_d_StagePSO::stage`={0} ORDER BY `_d_StagePSO::stage`;".format(maxstage,maxiteration))
		nparticules = cur.fetchone()[0];
		cur.execute("select count(id) from stages;")
		nstages = cur.fetchone()[0];
		f = lambda(x): x[1] if x[0]==1 else x[2]
		print "---->  there {3} {0} {4} in stage {1} of {2} stages".format(nparticules,maxstage,nstages-1,f((nparticules,'is','are')),f((nparticules,'particle','particles')))
		if best:
			print "Extract best"
			cur.execute('SELECT * FROM parameter_values WHERE `index`='+str(fitness[1])+' and `iteration`='+str(fitness[0]))
		else:
			print "Extract specific solution {0},{1}".format(iteration,index)
			cur.execute('SELECT * FROM parameter_values WHERE `index`='+str(index)+' and `iteration`='+str(iteration))

		parameter_values = cur.fetchone()
		print "the fitness of the best solution on stage " + str(maxstage) + " is : " + str(fitness[2])
		print "----> energy : {0}".format(fitness[3])
		print "----> step length SNR : {0}".format(fitness[4])
#		print "----> corr hip : {0}".format(fitness[5])
#		print "----> corr knee : {0}".format(fitness[6])
#		print "----> corr ankle : {0}".format(fitness[7])
	else:
		cur.execute('select `iteration`,`index`,fitness.value,`_f_energy`,`_f_human_hip_correlation`,`_f_human_knee_correlation`, `_f_human_ankle_correlation`,`_f_distance`,`_f_duration` FROM fitness ORDER by value DESC limit 0,1')
		fitness = cur.fetchone()
		cur.execute('SELECT * FROM parameter_values WHERE `index`='+str(fitness[1])+' and `iteration`='+str(fitness[0]))
		parameter_values = cur.fetchone()
		print "the fitness of the best solution is : " + str(fitness[2])
		print "----> energy : {0}".format(fitness[3])
		print "----> step length SNR : {0}".format(fitness[4])
		print "----> corr hip : {0}".format(fitness[5])
		print "----> corr knee : {0}".format(fitness[6])
		print "----> corr ankle : {0}".format(fitness[7])
		
	cur.execute('SELECT * FROM parameters')
	parameters = cur.fetchall()
	cur.execute('SELECT * FROM job')
	job = cur.fetchone()
	job_name='|'
	for item in job:
		job_name+=str(item)+'|'


	if ordering == 'col':	
		parameter_values = parameter_values[2:]
		for name,p_value in zip(parameters,parameter_values):
			bestparam.write(str(name[1]) + ' ' + str(round(p_value,20))+ "\n")
	else:
		parameter_values = parameter_values[2:]
		if generate_header:
			bestparam.write("{}\t".format("speed"))
			import ipdb; ipdb.set_trace();
			for name,p_value in zip(parameters,parameter_values):
				print(name[1])
				bestparam.write("{}\t".format(name[1]))

		bestparam.write("\n{}\t".format(fitness[-2]/fitness[-1]));
#		bestparam.write("\n{}\t".format(fitness[3]));
		for name,p_value in zip(parameters,parameter_values):
			bestparam.write("{}\t".format(round(p_value,20)))
		
	bestparam.close()

def generate_settings_file(cursor,folder):
	settingsfile = open(folder + '/settings.xml','w') # settings file used when running directly webots
	settingsfile.write('<settings>\n')
	cur.execute('select * from dispatcher');
	flag = 0
	flag2 = 0
	flag3 = 0
	while True:
		setting = cur.fetchone();
		if setting == None:
			break
		if str(setting[1]) == "rescale_parameters":
			flag = 1
		if str(setting[1]) == "muscle_activation_noise":
			settingsfile.write('  <'+str(setting[1])+'>0</'+str(setting[1])+'>\n')
		elif str(setting[1]) == "parameter_loading_scheme":
			if args.gammafibers :
				settingsfile.write('  <'+str(setting[1])+'>3</'+str(setting[1])+'>\n')
			else:
				settingsfile.write('  <'+str(setting[1])+'>'+str(setting[2])+'</'+str(setting[1])+'>\n')
			flag3 = 1
		elif str(setting[1]) == "distance_max":
			settingsfile.write('  <'+str(setting[1])+'>40.0</'+str(setting[1])+'>\n')
		elif str(setting[1]) == "optimization_scheme":
			settingsfile.write('  <'+str(setting[1])+'>0</'+str(setting[1])+'>\n')
		elif str(setting[1]) == "launching_gate":
			settingsfile.write('  <'+str(setting[1])+'>'+str(setting[2])+'</'+str(setting[1])+'>\n')
			flag2 = 1
		elif str(setting[1]) != "mode" and str(setting[1]) != "world" and str(setting[1] != "priority" != "save_for_matlab"):
			settingsfile.write('  <'+str(setting[1])+'>'+str(setting[2])+'</'+str(setting[1])+'>\n')
	if flag2 == 0:
		settingsfile.write('  <launching_gate>1.3</launching_gate>\n')
	if flag3 == 0:
		settingsfile.write('  <parameter_loading_scheme>1</parameter_loading_scheme>\n')
	if args.dataextraction: 
		settingsfile.write('  <save_for_matlab>1</save_for_matlab>\n')
	else:
		settingsfile.write('  <save_for_matlab>0</save_for_matlab>\n')
	settingsfile.write('  <job_name>'+job_name+'</job_name>\n')
	settingsfile.write('  <db_name>'+db+'</db_name>\n')

	settingsfile.write('</settings>')


	settingsfile.close()

# create the top-level parser
parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument("-o", "--output", help="output folder", default="./")
parser.add_argument("-v", "--verbose", help="active verbosity", action="store_true")
subparsers = parser.add_subparsers(dest="subparce_name",help='sub-command help')

# create the parser for the "a" command
parser_all = subparsers.add_parser('all', help='extract all')

parser_settings = subparsers.add_parser('settings', help='settings extraction help')

parser_settings.add_argument("-d", "--dataextraction", help="activates the data extraction from webots", action="store_true")
# create the parser for the "b" command
parser_parameters = subparsers.add_parser('parameters', help='parameters extraction help')
parser_parameters.add_argument("-f", "--filename", help="filename of parameters file", default="./")
parser_parameters.add_argument("-s", "--stagepso", help="extract the best solution based on stagepso", action="store_true")
parser_parameters.add_argument("-i", "--iteration", help="extract iteration", default="-1")
parser_parameters.add_argument("-p", "--particle", help="extract particle", default="-1")



parser.add_argument("database", help="sqlite database of the experiment")

args = parser.parse_args()



if args.verbose :
    if args.stagepso:
        print "extract the best solution for stagepso optimization"
    else:
        print "extract the best solution for simple pso optimization" 
    if args.dataextraction:
        print "activation of the extraction of raw data from webots"
    else :
        print "no extraction of raw data from webots"

    
parameter_values = ''
db = args.database

if os.path.isdir(db):
	files = []
	for (dirpath, dirname, filenames) in os.walk(db):
		files.extend([f for f in filenames if not f in 'README'])
		break
	for i,f in enumerate(files):
		if '.db' in f:			
			con = lite.connect(db + '/' + f)
			cur = con.cursor()

			cur.execute('SELECT * FROM job')
			job = cur.fetchone()
			job_name='|'
			for item in job:
				job_name+=str(item)+'|'
	
			if args.subparce_name in ["parameters","all"]:
				if args.filename:
					#args.filename = 'reflex_parameters-' + args.filename;
					args.filename = args.filename;
				if i==0:
					generate_parameters_file(cur,args.output,args.stagepso,args.filename,True,'line',True);
				else:
					generate_parameters_file(cur,args.output,args.stagepso,args.filename,False,'line',True);
else:
	con = lite.connect(db)
	cur = con.cursor()

	cur.execute('SELECT * FROM job')
	job = cur.fetchone()
	job_name='|'
	for item in job:
		job_name+=str(item)+'|'

	if args.subparce_name in ["settings","all"]:
		generate_settings_file(cur,args.output);
	if args.subparce_name in ["parameters","all"]:
		if args.filename:
			#args.filename = 'reflex_parameters-' + args.filename;
			args.filename = args.filename;
		if args.iteration != "-1" and args.particle != "-1":
	                generate_parameters_file(cur,args.output,args.stagepso,args.filename,False,'col',False,False,args.iteration,args.particle);
		else:
			generate_parameters_file(cur,args.output,args.stagepso,args.filename);


