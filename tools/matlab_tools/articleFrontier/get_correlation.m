function cc = get_correlation(data,opt_compareWith)
    cc = [];
    for i=1:size(data,3)
        temp=corr(data(:,:,i)')';
        cc(:,i) = temp(:,opt_compareWith);
    end
end