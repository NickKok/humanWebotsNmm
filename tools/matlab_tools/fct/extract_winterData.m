function winterData = extract_winterData(what)
    % WINTERDATA = EXTRACT_WINTERDATA(WHAT)
    % WHAT can be 'angle', 'torque', 'grf'
    if nargin == 0
        winterData = struct;
        winterData.angle = extract_winterData('angle');
        winterData.grf = extract_winterData('grf');
        winterData.torque = extract_winterData('torque');
        winterData.stance_percentage = struct();
        f=fields(winterData.grf);
        for i=1:length(f)
            winterData.stance_percentage.(cell2mat(f(i)))=find(diff(winterData.grf.(cell2mat(f(i))).data(:,2)~=0)==-1)*2;
        end
    else
        rep = '';
        if(strcmp(what,'angle'))
            temp=importdata('../../winter_data/winterdata_angle.csv');
            rep='joint_angles__';
        elseif(strcmp(what,'torque'))
            temp=importdata('../../winter_data/winterdata_torque.csv');
            rep='joint_moments_of_force__';
        elseif(strcmp(what,'power'))
            temp=importdata('../../winter_data/winterdata_power.csv');
            rep='joint_powers__';
        elseif(strcmp(what,'grf'))
            temp=importdata('../../winter_data/winterdata_grf.csv');
            rep='Grf__';
        else
            disp('undefined input');
        end
        legend_name=strsplit(cell2mat(temp.textdata(2,1)),',');
        legend_type=temp.colheaders;

        angles = struct;
        R=strsplit(cell2mat(temp.textdata(1,1)),',');
        R=R(~cellfun('isempty',R));
        num = size(temp.data,2)/length(R);
        for i=1:length(R)
            R(i) = strrep(R(i),'=','');
            R(i) = strrep(R(i),'(','_');
            R(i) = strrep(R(i),')','_');
            R(i) = strrep(R(i),' ','_');
            R(i) = strrep(R(i),rep,'');
            angles.(cell2mat(R(i)))=struct;
            angles.(cell2mat(R(i))).data=temp.data(:,1+(i-1)*num:i*num);
            angles.(cell2mat(R(i))).legend_name=legend_name(1+(i-1)*num:i*num);
            angles.(cell2mat(R(i))).legend_type=legend_type(1+(i-1)*num:i*num);
        end



        winterData = angles;

        %angles.data=angles_temp.data;
    end
end