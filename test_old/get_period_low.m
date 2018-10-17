function [ samples,idx_low ] = get_period_low( x,opts )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin < 2
    opts = struct;
end
[idx,y] = get_index(x,opts);
n = length(idx);
idx = [1;idx;length(x)];
idx_low = zeros(n+1,1);
y_low = zeros(n+1,1);
for i = 1:n+1
    local_b = x(idx(i):idx(i+1));
    k = get_index_low(local_b);
    idx_low(i) = k + idx(i)-1;
    y_low(i) = x(idx_low(i));
end
samples = cell(n,1);
for i = 1:n
    samples{i,1} = x(idx_low(i):idx_low(i+1));
end
try
    if opts.plot == 1
%         figure()
        subplot(2,1,1)
        plot(x,':')
        hold on
        plot(idx_low,y_low,'ro')
        hold off
    end
end
end