data_path = '.\test_data';
good_data = [];
bad_data = [];
file_path1 = [data_path, '\质量好\质量好'];
file_path2 = [data_path, '\质量差\质量差'];
file = dir([file_path1,'\*png']);
for j = 1:length(file)
    str = file(j).name;
    A=isstrprop(str,'digit');
    B=str(A);
    C= str2num(B);
    good_data(j) = C;
end
file = dir([file_path2,'\*png']);
for j = 1:length(file)
    str = file(j).name;
    A=isstrprop(str,'digit');
    B=str(A);
    C= str2num(B);
    bad_data(j) = C;
end