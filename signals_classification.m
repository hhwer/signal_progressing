%%%将文件分组 

source_path = 'D:\Git\MachineLearning\DeepLearning\choose_data\all_data\';
dst_path = 'D:\Git\MachineLearning\DeepLearning\choose_data';
dst_path1 = [dst_path,'\good'];
dst_path3 = [dst_path,'\bad\bad'];
dst_path4 = [dst_path,'\bad\bad_Amplitude'];
opts.plot = 1;
data = load('data.mat');
data = data.data;
opts.data = data;
for i = 1:152
    myid = num2str(data{i}.customid);
    filename = [source_path,myid];
    k = f2(i,opts);
    if k == 4
        path = dst_path4;
    elseif k == 3
        path = dst_path3;
    else
        path = dst_path1;
    end
    copyfile(filename,path);
    saveas(gcf,myid,'jpg');
    movefile([myid,'.jpg'],path);
end
        