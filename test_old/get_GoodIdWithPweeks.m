function [ result ] = get_GoodIdWithPweeks( filename )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
fid = fopen(filename);
C = textscan(fid, '%s %s %s%s%s%s%s%s%s','delimiter',',');
fclose(fid);
n = length(C{1});
result = {};
num = 0;
id = C{1};
pweeks = C{5};
i = 2;
while i <= n
    good_id = 1;
    if isempty(id{i})
        i = i+1;
        continue
    end
    for j = i+1:n
        if strcmp(id{j},id{i})
            if pweeks{j} ~= pweeks{i}
                good_id = 0;
            end
            temp = j+1;
        else
            temp = j;
            break
        end
    end
    
    if i == n
        temp = i+1;
    end
    
    if good_id
        num = num+1;
        result{num,1} = id{i};
        result{num,2} = str2num(pweeks{i});
    end
    
%     if j == n
%         break
%     end
     
    i = temp;
end
end


