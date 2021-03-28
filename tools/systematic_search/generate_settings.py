
import copy

folder = '/home/efx/Development/PHD/Airi/';

settings = '''<settings>
  <config>conf</config>
  <distance_max>8000.0</distance_max>
  <duration_max>8000.0</duration_max>
  <rescale_parameters>0</rescale_parameters>
  <muscle_activation_noise>0</muscle_activation_noise>
<!--  <experiment>fullReflex{p_file=1.3_rp,start_after_step=1}</experiment>-->
  <experiment>fullReflex{p_file=1.2,start_after_step=1}|systematicFdbReplace{p_file=1.2,start_after_step=4}</experiment>
<!--  <experiment>fullReflex{p_file=1.6,start_after_step=1}|fullReflex{p_file=0.8,start_after_step=10}</experiment>-->
  <launching_gate>1.3</launching_gate>
  <save_for_matlab>0</save_for_matlab>
  <feedback2study>__FEEDBACK__</feedback2study>
</settings>
''';

step = 5;

settings_file = "{}current/webots/conf_1.3_2/settings/settings.xml".format(folder)
interneuronname_file = "{}current/webots/conf_1.3_2/cpg_gate/cpg_interneurons.txt".format(folder)
webotsworld_file = "{}current/webots/worlds/__WORLD__".format(folder)

interneurons = [c.replace('#','').replace('\n','') for c in tuple(open(interneuronname_file, 'r'))]


for i in range(1,len(interneurons)):
	file = open(
		settings_file.replace('settings.xml','settings_{}.xml'.format(i)
		),'w');
	
	hello = settings\
		.replace('__FEEDBACK__',interneurons[i-1])\
		.replace('__WEBOTS__',webotsworld_file.replace('__WORLD__','webots644_{}.wbt'.format(i)))
		
	
	file.write(hello)
		