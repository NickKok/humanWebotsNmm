function y = derivatives(x,t)
% derivatives : calcule the finite derivative of vector x
% t : time step between each observation in vector x (facultatif)

if(nargin == 1)
    t = 1;
end
if(size(x,1) == 1)
    x = x';
end
    x = [x;x(end-1)];
    y = (x(2:end) - x(1:end-1))/t;
end