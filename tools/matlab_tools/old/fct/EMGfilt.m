function emgf = EMGfilt(varargin)
error(nargchk(1,2,nargin))
x = varargin{1};

if nargin == 1
	fs = 1000;
else
	fs = varargin{2};
end

%1. De-mean the raw signal (subtract out the mean)
x = x-mean(x);

%-------------Butterworth filters high-pass and low-pass----------%
HPorder = 2;
LPorder = 8;
HPcut = 20;
LPcut = 300;
[B1 A1] = butter(HPorder, HPcut/(fs/2),'high');
[B2 A2] = butter(LPorder, LPcut/(fs/2),'low');
%-------------Butterworth filters high-pass and low-pass----------%


%-----------------Butterworth filters stop-band-------------------%
[b_60 a_60] = butter(1,[49/(fs/2) 51/(fs/2)],'stop');
[b_120 a_120] = butter(1,[99/(fs/2) 101/(fs/2)],'stop');
[b_180 a_180] = butter(1,[149/(fs/2) 151/(fs/2)],'stop');
[b_240 a_240] = butter(1,[199/(fs/2) 201/(fs/2)],'stop');
[b_300 a_300] = butter(1,[249/(fs/2) 251/(fs/2)],'stop');
[b_360 a_360] = butter(1,[299/(fs/2) 301/(fs/2)],'stop');
%-----------------Butterworth filters stop-band-------------------%

%--------------------Resulting Filter-----------------------------%
b=conv(conv(conv(conv(conv(conv(conv(b_60,b_120),b_180),b_240),b_300),b_360),B1),B2);
a=conv(conv(conv(conv(conv(conv(conv(a_60,a_120),a_180),a_240),a_300),a_360),A1),A2);
%b=conv(B1,B2);
%a=conv(A1,A2);
%--------------------Resulting Filter-----------------------------%


%-------Bidirectional (zero phase) filtering-----------%
%emgf = filtfilt(b,a,x);
emgf = abs(filtfilt(b,a,x));
%-------Bidirectional (zero phase) filtering-----------%

