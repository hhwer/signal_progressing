data_path = '.\medical_data';
opts.plot=0;
data = {};
worker_num = 0;
work_name = {};
work_total_pulse_num = [];
work_select_pulse_num = [];
work_wrong_id_num = [];
work_good_rate = [];
work_wrong_id_rate = [];
work_wrong_length_num = [];
work_bad_rate = [];
dirs = dir([data_path,'\*']);
i=3;

        str_path=[data_path,'\',dirs(i).name];
        filename =  dir([str_path,'\*']);
ii=3;
file_path = [str_path,'\',filename(ii).name];
                file = dir([file_path,'\*.csv']);
                
                a={};
                for j = 1:length(file)
                    a = [a;get_GoodIdWithPweeks([file_path,'\',file(j).name])];
                end
                %怀孕周数的汇总在 '\medical_data\南京华世佳宝-叶朵-20180724\20182724\customs-2018224.cvs'
                %第二三层文件名可被替换  层数固定
                 
                pulse_path = [file_path,'\csv\HK-2010'];
                pulse_file = dir([pulse_path,'\*.csv']);
                
                select_num = 0;  
                pulse_num = length(pulse_file);
                total_id = size(a,1);
                wrong_id = total_id-pulse_num/2;
                
                
                for k = 1:size(a,1)
                    id = a{k,1};
                    pweeks = a{k,2};
                    for kk = 1:pulse_num
                        pulse_i = pulse_file(kk);
                        name_i = pulse_i.name;
                        if contains(string(name_i),id)
                            try
                                b = xlsread([pulse_path,'\',pulse_i.name]);
                                custom = struct();
                                custom.customid = id;
                                custom.pweeks = pweeks;
                                custom.pulse = b(:,2);
                                pulse_length = length(custom.pulse);
                                if pulse_length > 4500
                                    continue
                                end
                                opts.data={custom};
                                quality = f2_neighbor(1,opts);
                                if quality == 1
                                    select_num = select_num+1;
                                end
                            catch
                                continue
                            end
                        end
                    end
                end
                worker_num = worker_num+1;
                work_name{worker_num} = filename(ii).name;
                work_total_pulse_num(worker_num) = pulse_num;
                work_select_pulse_num(worker_num) = select_num;
                work_wrong_id_num(worker_num) = wrong_id;
                work_yield_rate(worker_num) = select_num/pulse_num;
                work_wrong_id_rate(worker_num) = wrong_id/total_id;
                

