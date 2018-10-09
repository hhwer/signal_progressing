function [ samples,idx ] = get_period( x,opts )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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