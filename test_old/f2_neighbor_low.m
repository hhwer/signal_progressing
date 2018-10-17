function [ quality,good_index, index_best5 ] = f2_neighbor_low( n1 ,opts)
%判断数据的质量
%   以相邻相似数据最多为优
%input
%     n1     int                   数据的序号(在opts.data中)
%              or    cahr         数据的customid
%
%     opts    struct
%           opts.plot      logic   是否绘图  admin=1
%           opts.data       1*n cell             每个cell{k}中是相应的数据对应的stuct
%                                 or    n*2 cell      opts.data{k,1} {k,2}
%                                          分别是第k个数据的pulse和label
%                                  缺省值为0806中的数据
%
%output    
%      quality        int    1(优秀的数据，好的周期超过9个)，3(好的周期数列过少),4(单周期振幅超过1000)
%                                   
%
r1 = 1;  %离群点的半径
r2 = 0.4;  %聚集点的半径        r2 r3  old数据里为0.4  new 里0.55
r3 = 0.4;     %以最优为中心的聚集半径
p1 = 0.1;   %等级4的离群点的领域含点比例
p2 = 0.4;  %等级3的离群点的领域含点比例
p3 = 0.2;  %等级1的聚集点的领域含点比例   old  0.3   new 0.1
Max_continue_num = 3;
Total_num = 5;

para_noise = 7;
para_noise = 128/para_noise;
para_wave = 1/10;

try
    r1 = opts.r1;
    r2 = opts.r2;
    r3 = opts.r3;
    p1 = opts.r1;
    p2 = opts.r2;
    p3 = opts.r3;
end


close


try
    a = opts.data;
catch
    a = load('pulsewithlabel0806.mat');
    a = a.gene_features;
end

if nargin < 2
    opts.plot = 1;
else
    if ~isfield(opts,'plot')
        opts.plot=1;
    end
end



index_best5 = zeros(5,2);

name = [];

if isstr(n1)
    name = ['customid= ',n1];
    for i = 1:length(a)
        if num2str(a{i}.customid) == n1
            n1 = i;
            break
        end
    end
    a1 = a{n1}.pulse;
else
    a1 = a{n1};
    try
        name = ['customid=',num2str(a1.customid)];
%         a1 = a1.data;
        a1 = a1.pulse;
    catch
%         a1 = a1(1:3900);
    end
end

for n = n1:n1
    [samples,index] = get_period_low(a1,opts);
    if opts.plot
        hold on
    end
    m = length(samples);
    dist = zeros(m);
    dist_one = zeros(m);
    fft_size = 128;
    data_one = zeros(m,fft_size);
    for i = 1:m
        data_one(i,:) = interpft(samples{i},fft_size);
    end
    max_data = max(max(data_one));
    min_data = min(min(data_one));
    data_one = (data_one-min_data)/ (max_data-min_data);
    for i = 1:m
        for j = i:m
            dist(i,j) = VecDistance(data_one(i,:),data_one(j,:));
            dist(j,i) = dist(i,j);
        end
    end
    
    expect_size = mean(index(2:m+1)-index(1:m));
    wrong_period = [];
    wrong_size = 0;
    wave_period =[];
    noise_period =[];
    right_period = [];
    
    for i = 1:m
        local_size = (index(i+1)-index(i))  / expect_size;
%         local_sample = samples{i};
        local_sample= a1(index(i):index(i+1)+1);
        [~,max_idx] = max(local_sample);
        
        
        if local_size >4/3 || local_size< 2/3
            wrong_period = [wrong_period, i];
            wrong_size = wrong_size + local_size;
        elseif abs(local_sample(1)-local_sample(length(local_sample))) ...
                > para_wave  *(max(local_sample -min(local_sample)))
            wave_period = [wave_period, i];
        else
            b = -local_sample(max_idx:length(local_sample));
            para2 = max(b)-(max(b)-min(b))/30;
            para3 = max(b)-(max(b)-min(b))/10;
            [y,idx] = findpeaks(b,'minpeakdistance',1,'MinPeakHeight',para2);
            low_point_idx = find(b>para3);
            if  length(y) >=  (index(i+1)-index(i))/para_noise ||  ...
                length(low_point_idx) >= (index(i+1)-index(i))/2 || ...
                low_point_idx(length(low_point_idx))-low_point_idx(1) >= (index(i+1)-index(i))/2
                
%             if  length(y) >=  (index(i+1)-index(i))/para_noise
                noise_period = [noise_period, i];
            else
                right_period = [right_period, i];
            end
        end
    end     %%wave and noise
    
    num_right = length(right_period);
    
    
    
    outlier1 = [];
    outlier2 = [];
    point = [];
    count1 = -ones(m,1);
    count2 = -ones(m,1);
    for i = right_period
        for j = right_period
            if dist(i,j) <= r1
                count1(i) = count1(i)+1;
                
                if dist(i,j) <= r2
                    count2(i) = count2(i)+1;
                    dist_one(i,j) = 1;
                end
            end
        end
        if count1(i) < p2*num_right
            if count1(i) < p1*num_right
                outlier1 = [outlier1,i];
            else
                outlier2 = [outlier2,i];
            end
        end
        if count2(i) > p3*num_right
            point = [point,i];
        end
    end
    
    
    
    
    for i = right_period
        b = samples{i};
        b_x = index(i):index(i+1);
        if opts.plot
            
            line2 = plot(b_x,b,'b');
        end
        samples{i,2} = 2;
    end
    if length(right_period)==0
        if opts.plot
            line2 = plot(1,a1(1),'b');
        end
    end
    for i = outlier1
        b = samples{i};
        b_x = index(i):index(i+1);
        if opts.plot
            line4 = plot(b_x,b,'black','LineWidth',2);
        end
        samples{i,2} = 4;
    end
    if length(outlier1)==0
        if opts.plot
            line4 = plot(1,a1(1),'black','LineWidth',2);
        end
    end
    for i = outlier2
        b = samples{i};
        b_x = index(i):index(i+1);
        if opts.plot
            line3 = plot(b_x,b,'red','LineWidth',1.5);
        end
        samples{i,2} = 3;
    end
    if length(outlier2)==0
        if opts.plot
            line3 = plot(1,a1(1),'red','LineWidth',1.5);
        end
    end
    for i = wrong_period
        b = samples{i};
        b_x = index(i):index(i+1);
        if opts.plot
            line5 = plot(b_x,b,':','LineWidth',0.0001);
        end
        samples{i,2} = 5;
    end
    if length(wrong_period)==0
        if opts.plot
            line5 = plot(1,a1(1),':','LineWidth',0.0001);
        end
    end
    
    for i = wave_period
        b = samples{i};
        b_x = index(i):index(i+1);
        if opts.plot
            line_wave = plot(b_x,b,'m','LineWidth',0.1);
        end
        samples{i,2} = 5;
    end
    if length(wave_period)==0
        if opts.plot
            line_wave = plot(1,a1(1),'m','LineWidth',0.1);
        end
    end
    
    for i = noise_period
        b = samples{i};
        b_x = index(i):index(i+1);
        if opts.plot
            line_noise = plot(b_x,b,':m','LineWidth',2);
        end
        samples{i,2} = 5;
    end
    if length(noise_period)==0
        if opts.plot
            line_noise = plot(1,a1(1),':m','LineWidth',2);
        end
    end
    
    local_continue_num =[];
    
 
    for i = point
        b = samples{i};
        b_length = length(b);
        scale = max(b)-min(b);
        b_x = index(i):index(i+1);
        for j = right_period
            b1 = samples{j};
            b1_length = length(b1);
            if dist_one(i,j) && max(abs((b1(1)+b1(b1_length))/2 - (b(1)+b(b_length))/2),abs(max(b1)-max(b)))  > 1/10*scale
                dist_one(i,j) = 0;
            end
        end
        if sum(dist_one(i,:)) >= Total_num
            b_neighbor = find(dist_one(i,:)==1);
            local_continue_num(i) = max_continue_num(b_neighbor);
        end
    end
    
    point1 = [];
    if ~isempty(local_continue_num)
        
        
        [max_point,max_point_index] = max(local_continue_num);
        
        
        %         max_point_index = point(max_point_index);
        i = max_point_index;
        b = samples{i};
        %         b_length = length(b);
        %         scale = max(b)-min(b);
        b_x = index(i):index(i+1);
        if opts.plot
            line0 = plot(b_x,b,'g','LineWidth' ,4);
        end
        distToStandard = zeros(length(point1));
        num_distToStandard = 0;
        for j = right_period
            b1 = samples{j};
            dist_ij = dist(i,j);
            if dist_ij <= r3
                point1 = [point1,j];
                num_distToStandard = num_distToStandard+1;
                distToStandard(num_distToStandard) = dist_ij;
            end
        end
        
        [~,y] = sort(distToStandard);
        for i = 1:5
            idx = point1(y(i));
            index_best5(i,:) = [index(idx),index(idx+1)];
        end
    else
        max_point = 0;
        if opts.plot
            line0 = plot(1,a1(1),'g','LineWidth' ,4);
        end
    end
    
    
    
    
    good_period_num=0;
    good_index =zeros(length(point),2);
   

    for i = point1
        good_period_num = good_period_num +1;
        b = samples{i};
        b_x = index(i):index(i+1);
        good_index(good_period_num,:) = [index(i),index(i+1)];
        if opts.plot
            line1 = plot(b_x,b,'yellow','LineWidth',1);
        end
        samples{i,2} = 1;
        % %     将一个周期以及pweeks加入train_data
        %     c = interpft(b,fft_size);
        %     train_pulse(num,1:fft_size) = (c-min(c))/(max(c)-min(c));
        %     train_label(num) = a{n,2};
       
        
    end
    if length(point1)==0
        if opts.plot
            line1 =  plot(1,a1(1),'yellow','LineWidth',1);
        end
    end
    
    if opts.plot
        legend([line1,line2,line3,line4,line5,line_wave,line_noise],...
                        '1','2','3','4','5','line\_wave','line\_noise'...
                        ,'Orientation','horizontal','Location','SouthOutside')
    end
end

quality = 3;
if max_point >= Max_continue_num
    quality = 1;
end
% try
%     i = max_point_index;
%     b = samples{i};
%     if max(b)-min(b) > 1000
%         quality = 4;
%     end
% end



% % figure()
if opts.plot
    subplot(2,1,2)
    start_index = 0;
    end_index = 0;
    for i = point1
        start_index = end_index+1;
        end_index = start_index+index(i+1)-index(i);
        plot(start_index:end_index,samples{i},'y')
        hold on
    end
end
% %     

if opts.plot
    suptitle([name ,' quality=',num2str(quality)])
end
end