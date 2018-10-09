%%%将文件分组 


dst_path = 'choose_data';
dst_path1 = [dst_path,'\good'];
dst_path3 = [dst_path,'\bad'];
opts.plot = 1;
        
%%%  从old的csv文件中，并存储成1*n的cell---data
%%%
data_path = 'choose_data';
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
                
                %合并同一天同一人所有的汇总文件csv
                a = [];
                for j = 1:length(file)
                    a = [a;xlsread([file_path,'\',file(j).name])];
                end
                
                local_num = size(a,1);      %%汇总中人数
                if size(a,2) < 5
                    continue
                end
                %怀孕周数的汇总在 '\medical_data\南京华世佳宝-叶朵-20180724\20182724\customs-2018224.cvs'
                %第二三层文件名可被替换  层数固定
                pulse_path = [file_path,'\csv'];
                png_path = [file_path,'\png'];
                
                
                %数据的文件名
                pulse_file = dir([pulse_path,'\*.csv']);
                png_file = dir([png_path,'\*.png']);
                file_str = '';
                for file_idx = 1:size(pulse_file,1)
                    file_str = [file_str,pulse_file(file_idx).name];
                end
                
                %能匹配的id个数
                file_with_customid = 0;
                for k = 1:size(a,1)
                    id = num2str(a(k,1));
                    if contains(file_str,id)
                        file_with_customid = file_with_customid + 1;
                    end
                end
                
                if file_with_customid == length(pulse_file)
                    situation = 1;    %%id能匹配正确
                elseif sum(a(:,5)) == 0 && length(pulse_file) == local_num
                    situation = 2;    %%全为未怀孕 且汇总人数等于数据个数
                else
                    situation = 3;    %%只有部分id能匹配
                end
                
                
                
                
                
                if situation == 1  || situation == 3
                    for k = 1:size(a,1)
                        id = num2str(a(k,1));
                        try
                            pulse_name = [pulse_path,'\',id];
                            png_name = [png_path,'\',id];
                            b = xlsread([pulse_name,'.csv']);
                            %                             b = xlsread([file_path,'\',id,'\',id,'.csv']);
                            %pulse的汇总在 '\medical_data\南京华世佳宝-叶朵-20180724\20182724\2018072411705\2018072411705.csv'
                            %第二三四层文件名替换  第三四层要保持一致   层数固定
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
                        opts.data={custom};
                        k = f2_neighbor(1,opts);
                        if k == 3
                            path = dst_path3;
                        else
                            path = dst_path1;
                        end
                        copyfile([png_name,'.png'],path);
                        saveas(gcf,id,'jpg');
                        movefile([id,'.jpg'],path);
                    end
                else
                    for file_idx = 1:size(pulse_file,1)
                        file_i = pulse_file(file_idx);
                        png_i = png_file(file_idx);
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
                        opts.data={custom};
                        k = f2_neighbor(1,opts);
                        if k == 3
                            path = dst_path3;
                        else
                            path = dst_path1;
                        end
                        copyfile([png_path,'\',png_i.name],path);
                        A=isstrprop(png_i.name,'digit');
                        id=png_i.name(A);
                        saveas(gcf,id,'jpg');
                        movefile([id,'.jpg'],path);
                    end
                end
                total_num_suspect = total_num_suspect + local_num
            end
        end
    end
end






