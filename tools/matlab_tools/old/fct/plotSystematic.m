function plotSystematic(x,z,freqUniqu,pos,clim,start,h,xl,yl)
    %h=figure;
    hpos=get(h,'position');
    for i=1:6
        h2(i) = subplot(6,6,start+(i-1)*6);
        A{i} = [x(x(:,3) == freqUniqu(i),[1 2]) z(x(:,3) == freqUniqu(i))];

        if size(A{i},1) > 3
            [X,Y,Z] = plot3_new(A{i},4,4); surf(X,Y,freqUniqu(i)*ones(size(Z)),Z, 'EdgeColor', 'none');
            if size(X) ~= 0 
                %xlim([min(min(X)) max(max(X))])
                %ylim([min(min(Y)) max(max(Y))])
                xlim(xl)
                ylim(yl)
            end
            %title(['\omega:' num2str(freqUniqu(i))],'FontSize',16);
        end
            axis off;
            view(2);
            caxis(clim);
        %if i==1, colorbar('Location', 'West'); end
    end
    h2pos=get(h2,'position');
    for i=1:6
        set(h2(i),'units','pixels', 'Position', [(start-1)*hpos(3)/6 (6-i)*hpos(4)/6 96 hpos(4)/6] );
    end
    %saveas(h,name,'eps')
end