step = 5;


import copy
with open("file.txt","w") as f:
	Oreflex = 0.0;
	Areflex = 1.0;
	p_min=[0.65,-0.01,-0.01,0.7,0.7]
	p_max=[1.8,0.01,0.01,1.6,1.6] 
	p_bas=[0.85,0,0,1,1]
	p_step=[(max-min)/step for max,min in zip(p_max,p_min)]
	print p_step
	p_combi = [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
	j=0;
	for i,k in p_combi:
		p = copy.copy(p_bas)
		p[i] = p_min[i]
		#print "{},{}:".format(i,k)
		while p[i] < p_max[i]:
			#print "{} <= {},{}".format(p[i],p_max[i],(p_max[i]-p_min[i])/step)
			p[k] = p_min[k]
			while p[k] < p_max[k]:
				#print "{} <= {},{}".format(p[k],p_max[k],(p_max[k]-p_min[k])/step)
				p[0] = p_min[0]
				while p[0] < p_max[0]:
					#print "{} <= {},{}".format(p[k],p_max[k],(p_max[k]-p_min[k])/step)
					
					f.write("offset_change:{}\toffset_change_bas:{}\toffset_change_reflex:{}\tamp_change:{}\tamp_change_bas:{}\tamp_change_reflex:{}\t\t\tfreq_change:{}\tstance_end:0.0\n".format(
                                        p[1],
                                        p[2],
                                        Oreflex,
                                        p[3],
                                        p[4],
                                        Areflex,
                                        p[0]
					))
					p[0] = p[0] + p_step[0]
					j = j+1
					#print("{}".format(j))
				p[k] = p[k] + p_step[k]
			p[i] = p[i] + p_step[i]
