function [ d] = VecDistance1( x1,x2 )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
z = x1-x2;
c = z(1);
d = sqrt(sum((z-c).^2));

end