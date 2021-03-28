function data = extract_atHofData(speed)
    A=load('../../emg_data/allmeas.mat');
    article2real=[1,11,4,14,12,7,8,6,9,10,5,2,3,13];
    f=fields(A);
    l =  size(A.(cell2mat(f(1))),1);
    atHofData = zeros(length(f),l);
    data = zeros(7,l);
    for i=1:length(f)
        d=A.(cell2mat(f(i)));
        atHofData(i,:) = d(:,speed);
    end
    %HF 8,9 : 7,9
    %GLU 12,13 : 5,14 
    %VAS 6,7 : 6,8
    %HAM 10,11 : 10,2
    %GAS 2,3 : 12,13
    %SOL 1 : 1
    %TA 5 : 11
    data(1,:) = 0.5*(atHofData(7,:)+atHofData(9,:));
    data(2,:) = 0.5*(atHofData(5,:)+atHofData(14,:));
    data(3,:) = 0.5*(atHofData(6,:)+atHofData(8,:));
    data(4,:) = 0.5*(atHofData(10,:)+atHofData(2,:));
    data(5,:) = 0.5*(atHofData(12,:)+atHofData(13,:));
    data(6,:) = atHofData(1,:);
    data(7,:) = atHofData(11,:);
    data = atHofData';
end
