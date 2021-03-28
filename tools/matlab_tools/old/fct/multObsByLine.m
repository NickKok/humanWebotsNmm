function x = multObsByLine(x,a)
    for I=1:size(x,1)
        x(I) = a*(x(I,:));
    end
end