function format_boxplot(hfig)
    box = findobj(hfig,'Tag','Box');
    whisker = findobj(hfig,'Tag','Whisker');
    median = findobj(hfig,'Tag','Median');
    outlier = findobj(hfig,'Tag','Outliers');
    set(box(:), 'linewidth',8);
    set(whisker(:), 'linewidth',4, 'Color', [0.3 0.3 0.3]);
    set(outlier(:), 'linewidth',3);
    set(median(:), 'linewidth',3, 'Color', [0.3 0.3 0.3]);
end