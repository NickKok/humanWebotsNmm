function ret = load_data(path_to_file, varargin)
if(nargin == 2)
    what = varargin{1};
else
    what = 'data';
end
if(strcmp('minimal',what))
    data = importdata(path_to_file);
    ret = data.data;
else
    data = importdata(path_to_file);
    nb_element = size(data.colheaders,2);
    ret = [];
    for i=1:nb_element
        val = ['ret.' what '.' data.colheaders{i} '= data.data(:,' int2str(i) ');'];
        eval(val);
    end
    dt = 0.001;
    nb_steps = size(data.data,1);
    ret.time = (0:nb_steps-1)'*dt;
    ret.val.data = data.data;
    ret.val.labels = data.colheaders;
end
end