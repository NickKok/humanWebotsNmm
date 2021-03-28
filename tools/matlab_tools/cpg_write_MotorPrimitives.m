%% Get Stereotyped shape
id = 1;
dir = [config.raw_filedir  '/session4']; % directory where to look for raw files
analysis_MusclesActivity
%% Build model function
mp1 = awo_modelFunc(moto_primitives(:,1));
mp2 = awo_modelFunc(moto_primitives(:,2));
mp3 = awo_modelFunc(moto_primitives(:,3));
mp4 = awo_modelFunc(moto_primitives(:,4));
%% Generate signals
mkdir MP_test
for i=1:size(H,1)
fileID = fopen([ 'MP_test/' num2str(i-1) '.txt'],'w');
mp = eval(['mp' num2str(i) ]);
fprintf(fileID,'%1.3f\n',mp.g(linspace(0,1,1000)));
fclose(fileID);

fileID = fopen([ 'MP_test/' num2str(i-1) '_derivative.txt'],'w');
fprintf(fileID,'%1.3f\n',mp.g(linspace(0,1,1000)));
fclose(fileID);
end

fileID = fopen('MP_test/weights.txt','w');
fprintf(fileID,'%1.3f %1.3f %1.3f %1.3f\n',H');
fclose(fileID);
