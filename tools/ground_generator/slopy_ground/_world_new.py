from random import *
from math import *
class World:
	_header_file = 'wbt_header.txt'
	_supervisor_file = 'wbt_supervisor.txt'
	_ground_file = 'wbt_ground.txt'
	_data_folder = 'data'

	def _get_header(self):
		with open(self.data_path + '/' + self._data_folder+'/'+self._header_file) as f:
			return f.read()
	def _get_supervisor(self):
		with open(self.data_path + '/' + self._data_folder+'/'+self._supervisor_file) as f:
			return f.read()\
				.replace('__ROBOT_NAME___',"")
	def _get_ground(self):
		with open(self.data_path + '/' + self._data_folder+'/'+self._ground_file) as f:
			return f.read()\
				.replace('__XSIZE__',str(self.ground_repeat))\
				.replace('__YSIZE__',str(self.ground_length))\
				.replace('__TRANS__',str(self.ground_repeat/2.-0.5))\
				.replace('__XTEXTURE_SCALE__',str(self.ground_repeat*2))\
				.replace('__YTEXTURE_SCALE__',str(self.ground_length*2))\

	def __init__(self,*args,**kwargs):
		self.data_path = kwargs.get('data_path',"/home/efx/Development/PHD/LabImmersion/Ted/global_tools/ground_generator/")
		self.ground_repeat = kwargs.get('ground_repeat',20)
		self.ground_length = kwargs.get('ground_length',231)
		self.slopy_ground = kwargs.get('slopy_ground')
		self.world = self._get_header()+'\n'+self._get_supervisor()+'\n'+self._get_ground()
		if self.slopy_ground:
			self.world += '\n' + self.slopy_ground.get()

	def get(self):
		return self.world
	def write(self,filename):
		with open(filename, "w") as text_file:
			text_file.write(self.world)

	def writeSlopeData(self,filename):
		with open(filename, "w") as text_file:
			text_file.write(''.join([str(i) + ' ' + str(j) + '\n' for i,j in zip(self.slopy_ground.positions,self.slopy_ground.slopes)]))

class Slope:
	width = 18
	def __init__(self,*args,**kwargs):
		self.basalheight = kwargs.get('basalheight')
		self.length=kwargs.get('length')
		self.height=kwargs.get('height')
		self.position=kwargs.get('position')
		self.repeat=kwargs.get('repeat')
		self.number=kwargs.get('number')
		self.slopy_ground=args[0];
		self.slope_string=self.slopy_ground.slope_string

	def get(self):
		return self.slope_string \
		.replace('__REPEATN__',str(self.repeat-1-self.width/2.0)) \
		.replace('__STARTINGPOS__',str(self.position)) \
		.replace('__BASALHEIGHT__',str(self.basalheight)) \
		.replace('__HEIGHT__',str(self.basalheight+self.height)) \
		.replace('__WIDTH__',str(self.width)) \
		.replace('__LENGTH__',str(self.length))\
		.replace('__WAVE_NUMBER__',str(self.number))\
		.replace('__REPEAT_NUMBER__',str(self.repeat))\

class SlopyGround:
	_slope_file = 'wbt_slope.txt'
	_data_folder = 'data'

	def __init__(self,*args,**kwargs):
		self.data_path = kwargs.get('data_path',"/home/efx/sml/tools/ground_generator/")
		self.slopes = []
		self.positions = []
		self.number=kwargs.get('number',20)
		self.repeat=kwargs.get('repeat',1)
		self.interspace=kwargs.get('interspace',-1)
		self.length=kwargs.get('length',-1)
		self.slope=kwargs.get('slope',-1)
		self.slope_string = self._get_slope_data();
		self.slopy_ground_string = '';

		self.max_slope = kwargs.get('max_slope',0.3)
		self.default_length = kwargs.get('default_length',1.0)
		self.mean_initial_pos = kwargs.get('mean_initial_pos',13)
	def _get_slope_data(self):
		with open(self.data_path + '/' + self._data_folder+'/'+self._slope_file) as f:
			return f.read();

	def get(self):
		self.generate_slopy_ground()
		return self.slopy_ground_string
	def generate_slopy_ground(self):
		lastslope_height = 0.0
		for i in range(self.repeat):
			position = self.mean_initial_pos + (random()-1.0)/2
			for j in range(self.number):
				interspace = random() if self.interspace == -1 else self.interspace
				position += interspace
				length = self.default_length*(random()+0.5)*2 if self.length==-1 else self.length
				slope =  float(j+1)/self.number*self.max_slope if self.slope==-1 else self.slope;
				self.positions.append(position)
				self.slopes.append(slope)
				height =  length*slope/sqrt(1+slope*slope)
				theslope = Slope(
				self,
				basalheight=lastslope_height,
				length=length,
				height=height,
				position=position,
				repeat=i+1,
				number=j+1
				)
				lastslope_height = theslope.basalheight+theslope.height
				self.slopy_ground_string += theslope.get()
				position += length
