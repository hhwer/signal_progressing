modifiedperiod=zeros(0,0,2);
fft_size = 256;
pulse = zeros(0,0);
label = zeros(1,0);
num = 0;
for i = 1:length(opts.data)
    [quality,good_index,index_best5] = f2_neighbor(i,opts);
    local_num = 0;
    local_period = zeros(1,0,2);
    local_pulse = zeros(1,0);
    if quality == 1
        num = num+1;
%         for j = 1:length(good_index)
        for j = 1:length(index_best5)
            if j > 9
                break
            end
            if good_index(j,2) ~= 0
                local_num = local_num+1;
                start_num = (local_num-1)*fft_size+1;
                end_num =local_num*fft_size;
                local_period(1,local_num,:) = [start_num,end_num];
%                 b = opts.data{i}.pulse(good_index(j,1):good_index(j,2));
                b = opts.data{i}.pulse(index_best5(j,1):index_best5(j,2));
                b_inter = interpft(b,fft_size);
                local_pulse(start_num:end_num) = interpft(b,fft_size);
            end
        end
        modifiedperiod(num,1:local_num,:) = local_period;
        pulse(num,1:end_num) = local_pulse;
        label(num,1)=opts.data{i}.pweeks;
    end
end