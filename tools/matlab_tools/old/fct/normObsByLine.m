function y = normObsByLine(x)
    y = zeros(1,size(x,1));
    for I=1:size(x,1)
        y(I) = norm(x(I,:));
    end
end