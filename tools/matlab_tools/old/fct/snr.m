function [s cc]=snr(x,xtrue,segmentsize)
%Signal to Noise Ratio of time series
%
% [s cc] = snr (x, x_true, [segmentsize])
%
% x and x_true should match in size. Vectors or matrices
% are ok, as long as time is in the rows dimension.
% optional segmentsize: calculate SNR and CC in blocks of
% segmentsize. For SNR, the variance of the signal is taken
% from the entire data, while MSE is calculated within each block.
%
% s is snr
% cc is correlation coefficient R (NOT R^2)

if (~exist('segmentsize','var') || isempty(segmentsize))
    segmentsize=0;
end
   
size_x=size(x);
size_x_true=size(xtrue);

if(any(size_x~=size_x_true))
    error('Inputs must match in size');
end

bad=any(isnan(xtrue),2) | any(isinf(xtrue),2) | any(isnan(x),2) | any(isinf(x),2);
x(bad,:)=[];
xtrue(bad,:)=[];
if (sum(bad)>0)
        fprintf('Warning: dropped %d NaN or INF rows\n',sum(bad));
end
size_x=size(x);
err=xtrue-x;

if (segmentsize==0)
    s=var(xtrue)./mean(err.^2);

    if (nargout>1)
        temp=corrcoef([x xtrue]);
        if (size_x(1)>1)
            cc=diag(temp(size_x(2)+1:end,1:size_x(2)))';
        else
            cc=[];
        end
    end
else
    segments=0:segmentsize:size(x,1);
    for i=1:length(segments)-1
        r=segments(i)+1:segments(i+1);
        s(i,:)=var(xtrue(:,:))./mean(err(r,:).^2);
    end
    if (nargout>1)
        temp=corrcoef([x(r,:) xtrue(r,:)]);
        if (size_x(1)>1)
            cc(i,:)=diag(temp(size_x(2)+1:end,1:size_x(2)))';
        else
        end
    end    
end
s = 10*log10(s);