function [tout, yout] = rk4(FunFcn, tspan, y0, ssize, parameterSet, type,hw)

% RK4	Integrates a system of ordinary differential equations using
%	the fourth order Runge-Kutta  method.  See also ODE45 and
%	ODEDEMO.M.
%	[t,y] = rk4('yprime', tspan, y0) integrates the system
%	of ordinary differential equations described by the M-file
%	yprime.m over the interval tspan=[t0,tfinal] and using initial
%	conditions y0.
%	[t, y] = rk4(F, tspan, y0, ssize) uses step size ssize
%
% INPUT:
% F     - String containing name of user-supplied problem description.
%         Call: yprime = fun(t,y) where F = 'fun'.
%         t      - Time (scalar).
%         y      - Solution column-vector.
%         yprime - Returned derivative column-vector; yprime(i) = dy(i)/dt.
% tspan = [t0, tfinal], where t0 is the initial value of t, and tfinal is
%         the final value of t.
% y0    - Initial value column-vector.
% ssize - The step size to be used. (Default: ssize = (tfinal - t0)/100).
%
% OUTPUT:
% t  - Returned integration time points (column-vector).
% y  - Returned solution, one solution column-vector per tout-value.
%
% The result can be displayed by: plot(t,y).

stop = 0;
% figure1 = uCtrl();
% 
% set(figure1,'KeyPressFcn', @handleKey); % open figure for %%display of results
% 
% 
% set(figure1,'NextPlot','replacechildren');
% 
% hpop = uicontrol('Style', 'popup',...
%        'String', 'hsv|hot|cool|gray',...
%        'Position', [20 320 100 50],...
%        'Callback', 'setmap');
% drawnow;
% 
% usercontrol = 0; 
% function handleKey(~,event)
%     switch event.Character
%         case ' ' % stop training
%             usercontrol = 1;
%         case 'a'
%             usercontrol = 2;
%         case 'o'
%             usercontrol = 2+3;
%         case 'e'
%             usercontrol = 2+6;
%         case 'q'
%             usercontrol = 2+9;
%         case 'j'
%             usercontrol = 2+12;
%         case 'k'
%             usercontrol = 2+15;
%     end
% end 


% Initialization

t0=tspan(1);
tfinal=tspan(2);
pm = sign(tfinal - t0);  % Which way are we computing?
if nargin < 4, ssize = (tfinal - t0)/100; end
if ssize < 0, ssize = -ssize; end
h = pm*ssize;
t = t0;
y = y0(:);

% We need to compute the number of steps.

dt = abs(tfinal - t0);
N = floor(dt/ssize) + 1;
if (N-1)*ssize < dt
  N = N + 1;
end

% Initialize the output.

tout = zeros(N,1);
tout(1) = t;
yout = zeros(N,size(y,1));
yout(1,:) = y.';
k = 1;
%hLine = plot(nan);  
% The main loop
while (k < N)
  %in which cycle we are
  cyclenum.Left = find(parameterSet.Left.transition.swingstance <= t+h,1,'last')+1; % the  cycle starts with the swing stance transition
  cyclenum.Right = find(parameterSet.Right.transition.swingstance <= t+h,1,'last')+1; % the  cycle starts with the swing stance transition
  % current phase value
  if pm*(t + h - tfinal) > 0 
    h = tfinal - t; 
    tout(k+1) = tfinal;
  elseif (t + h - parameterSet.Right.transition.swingstance(cyclenum.Right)) > 0
    h = parameterSet.Right.transition.swingstance(cyclenum.Right) - t;
    tout(k+1) = parameterSet.Right.transition.swingstance(cyclenum.Right);
  elseif (t + h - parameterSet.Left.transition.swingstance(cyclenum.Left)) > 0
    h = parameterSet.Left.transition.swingstance(cyclenum.Left) - t;
    tout(k+1) = parameterSet.Left.transition.swingstance(cyclenum.Left);
  else
    %tout(k+1) = t0 +k*h;
    tout(k+1) = t+h;
  end
  k = k + 1;
  %t
  s1 = feval(FunFcn, t, y); s1 = s1(:);
  s2 = feval(FunFcn, t + h/2, y + h*s1/2); s2=s2(:);
  s3 = feval(FunFcn, t + h/2, y + h*s2/2); s3=s3(:);
  s4 = feval(FunFcn, t + h, y + h*s3); s4=s4(:);
  y = y + h*(s1 + 2*s2 + 2*s3 +s4)/6;
  t = tout(k);
  
  waitbar(t/max(tspan),hw)
  % Restart the frequency (for numerical stability)
  % Find the time of the last changes
%   if(dtL > 1)
%       if(strcmp(type,'bi'))
%           [A, pA] = min(abs(parameterSet.Left.transition.stanceswing - t));
%           [B, pB] = min(abs(parameterSet.Left.transition.swingstance - t));
%           if(A < B)
%               dtL = A*1/parameterSet.Left.duration.swing(pB);
%           else
%               dtL = B*1/parameterSet.Left.duration.stance(pB);
%           end
%       elseif(strcmp(type,'mono'))
%           [B, pB] = min(abs(parameterSet.Left.transition.swingstance - t));
%           dtL = B*1/(parameterSet.Left.duration.stance(pB)+parameterSet.Left.duration.swing(pB));
%       end
%   end
%   if(dtR > 1)
%       if(strcmp(type,'bi'))
%           [A, pA] = min(abs(parameterSet.Right.transition.stanceswing - t));
%           [B, pB] = min(abs(parameterSet.Right.transition.swingstance - t));
%           if(A < B)
%               dtR = A*1/parameterSet.Right.duration.swing(pB);
%           else
%               dtR = B*1/parameterSet.Right.duration.stance(pB);
%           end
%       elseif(strcmp(type,'mono'))
%           [B, pB] = min(abs(parameterSet.Right.transition.swingstance - t));
%           dtR = B*1/(parameterSet.Right.duration.stance(pB)+parameterSet.Right.duration.swing(pB));
%       end
%   end
  
%   y(1:3:3*7) = dtL;
%   y(3*7+1:3:2*3*7) = dtR;
  yout(k,:) = y.';
%   % usercontrol
%   if(usercontrol == 1)
%       close all;
%       tout = tout(tout~=0);
%       notzero = yout(:,2)~=0;
%       yout = yout(notzero,:);
%       %plot(t(1:k),y(1:k,5));
%       break;
%   elseif(usercontrol ~= 0)
%       hold off;
%       plot(tout(1:k-1),yout(1:k-1,usercontrol));
%       fprintf([num2str(round(10*k/N)/10) ' percentage \n']);
%       hold on;
%       %plot(limb.Time.lTime(limb.Time.lTime < tout(k-1)),limb.Angle.(joint{(usercontrol-2)/3+1})(limb.Time.lTime < tout(k-1)),'r')
%       %title(joint{(usercontrol-2)/3+1});
%       %legend('Recorded angle','AWO');
%       usercontrol = 0;
%       
% hpop = uicontrol('Style', 'popup',...
%        'String', 'hsv|hot|cool|gray',...
%        'Position', [20 320 100 50],...
%        'Callback', 'setmap');
%   end
  %plot(t,y(3));
  %hold on;
  %drawnow
end
close all force;
for i=1:size(yout,2)
    yout((yout(:,i)>pi),i) = pi;
    yout((yout(:,i)<-pi),i) = -pi;
end
end
