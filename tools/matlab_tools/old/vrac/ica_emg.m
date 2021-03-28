% path
addpath('./lib/FastICA_25/');
addpath('./fct');

% generate nominal motoneurones signal
nominal_motoneurone_signal

% generate signal matrix (motoneurone nominal signal of left limb)
x=[];
for i=1:7
    x = [x;signal(i).value'];
end

% normal ica, nonlinearity ^3, deflation, we can limit the number of ic but
% that is not crucial since the goal of this approach is to then to use the
% IC as global signal and to learn linear transformation (Weight matrix)
[y,a,w]=fastica(x,'approach','symm','numOfIC',5)
e1=mean(mean(a*y-x)) % mean distance between the real original vector and the reconstructed one
e2=mean(mean(w*x-y)) % mean distance between the ica vector and the orginal one

subplot(131)
plot((y)') 
subplot(132)
plot((x)')
subplot(133)
plot((a*y)')

% The A matrix can be used to go from the ica space (y) to the normal space
% (x) as follow a(1,:)*y = x(1,:)

% The W matrix can be used to go from the normal space (x) to the ica space
% (y) as follow w(1,:)*x = y(1,:)
