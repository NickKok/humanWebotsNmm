function x = integrals(y,iC)
    x(1) = iC;
%     x(2) = y(1)+x(1)
%     x(3) = y(2)+y(1)+x(1) = y(2)+x(2)
%     x(4) = y(3)+y(2)+y(1)+x(1) = y(3)+(3)
    for i=2:size(y)
        x(i) = y(i-1)+x(i-1);
    end
end