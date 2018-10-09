data = load('data_4106_total.mat');
data = data.data;
opts.data = data;
n = length(data);
opts.plot = 0;
quality = zeros(n,1);
label = [];
pulse = zeros(1,4000);
modifiedperiod =zeros(1,40,2);
num = 0;
for i = 1:n
    [quality(i),index] = f2_neighbor(i,opts);
    if quality(i) == 1
        num = num+1;
        custom = opts.data{i};
        pulse_i = custom.pulse;
        pulse(num,1:length(pulse_i)) = pulse_i;
        label(num,1) = custom.pweeks;
        modifiedperiod(num,1:length(index),1:2) = index; 
    end
end


