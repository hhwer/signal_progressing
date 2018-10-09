function [y  ] = get_low_point( n1,opts )

r1 = 1;  %离群点的半径
r2 = 0.5;  %聚集点的半径
p1 = 0.1;   %等级4的离群点的领域含点比例
p2 = 0.4;  %等级3的离群点的领域含点比例
p3 = 0.3;  %等级1的聚集点的领域含点比例

try
    r1 = opts.r1;
    r2 = opts.r2;
    p1 = opts.r1;
    p2 = opts.r2;
    p3 = opts.r3;
end


close
% gene_features = load('data.mat');
% a = gene_features.data;


try
    a = opts.data;
catch
    a = load('pulsewithlabel0806.mat');
    a = a.gene_features;
end



opts.plot=1;
num=1;




name = [];

if isstr(n1)
    name = n1;
    for i = 1:length(a)
        if num2str(a{i}.customid) == n1
            n1 = i;
            break
        end
    end
    a1 = a{n1}.data;
else
    a1 = a{n1};
    try
        name = num2str(a1.customid);
        a1 = a1.data;
    catch
        a1 = a1(1:3900);
    end
end


% n1 = length(gene_features);
for n = n1:n1
% a1 = a{n}.data;
[samples,index] = get_period(a1,opts);
m = length(samples);
dist = zeros(m);
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
noise_period=[];
right_period = [];
for i = 1:m
    local_size = (index(i+1)-index(i))  / expect_size;
    local_sample = samples{i}; 
    if local_size >4/3 || local_size< 2/3 
        wrong_period = [wrong_period, i];
        wrong_size = wrong_size + local_size;
    elseif abs(local_sample(1)-local_sample(length(local_sample))) ...
                > 1/15  *(max(local_sample -min(local_sample)))
        wave_period = [wave_period, i];
%     elseif 
%         noise_period = []
    else
        right_period = [right_period, i];
    end
end

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

[max_point,max_point_index] = max(count2(point));
max_point_index = point(max_point_index);
i = max_point_index;
    b = samples{i};
    b_x = index(i):index(i+1)-1;
end
para2 = -min(b)-(max(b)-min(b))/30;  
[y,idx] = findpeaks(-b,'minpeakdistance',1,'MinPeakHeight',para2);
hold on
% plot(b);

plot(idx+index(i)-1,-y,'o')
y = length(y);
    