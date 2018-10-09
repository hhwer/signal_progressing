n = 10;
m = 1;
fft_size = 128;
a1 = data{n}.data;
lable1= data{n}.pweeks;
% a=load('pulsewithlabel0806.mat');
% a=a.gene_features;
% [a1,lable1] = a{n,1:2};

[samples,index] = get_period(a1,lable1);
for m =1:length(samples)
% for m = 1:1
b = samples{m};
b_x = 0:1/(length(b)-1):1;
b_x = b_x+m-1;
plot(b_x,b,'black')
hold on
d_x = 0:1/(fft_size-1):1;
d_x=d_x+m-1;
d = interpft(b,fft_size);
plot(d_x,d,'red');
end
hold off

