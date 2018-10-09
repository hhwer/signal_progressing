%%%  从csv文件中，并存储成1*n的cell---data
%%%
data_path = '.\medical_data';
data = {};
num = 0;
total_num_suspect = 0;
total_num = 0;
filename = dir([data_path,'\*']);
% for i=1:length(dirs)
%     if (dirs(i).isdir && ~strcmp(dirs(i).name,'.') && ~strcmp(dirs(i).name,'..') )
%         str_path=[data_path,'\',dirs(i).name];
%         filename =  dir([str_path,'\*']);
        for ii = 1:length(filename)
            if (filename(ii).isdir && ~strcmp(filename(ii).name,'.') && ~strcmp(filename(ii).name,'..'))
                file_path = [data_path,'\',filename(ii).name];
                file = dir([file_path,'\*.csv']);
                for j = 1:length(file)
                    a = xlsread([file_path,'\',file(j).name]); 
                    local_num = size(a,1);
                    total_num_suspect = total_num_suspect + local_num;
                    %怀孕周数的汇总在 '\medical_data\南京华世佳宝-叶朵-20180724\20182724\customs-2018224.cvs'
                    %第二三层文件名可被替换  层数固定
                    pulse_path = [file_path,'\csv'];
                    
                    
                    %count file number
                    pulse_file = dir([pulse_path,'\*.csv']);
                    file_str = '';
                    for file_i = pulse_file
                        file_str = [file_str,file_i.name];
                    end
                    file_with_customid = 0;
                    
                    
                    if sum(a(:,5)) == 0
                        file_with_customid = size(a,1);
                        num = num + file_with_customid;
                        data{num} = custom;
                                            
                    else

                        for k = 1:size(a,1)
                            id = num2str(a(k,1));
                            %                         id_name = [id,'.csv'];
                            if contains(file_str,id)
                                file_with_customid = file_with_customid + 1;
                                
                                %                             b = xlsread([pulse_path,'\',id,'.csv']);
                                % %                             b = xlsread([file_path,'\',id,'\',id,'.csv']);
                                %                             %pulse的汇总在 '\medical_data\南京华世佳宝-叶朵-20180724\20182724\2018072411705\2018072411705.csv'
                                %                             %第二三四层文件名替换  第三四层要保持一致   层数固定
                            else
                                continue;
                            end
                            custom = struct();
                            %                         custom.customid = a(k,1);
                            %                         custom.pweeks = a(k,5);
                            %                         custom.spressure = b(:,2);
                            %                         custom.pulse = b(:,3);
                            %                         custom.data = custom.pulse-custom.spressure;
                            % %                         [samples,index ] = classify_samples( custom.data );
                            %                         [samples,index] = get_period(custom.data);
                            %                         custom.samples = samples;
                            %                         custom.index = index;
                            %                         custom.datatime = b(:,1);
                            num = num+1;
                            data{num} = custom;
                        end
                    end
                    total_num = length(data);
                    %                     fprintf(['local_num=',num2str(local_num),'\n']);
                    if file_with_customid == length(pulse_file)
                        %                         disp('right');
                    else
                        disp(pulse_path);
                        disp(file_with_customid)
                        disp(length(pulse_file))
                    end
                end
            end
        end
