function [table_final] = barPlot(y)
% 统计分数score
% 绘制误差分布直方图
% Para:
%    输入均为列向量；

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  绘制误差分布直方图  %%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
[errorNum,xaxis] = hist(y,[0:37]); 
bar(xaxis,errorNum)
for i = 1:length(xaxis)
    text(xaxis(i),errorNum(i),num2str(errorNum(i),'%g'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
ylabel('数量');
grid on;

end
