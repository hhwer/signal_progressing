function [ d] = VecDistance( x1,x2 )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
z = x1-x2;
c = mean(z);
d = sqrt(sum((z-c).^2));

end

