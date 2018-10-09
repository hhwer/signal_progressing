function [ train_data ] = f1( n1 ,opts)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


r1 = 1;  %��Ⱥ��İ뾶
r2 = 0.55;  %�ۼ���İ뾶
p1 = 0.1;   %�ȼ�4����Ⱥ������򺬵����
p2 = 0.4;  %�ȼ�3����Ⱥ������򺬵����
p3 = 0.3;  %�ȼ�1�ľۼ�������򺬵����

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
    gene_features = opts.data;
catch
    gene_features = load('pulsewithlabel0807.mat');
    gene_features = gene_features.gene_features;
end
opts.plot=1;
train_data = [];
train_label = [];
num=1;
a1 = gene_features{n1};
a1 = a1(1:3990);
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
        dist(i,j) = VecDistance1(data_one(i,:),data_one(j,:));
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
hold on
for i = right_peroid
    b = samples{i};
    b_x = index(i):index(i+1)-1;
    line2 = plot(b_x,b,'b');
    samples{i,2} = 2;
%     plot(b_x,b,'b');
end   
if length(right_peroid)==0
    line2 = plot(1,a1(1),'b');
end
hold on
for i = outlier1
    b = samples{i};
    b_x = index(i):index(i+1)-1;
    line4 = plot(b_x,b,'black','LineWidth',2);
    samples{i,2} = 4;
%     plot(b_x,b,'black','LineWidth',2);
end
if length(outlier1)==0
    line4 = plot(1,a1(1),'black','LineWidth',2);
end
hold on
for i = outlier2
    b = samples{i};
    b_x = index(i):index(i+1)-1;
    line3 = plot(b_x,b,'red','LineWidth',1.5);
    samples{i,2} = 3;
%     plot(b_x,b,'red','LineWidth',1.5);
end
if length(outlier2)==0
    line3 = plot(1,a1(1),'red','LineWidth',1.5);
end
hold on
for i = point
    b = samples{i};
    b_x = index(i):index(i+1)-1;
    line1 = plot(b_x,b,'yellow','LineWidth',1);
    samples{i,2} = 1;
    c = interpft(b,fft_size);
    
% %     ��һ�������Լ�pweeks����train_data
%     train_data(num,1:fft_size) = (c-min(c))/(max(c)-min(c));
%     train_label(num) = gene_features{n,2};
    num = num +1;
    plot(b_x,b,'yellow','LineWidth',1);
end
if length(point)==0
     line1 =  plot(1,a1(1),'yellow','LineWidth',1);
end
hold on
for i = wrong_peroid
    b = samples{i};
    b_x = index(i):index(i+1)-1;
    line5 = plot(b_x,b,':','LineWidth',0.0001);
    samples{i,2} = 5;
%     plot(b_x,b,'black','LineWidth',0.0001);
end   
if length(wrong_peroid)==0
    line5 = plot(1,a1(1),':','LineWidth',0.0001);
end
legend([line1,line2,line3,line4,line5],'1','2','3','4','5')

end

% figure()
% % plot(reshape(dist,m^2,1),'.')
% histogram(dist)

end