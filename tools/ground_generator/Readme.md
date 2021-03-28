# Sml ground generators 

## General information 

There are two types of ground generator : 

- wavy_ground generator 
- slopy_ground generator 

> You can just type `./slopy_ground_generator.py --help` to see how to work with it. Note that you should be in the right directory.

### Library requirements 

  sudo apt-get install python-dev

### Directory structure 

Ground creator are located in `./sml/tools/ground_generator`


## Slopy ground generator 

### Python `slopy_ground_generator.py`

You can just type `./slopy_ground_generator.py --help` to see how to work with it. Note that you should be in the right directory.

	./slopy_ground_generator.py -w 4 -l 10 -s 0.1 -p 3 -d ../world_template_files -r=1 test.wbt 

#### Examples 

1) Create a `slopy_ground.wbt` world file in the worlds directory wich has the following properties : 
  - starting position of the first slope element : 1.0 (-p)
  - length of each slope element : 1.0 (-l)
  - number of slope element : 10 (-w)
  - maximum slope (slope of the last element) : 0.3 (-m)

```
  export SML_PATH=/home/efx/Development/sml
  $SML_PATH/tools/ground_generator/slopy_ground/slopy_ground_generator.py -d $SML_PATH/tools/ground_generator/world_template_files/ -m 0.3 -p 1 -w 10 -l 1.0 -i 0 -o $SML_PATH/controller_current/webots/worlds test.wbt
```

>*please update the SML_PATH*


## Wavy ground generator 

### Python `wavy_ground_generator.py`

#### Examples 

1) Create a `wavy_ground.wbt` world file in the worlds directory with the following properties 
	- starting position : 10.0 (-p)
	- maxmimum slope : 0.3 (-m)
	- number of wave : 10 (-w)

```
	export SML_PATH=/home/efx/Development/sml
	$SML_PATH/tools/ground_generator/wavy_ground/wavy_ground_generator.py -d $SML_PATH/tools/ground_generator/world_template_files/ -p 10.0 -w 10 -m 0.3 -o $SML_PATH/controller_current/webots/worlds/ wavy_ground.wbt
```

>*please update the SML_PATH*



## Using the word_builder during optimization 

It is possible to generate worlds on the fly during optimization. This is done by modifying the xml job file and calling the correct world_builder

1) Compiling world builders

The builder can be compiled by typing `make` in the ./sml/tools/ground_generator folder.
This will generate two programs : `wavy_builder` and `slopy_builder`. Those are very simple c++ program that get the taskid from the optimization framework
and call the corresponding python world builder to generate a world with a unique name.

2) Calling world builders


Example with the wavy_builder
```
  export SML_PATH=/home/efx/Development/sml                                                              
  ./wavy_builder $SML_PATH/tools/ground_generator /tmp $SML_PATH/tools/ground_generator/world_template_files
```

The wavy_builder takes three parameters : the path of the generator, the path of the world directory and the path of the template files.

3) Integrating the world builder in the xml job file

In order to use it in the xml job file we need a single call without parameters. So the idea is to wrap up the command calling the builder in a simple script.
I provide one as example in `./sml/tools/ground_generator/my_sample_builder`.

There is a job tutorial showing how to use it : exp_stagePSOWorldBuilder.xml. The idea is to remove the webotsPath and replace it by webotsBuilderPath.

Please update the paths in my_sample_builder and in exp_stagePSOWorldBuilder if you want to try.
The parameters of the python builder are set in the `wavy_builder.cc` and `slopy_builder.cc`. 


> The idea is to first find the right parameters by calling directly the python generator and testing the worlds. Once you found the right parameters modify the corresponding *_builder.cc. 


## Extracting wave information 

ground information can be extracted using the extractGroundStructure script. It takes the world of interest as argument.

