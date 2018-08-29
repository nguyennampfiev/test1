fprintf('running \n ')
 addpath('/home/nguyentiennam/test1/A/libsvm-3-4.22/matlab')
% addpath('/Users/nguyennam/Desktop/test1/A/libsvm-3-4.22/matlab')
% addpath('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons')
% addpath('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons')
% fprintf('aa')
noAction =49;
nLevels =2;
overlap =true;
timevar =false;
nof_joints=25; 
if(timevar)
    length_vecS = nof_joints *3+1;
else
    length_vecS = nof_joints *3;
end
% list_training_files=[];
% list_testing_files =[];
% list_label_training=[];
% list_label_testing=[];
list_index_matrix= get_upper_index_matrix(length_vecS);
training_subjects =[1, 2, 4, 5, 8, 9, 13, 14, 15, 16, 17, 18, 19, 25, 27, 28, 31, 34, 35, 38];
list_actions=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49];
[list_of_all_files] = list_all_files_in_a_directory('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons');
% [list_of_all_files] = list_all_files_in_a_directory('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons');
 data_train=[];
 label_train =[];
 data_test=[];
 label_test=[];
for i=1:length(list_of_all_files)
    i
    list_of_all_files;
    if (strcmp(list_of_all_files{i},'.DS_Store')|check_error_file(list_of_all_files{i}))
        continue
    else 
        label_action =get_label_action(list_of_all_files{i});
        SkeletonInformation =read_skeleton_information(list_of_all_files{i});
%         list_joints = matrix_joints_determine(h,:);
        X = SkeletonInformation.X;
        Y = SkeletonInformation.Y;
        Z = SkeletonInformation.Z;
        t =[1:size(X,1)];
         [full_cov_matrix,cov_matrix] = covariance_features(X, Y, Z, t', nLevels,overlap,timevar,list_index_matrix);
        concatcate_cov_to_vec = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(cov_matrix, 1, []), 'UniformOutput', false));
        if ismember((get_subject(list_of_all_files{i})),training_subjects) && ismember(label_action,list_actions)
            label_train =[label_train;label_action];
            data_train =[data_train; concatcate_cov_to_vec];
        else
           label_test =[label_test;label_action];
           data_test =[data_test; concatcate_cov_to_vec];
        end
    end
end





