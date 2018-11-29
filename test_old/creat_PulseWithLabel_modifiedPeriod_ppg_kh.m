

% data = load('data_4106_total.mat');
% data = data.data;
opts.data = data;
opts1.data=data1;
n = length(data);
opts.plot = 0;
opts1.plot = 0;
quality = zeros(n,1);
quality1 = zeros(n,1);
label = [];
% age=[];
pulse = zeros(1,4000);
modifiedperiod =zeros(1,40,2);
label1 = [];
% age=[];
pulse1 = zeros(1,4000);
modifiedperiod1 =zeros(1,40,2);
min_length = 4000;
max_length = 0;
num = 0;
for i = 1:n
    [quality(i),index] = f2_neighbor_low(i,opts);
     [quality1(i),index1] = f2_neighbor_low(i,opts1);
            custom = opts.data{i};
            custom1=opts1.data{i};
        pulse_i = custom.pulse;
    local_length = length(pulse_i);
            max_length = max(max_length,local_length);
        min_length = min(min_length,local_length);
    if quality(i) == 1 && quality1(i)==1
        num = num+1;

        

        pulse(num,1:length(pulse_i)) = pulse_i;
        label(num,1) = custom.pweeks;
%         age(num,1) = custom.age;
        modifiedperiod(num,1:length(index),1:2) = index; 
                pulse1(num,1:length(pulse_i)) = custom1.pulse;
        label1(num,1) = custom1.pweeks;
%         age(num,1) = custom.age;
        modifiedperiod1(num,1:length(index),1:2) = index1; 
    end
end


