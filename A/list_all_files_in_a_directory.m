function [list_of_all_files] = list_all_files_in_a_directory(directory)
% Utility function 
directory_list = dir(directory); 
directory_list(1:2) = []; % Remove "." and ".."
dir_flags = [directory_list.isdir];
file_list = directory_list(dir_flags == 0);
temp = cell(1, numel(file_list));
for i = 1 : numel(file_list)
    temp{i} = file_list(i).name;
end
list_of_all_files = temp;

end
