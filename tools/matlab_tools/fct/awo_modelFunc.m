classdef awo_modelFunc < handle
    properties
        s = struct;
        ds = struct;
        knot = 100;
    end
    
    methods
        function obj = awo_modelFunc(varargin)
            % AWO_MODELFUNC(x,T) given the input vector x, creates a periodic function handler  
            % of period T (default T=1). Can also return a derivatives function
            % handler.
            %
            % g = awo_modelFunc(x)
            % g = awo_modelFunc(x,T)
            % [g,dg] = awo_modelFunc(x)
            % [g,dg] = awo_modelFunc(x,T)
            %
            % x : Input vector
            % T : Period
            
            if(nargin < 2)
                T = 1;
            else
                T = varargin{2};
            end
            obj.knot = length(varargin{1});
            t = linspace(0,T,obj.knot);
            obj.s = spline(t,varargin{1});
            obj.ds = obj.s;
            obj.ds.coefs = [3*obj.s.coefs(:,1) 2*obj.s.coefs(:,2) obj.s.coefs(:,3)];
            obj.ds.order = 3;
        end
        function y = g(obj,varargin)
            y = ppval(obj.s,mod(varargin{1},1));
        end
        function y = dg(obj,varargin)
            y = ppval(obj.ds,mod(varargin{1},1));
        end
        function y = checkDerivatives(obj)
            % check if spline derivatives is good
            t = linspace(0,1,1000);
            cc = corrcoef((obj.g(t(2:end))-obj.g(t(1:end-1)))/(t(2)-t(1)),obj.dg(t(2:end)));
            y = cc(2,1);
        end
    end
end