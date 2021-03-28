function [f z] = plotfft(x,y,varargin)
if(nargin == 3)
    c = varargin{1};
else
    c = 'b';
end
if(size(y,1) == 1)
    y = y';
end
L = size(y,1);                     % Length of signal
fs = 1/(x(2)-x(1));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
z = 2*abs(Y(1:NFFT/2+1));
% Plot single-sided amplitude spectrum.
plot(f,z,c);
end