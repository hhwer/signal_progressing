function [table_final] = barPlot(y)
% ͳ�Ʒ���score
% �������ֲ�ֱ��ͼ
% Para:
%    �����Ϊ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  �������ֲ�ֱ��ͼ  %%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
[errorNum,xaxis] = hist(y,[0:37]); 
bar(xaxis,errorNum)
for i = 1:length(xaxis)
    text(xaxis(i),errorNum(i),num2str(errorNum(i),'%g'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
ylabel('����');
grid on;

end
