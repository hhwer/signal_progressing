function [ max_num ] = max_continue_num( a )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
local_num = 1;
max_num = 1;
for i = 2:length(a)
    if a(i)-a(i-1)==1
        local_num = local_num + 1;
        max_num = max(max_num,local_num);
    else
        local_num = 1;
    end
end
    
end

