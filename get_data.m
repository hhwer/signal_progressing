%%%  ��csv�ļ��У����洢��1*n��cell---data
%%%
data_path = '.\medical_data';
data = {};
num = 0;
dirs = dir([data_path,'\*']);
for i=1:length(dirs)
    if (dirs(i).isdir && ~strcmp(dirs(i).name,'.') && ~strcmp(dirs(i).name,'..') )
        str_path=[data_path,'\',dirs(i).name];
        filename =  dir([str_path,'\*']);
        for ii = 1:length(filename)
            if (filename(ii).isdir && ~strcmp(filename(ii).name,'.') && ~strcmp(filename(ii).name,'..'))
                file_path = [str_path,'\',filename(ii).name];
                file = dir([file_path,'\*csv']);
                for j = 1:length(file)
                    a = xlsread([file_path,'\',file(j).name]); 
                    %���������Ļ����� '\medical_data\�Ͼ������ѱ�-Ҷ��-20180724\20182724\customs-2018224.cvs'
                    %�ڶ������ļ����ɱ��滻  �����̶�
                    for k = 1:size(a,1)
                        try
                            id = num2str(a(k,1));
                            b = xlsread([file_path,'\',id,'\',id,'.csv']);
                            %pulse�Ļ����� '\medical_data\�Ͼ������ѱ�-Ҷ��-20180724\20182724\2018072411705\2018072411705.csv'
                            %�ڶ����Ĳ��ļ����滻  �����Ĳ�Ҫ����һ��   �����̶�
                        catch
                            continue;
                        end
                        custom = struct();
                        custom.customid = a(k,1);
                        custom.pweeks = a(k,5);
                        custom.spressure = b(:,2);
                        custom.pulse = b(:,3);
                        custom.data = custom.pulse-custom.spressure;
                        [samples,index ] = classify_samples( custom.data );
%                         [samples,index] = get_period(custom.data); 
                        custom.samples = samples;
                        custom.index = index;
                        custom.datatime = b(:,1);
                        num = num+1;
                        data{num} = custom;
                    end
                end
            end
        end
    end
end





    
        
                
        