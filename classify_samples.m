function [samples,index ] = classify_samples( a1 )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[samples,index] = get_period(a1);
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
wrong_peroid = [];
right_peroid = [];
for i = 1:m
    if index(i+1)-index(i) >4/3*expect_size || index(i+1)-index(i)< 2/3 * expect_size
        wrong_peroid = [wrong_peroid, i];
    else
        right_peroid = [right_peroid, i];
    end
end

num_right = length(right_peroid);

r1 = 1;
r2 = 0.55;
p1 = 0.1;
p2 = 0.4;
p3 = 0.3;
outlier1 = [];
outlier2 = [];
point = [];
count1 = -ones(m,1);
count2 = -ones(m,1);
for i = right_peroid
    for j = right_peroid
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
for i = right_peroid
    samples{i,2} = 2;
end
for i = outlier1
    samples{i,2} = 4;
end
for i = outlier2
    samples{i,2} = 3;
end
for i = point
    samples{i,2} = 1;
end
for i = wrong_peroid
    samples{i,2} = 5;
end   




end

