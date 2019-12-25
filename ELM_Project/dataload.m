function [data] = dataload(name, num_samp)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(name,'r');

fgets(fileID);
str = strings([num_samp, 1]);

for i = 1:num_samp
    onlines=fgets(fileID);
    str(i) = onlines;
end
str = split(str, ";");

% Convert the string matrix into the double matrix
for i=1:num_samp
    for j=1:13
        str_temp(i,j) = str2num(str(i,j));
    end
    
end

data=str_temp;
end



