function [ d] = VecDistance1( x1,x2 )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
z = x1-x2;
c = z(1);
d = sqrt(sum((z-c).^2));

end