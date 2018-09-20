fprintf('running \n')
%  addpath('/Users/nguyennam/Desktop/test1/A/libsvm-3-4.22/matlab')
% addpath('/home/nguyentiennam/test1/A/libsvm-3-4.22/matlab')
addpath('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons')
% addpath('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons')
nof_MIJ_joints =5;
nofAction =60;
nLevels =1;
overlap =false;
timevar =false;
nof_joints=25;
training_subjects =[1, 2, 4, 5, 8, 9, 13, 14, 15, 16, 17, 18, 19, 25, 27, 28, 31, 34, 35, 38];
fprintf('Compute the MIJ joints')
matrix_MIJ_joints = cell(nofAction,1);
matrix_joints_determine =zeros(nofAction,nof_MIJ_joints);
[list_of_all_files] = list_all_files_in_a_directory('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons');

%   [list_of_all_files] = list_all_files_in_a_directory('/Users/nguyennam/Desktop/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons');
%    list_of_all_files = list_all_files_in_a_directory('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons');
for i=1:length(list_of_all_files)
    i
    if (strcmp(list_of_all_files{i},'.DS_Store')|check_error_file(list_of_all_files{i}))
        continue
    else 
        label_action =get_label_action(list_of_all_files{i});
            SkeletonInformation =read_skeleton_information_new(list_of_all_files{i});
            if isempty(SkeletonInformation.X)
                continue
            end
            if ismember((get_subject(list_of_all_files{i})),training_subjects)
                [list_MIJ_each_action ,~]= most_informative_joints(SkeletonInformation.X,SkeletonInformation.Y,SkeletonInformation.Z,nof_MIJ_joints);
                matrix_MIJ_joints{label_action}=[matrix_MIJ_joints{label_action};list_MIJ_each_action];
            end
    end
end
 for t=1:nofAction
     matrix_joints_determine(t,:) = get_index_of_MIJ_joints(matrix_MIJ_joints{t},nof_MIJ_joints);
 end

