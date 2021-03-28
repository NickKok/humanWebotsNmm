function out = split_getMean(in)
    % SPLIT_GETMEAN() returns the mean cycles of the input.
    % The input should be the output of the split_byEvent function
    %
    %  out = split_getMean(Input)
    %
    % Input : input vector (output of split_byEvent)
    
    if (length(size(in)) == 4)
        out = reshape(mean(in,3),size(in,1),size(in,2),size(in,4));
        if(size(in,2) == 1)
            out = reshape(out,size(out,1),size(out,3));
        end
    else
        out = reshape(mean(in,2),size(in,1),size(in,3));
        if(size(in,1) == 1)
            out = reshape(out,size(out,2),1);
        end
    end
end
