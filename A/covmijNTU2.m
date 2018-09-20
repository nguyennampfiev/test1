fprintf('running \n')
%  addpath('/Users/nguyennam/Desktop/test1/A/libsvm-3-4.22/matlab')
 addpath('/home/nguyentiennam/test1/A/libsvm-3-4.22/matlab')
 addpath('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons')
% addpath('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons')
nof_MIJ_joints =6;
nofAction =60;
nLevels =1;
overlap =false;
timevar =false;
nof_joints=25;
nof_centroid =6;
if(timevar)
    length_vecS = nof_MIJ_joints *3+1;
else
    length_vecS = nof_MIJ_joints *3;
end
label_train=[];
label_test=[];
data_train =[];
data_test =[];
list_index_matrix= get_upper_index_matrix(length_vecS);
training_subjects =[1, 2, 4, 5, 8, 9, 13, 14, 15, 16, 17, 18, 19, 25, 27, 28, 31, 34, 35, 38];
fprintf('Compute the MIJ joints')
matrix_MIJ_joints = cell(nofAction,1);
matrix_MIJ_binary = [];
matrix_joints_determine =zeros(nof_centroid,25);
 [list_of_all_files] = list_all_files_in_a_directory('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons');

%   [list_of_all_files] = list_all_files_in_a_directory('/Users/nguyennam/Desktop/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons');
%    list_of_all_files = list_all_files_in_a_directory('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons');
for i=1:length(list_of_all_files)
    i
    if (strcmp(list_of_all_files{i},'.DS_Store')|check_error_file(list_of_all_files{i}))
        continue
    else 
        label_action =get_label_action(list_of_all_files{i});
            SkeletonInformation =normalize_skeleton_new(list_of_all_files{i});
            if isempty(SkeletonInformation.X)
                continue
            end
            if ismember((get_subject(list_of_all_files{i})),training_subjects)
                [list_MIJ_each_action ,list_MIJ_binary]= most_informative_joints(SkeletonInformation.X,SkeletonInformation.Y,SkeletonInformation.Z,nof_MIJ_joints);
                matrix_MIJ_binary = [matrix_MIJ_binary;list_MIJ_binary'];
                label_train =[label_train;label_action];
                data_train =[data_train; SkeletonInformation];
            else
               label_test =[label_test;label_action];
               data_test =[data_test; SkeletonInformation];
            end
    end
end
[idx,C] = kmeans(matrix_MIJ_binary,nof_centroid);
[ii,jj]=sort(C,2,'descend');
 for t=1:nof_centroid
     matrix_joints_determine(t,jj(t,1:nof_MIJ_joints)) = 1;
 end
% Compute Covariance  with MIJ joints
fprintf('training \n')
feature_train=cell(nof_centroid,1);
label_centroid_train =cell(nof_centroid,1);
model =cell(nof_centroid,1);
    for i =1:size(data_train,1)
%         SkeletonInformation =read_skeleton_information(list_training_files(i,:));
        X = data_train(i).X;
        Y = data_train(i).Y;
        Z = data_train(i).Z;
        [list_MIJ_each_action ,list_MIJ_binary]= most_informative_joints(X,Y,Z,nof_MIJ_joints);
        centroid= compute_distance_centroid(list_MIJ_binary',C);
        list_joints = matrix_joints_determine(centroid,:);
        list_joints = find(list_joints==1);
        Xnew = X(:,sort(list_joints));
        Ynew = Y(:,sort(list_joints));
        Znew = Z(:,sort(list_joints));
        t =[1:size(Xnew,1)];
         [full_cov_matrix,cov_matrix] = covariance_features(Xnew, Ynew, Znew, t', nLevels,overlap,timevar,list_index_matrix);
        concatcate_cov_to_vec = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(cov_matrix, 1, []), 'UniformOutput', false));
        % normVec = normVec / (norm(normVec) + 1e-5);
        feature_train{centroid} =[feature_train{centroid}; concatcate_cov_to_vec];
        label_centroid_train{centroid}=[label_centroid_train{centroid};label_train(i)];
    end    
fprintf('testing \n');

    feature_test=cell(nof_centroid,1);
    label_centroid_test=cell(nof_centroid,1);
    for i =1:size(data_test,1)
        X = data_test(i).X;
        Y = data_test(i).Y;
        Z = data_test(i).Z;
        [list_MIJ_each_action ,list_MIJ_binary]= most_informative_joints(X,Y,Z,nof_MIJ_joints);
        centroid= compute_distance_centroid(list_MIJ_binary',C);
        list_joints = matrix_joints_determine(centroid,:);
        list_joints = find(list_joints==1);
        Xnew = X(:,sort(list_joints));
        Ynew = Y(:,sort(list_joints));
        Znew = Z(:,sort(list_joints));
        t =[1:size(Xnew,1)];
        [full_cov_matrix,cov_matrix] = covariance_features(Xnew, Ynew, Znew, t', nLevels,overlap,timevar,list_index_matrix);
        concatcate_cov_to_vec = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(cov_matrix, 1, []), 'UniformOutput', false));
        feature_test{centroid} =[feature_test{centroid}; concatcate_cov_to_vec];
        label_centroid_test{centroid} =[label_centroid_test{centroid};label_test(i)];
    end
list_predict_label =[];
list_label_test=[];
for c=1:nof_centroid
    model{c}= svmtrain(label_centroid_train{c}, feature_train{c}, '-c 10  -q -t 0 -b 1');
    [predict_label, accuracy, prob_estimates] = svmpredict(label_centroid_test{c}, feature_test{c}, model{c}, '-b 1');
    list_predict_label =[list_predict_label;predict_label];
    list_label_test =[list_label_test;label_centroid_test{c}];
end

