function x2 = changeSize(x1,N)
    % [y t] = changeSize(x,t,f), change the size of the input to N
    % and then filter the output
    % INPUT
    % x : observation, 1D column vector
    % N : number of sample needed
    t1 = 1:length(x1);
    t2 = 1:N;
    x2 = spline(t1,x1,t2);
    x2 = double(x2);
end
