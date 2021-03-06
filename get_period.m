function [ samples,idx ] = get_period( x,opts )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin < 2
    opts = struct;
end
[idx,y] = get_index(x,opts);
n = length(idx)-1;
samples = cell(n,2);
for i = 1:n
    samples{i,1} = x(idx(i):idx(i+1)-1);
    samples{i,2} = 0;
end
try
    if opts.plot == 1
        figure()
        plot(x,':')
        hold on
        plot(idx,y,'ro')
        hold off
    end
end
end