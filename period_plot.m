function [ idx,y ] = period_plot( x,opts )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if nargin < 2
    opts = struct;
end
[idx,y] = get_index(x,opts);
% figure()
plot(x)
hold on
plot(idx,y,'ro')
hold off
end

