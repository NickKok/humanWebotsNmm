function [stance_percentage, double_stance] = extract_stancePercentage(footFall,varargin)
    if nargout == 2
        if nargin == 2
            knot = varargin{1};
        else
            knot = 1000;
        end
        out_left = signal_analysis(footFall,footFall,1,knot);

        meanfootFall_left = out_left.signalMean(1,:)';
        meanfootFall_left(end)=0;
        stance_percentage = max(find(meanfootFall_left>0.9))/knot*100;

        if nargout == 2
        out_right = signal_analysis(footFall,footFall,2,knot);

        meanfootFall_right = out_right.signalMean(1,:)';
        meanfootFall_right(1)=0;

        double_stance = (meanfootFall_right+meanfootFall_left)>1.9;
        end
    else
        [gr1,gr2] = extract_goldenRation(footFall);
        stance_percentage= 100*( 0.5/gr1(1)+0.5/gr2(1));
    end
end