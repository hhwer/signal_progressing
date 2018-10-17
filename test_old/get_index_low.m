function [ idx ] = get_index_low( a )
%UNTITLED 寻找最高点前的第一个开始上升
%   此处显示详细说明
n = length(a);
% n = floor(n*9/10);
x = a(2:n)-a(1:n-1);
para = a(n)/3+min(a)*2/3;
idx = find(x<0);
if isempty(idx)
    idx = 1;
    return
end
for i = length(idx):-1:1
    local_idx = idx(i)+1;
    if a(local_idx) < para
        idx = local_idx;
        return
    end
end
idx = 1;
end

