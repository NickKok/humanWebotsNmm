function ret = load_data(path_to_file, what)
    data = importdata(path_to_file);
    ret = data.colheaders;
end