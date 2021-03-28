t = 0:0.01:100;
y0 = [0];
Mu = 1;
num = 3;
cA = randi(3,1,num);
cB = randi(3,1,num);
myfunc = @(x) cA(1)*sin(cB(1)*x)+cA(2)*sin(cB(2)*x)+cA(3)*sin(cB(3)*x);
dydt = @(t,y)[1*(myfunc(t)-y(1))];
[t,y] = ode45(dydt, t, y0);

% Plot of the solution
plot(t,y(:,1))
hold on; plot(t,myfunc(t),'r')
xlabel('t')
ylabel('solution y')
title('van der Pol Equation, \mu = 1')
% find delay
delay = fmincon(@(x) -corr(myfunc(t-x),y),0.0,-1,0);


% 
timeconstant = 0.1:0.1:10;
for i=1:length(timeconstant)
    i
    dydt = @(t,y) timeconstant(i)*(myfunc(t)-y(1));
    [t,y] = ode45(dydt, t, y0);
    delay(i) = fmincon(@(x) -corr(myfunc(t-x),y),0.0,-1,0)
end


% fit of timeconstant vs delay
% General model Exp2:
%      f(x) = a*exp(b*x) + c*exp(d*x)
% Coefficients (with 95% confidence bounds):
%        a =       1.184  (1.176, 1.192)
%        b =     -0.9834  (-0.9961, -0.9708)
%        c =      0.3895  (0.3805, 0.3985)
%        d =     -0.1431  (-0.1466, -0.1396)
% 
% Goodness of fit:
%   SSE: 0.001072
%   R-square: 0.9999
%   Adjusted R-square: 0.9999
%   RMSE: 0.003342