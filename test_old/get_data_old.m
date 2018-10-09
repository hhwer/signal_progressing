%%%  ��old��csv�ļ��У����洢��1*n��cell---data
%%%
data_path = '.\medical_data_jianhong';
data = {};
num = 0;
total_num_suspect = 0;
total_num = 0;
dirs = dir([data_path,'\*']);
for i=1:length(dirs)
    if (dirs(i).isdir && ~strcmp(dirs(i).name,'.') && ~strcmp(dirs(i).name,'..') )
        str_path=[data_path,'\',dirs(i).name];
        filename =  dir([str_path,'\*']);
        
        
        for ii = 1:length(filename)
            if (filename(ii).isdir && ~strcmp(filename(ii).name,'.') && ~strcmp(filename(ii).name,'..'))
                file_path = [str_path,'\',filename(ii).name];
                file = dir([file_path,'\*.csv']);
                file = [file,dir([file_path,'\*.xlsx'])];
                
                %�ϲ�ͬһ��ͬһ�����еĻ����ļ�csv
                a = [];
                for j = 1:length(file)
                    a = [a;xlsread([file_path,'\',file(j).name])];
                end
                
                local_num = size(a,1);      %%����������
                if size(a,2) < 5
                    continue
                end
                %���������Ļ����� '\medical_data\�Ͼ������ѱ�-Ҷ��-20180724\20182724\customs-2018224.cvs'
                %�ڶ������ļ����ɱ��滻  �����̶�
                pulse_path = [file_path,'\csv'];
                
                
                %���ݵ��ļ���
                pulse_file = dir([pulse_path,'\*.csv']);
                file_str = '';
                for file_idx = 1:size(pulse_file,1)
                    file_str = [file_str,pulse_file(file_idx).name];
                end
                
                %��ƥ���id����
                file_with_customid = 0;
                for k = 1:size(a,1)
                    id = num2str(a(k,1));
                    if contains(file_str,id)
                        file_with_customid = file_with_customid + 1;
                    end
                end
                
                if file_with_customid == length(pulse_file)
                    situation = 1;    %%id��ƥ����ȷ
                elseif sum(a(:,5)) == 0 && length(pulse_file) == local_num
                    situation = 2;    %%ȫΪδ���� �һ��������������ݸ���
                else
                    situation = 3;    %%ֻ�в���id��ƥ��
                end
                
                
                
                
                
                if situation == 1  || situation == 3
                    for k = 1:size(a,1)
                        id = num2str(a(k,1));
                        try
                            b = xlsread([pulse_path,'\',id,'.csv']);
                            %                             b = xlsread([file_path,'\',id,'\',id,'.csv']);
                            %pulse�Ļ����� '\medical_data\�Ͼ������ѱ�-Ҷ��-20180724\20182724\2018072411705\2018072411705.csv'
                            %�ڶ����Ĳ��ļ����滻  �����Ĳ�Ҫ����һ��   �����̶�
                        catch
                            continue;
                        end
                        if isempty(b)
                            continue
                        end
                        custom = struct();
                        custom.customid = a(k,1);
                        custom.pweeks = a(k,5);
                        custom.spressure = b(:,2);
                        custom.pulse = b(:,3);
                        custom.data = custom.pulse-custom.spressure;
                        %                         [samples,index ] = classify_samples( custom.data );
                        %                 [samples,index] = get_period(custom.data);
                        %                 custom.samples = samples;
                        %                 custom.index = index;
                        custom.datatime = b(:,1);
                        num = num+1;
                        data{num} = custom;
                    end
                else
                    for file_idx = 1:size(pulse_file,1)
                        file_i = pulse_file(file_idx);
                        b = xlsread([pulse_path,'\',file_i.name]);
                        custom = struct();
                        custom.customid = 0;
                        custom.pweeks = 0;
                        custom.spressure = b(:,2);
                        custom.pulse = b(:,3);
                        custom.data = custom.pulse-custom.spressure;
                        %                         [samples,index ] = classify_samples( custom.data );
                        %                 [samples,index] = get_period(custom.data);
                        %                 custom.samples = samples;
                        %                 custom.index = index;
                        custom.datatime = b(:,1);
                        num = num+1;
                        data{num} = custom;
                    end
                end
                total_num_suspect = total_num_suspect + local_num
            end
        end
    end
end






