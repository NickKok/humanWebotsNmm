function plot_CoT(CoT,order)
%% Plot Cost of transport
bar([2.2,0*CoT(order)/80],'r');
hold on

errorbar(1,2.3,0.2,'b','LineWidth',10)

bar([0,CoT(order)/80]);
set(gca,'xtick',1:11);
set(gca,'xticklabel',{'H' 1:10});
ylabel('[Nkg^{-1}]');
title('Cost of transport');
end