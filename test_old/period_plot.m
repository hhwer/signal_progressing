function [ idx,y ] = period_plot( x,opts )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
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

