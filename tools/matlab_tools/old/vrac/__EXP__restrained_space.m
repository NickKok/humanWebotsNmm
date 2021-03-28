parameters=zeros(25,29-9)
speed = [ 0.9 0.9 0.9 0.9 1.0 1.0 1.0 1.0 1.0 1.0 1.1 1.1 1.1 1.1 1.15 1.15 1.15 1.15 1.15 1.1 1.2 1.2 1.2 1.2 1.2 1.3 1.3 1.3 1.3 1.3 1.4 1.5 1.5 1.5 ];
speed = speed(10:29)
for i=1:20
	d=importdata(['../raw_files/parameters' num2str(i)]);
	parameters(:,i) = d.data;
	parameters_name = d.rowheaders;
end
parameters = parameters';