function [out data] = split_normalize(in)
    % SPLIT_NORMALIZE() returns a normalized matrix of the same dimension 
    % than Input matrix. The normalization is done by cycle by removing
    % the mean and dividing by the std deviation.
    %
    % An optional output argument is the normalization table.
    % The input should be the output of the split_byEvent function
    %
    %  out = split_normalize(Input)
    %
    % Input : input vector (output of split_byEvent)
    
    if (nargin == 1)
        me = split_getMean(in);
    end
    data = struct;
    amp = std(in,0,length(size(in)));
    off = mean(in,length(size(in)));
    if (length(size(in)) == 4)
        
        ampRepMat(:,:,:,1) = amp;
        offRepMat(:,:,:,1) = off;

        ampRepMat = repmat(ampRepMat, [ 1,1,1,size(in,4)]);
        offRepMat = repmat(offRepMat, [ 1,1,1,size(in,4)]);

        out = (in - offRepMat)./ampRepMat;

        if (size(in,2) == 1)
            out = reshape(out,size(in,1),size(in,3),size(in,4));
            off = reshape(off,size(in,1),size(in,3));
            amp = reshape(amp,size(in,1),size(in,3));
        end
    else

        ampRepMat(:,:,1) = amp;
        offRepMat(:,:,1) = off;

        ampRepMat = repmat(ampRepMat, [ 1,1,size(in,3)]);
        offRepMat = repmat(offRepMat, [ 1,1,size(in,3)]);

        out = (in - offRepMat)./ampRepMat;

        if (size(in,1) == 1)
            out = reshape(out,size(in,2),size(in,3));
            off = reshape(off,size(in,2),1);
            amp = reshape(amp,size(in,2),1);
        end
    end
    
    data.offset = off;
    data.amplitude = amp;    
end