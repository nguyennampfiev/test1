fprintf('running')
addpath('/home/nguyentiennam/test1/A/libsvm-3-4.22')
% addpath('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons')
% addpath('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons')
fprintf('aa')
nof_MIJ_joints =5;
noAction =49;
nLevels =2;
overlap =true;
timevar =false;
nof_joints=25; 
if(timevar)
    length_vecS = nof_MIJ_joints *3+1;
else
    length_vecS = nof_MIJ_joints *3;
end
list_training_files=[];
list_testing_files =[];
list_label_training=[];
list_label_testing=[];
list_index_matrix= get_upper_index_matrix(length_vecS);
training_subjects =[1, 2, 4, 5, 8, 9, 13, 14, 15, 16, 17, 18, 19, 25, 27, 28, 31, 34, 35, 38];
list_actions=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49];
fprintf('Conpute the MIJ joints')
matrix_MIJ_joints = cell(49,1);
matrix_joints_determine =zeros(noAction,nof_MIJ_joints);
[list_of_all_files] = list_all_files_in_a_directory('/media/data2/datasets/NTU_RGB-D/nturgb+d_skeletons');
% [list_of_all_files] = list_all_files_in_a_directory('/Users/nguyennam/Desktop/test1/A/nturgb+d_skeletons');
for i=1:length(list_of_all_files)
    list_of_all_files;
    if (strcmp(list_of_all_files{i},'.DS_Store')|check_error_file(list_of_all_files{i}))
        continue
    else 
        label_action =get_label_action(list_of_all_files{i});
        if ismember((get_subject(list_of_all_files{i})),training_subjects) && ismember(label_action,list_actions)
           list_training_files =[list_training_files;list_of_all_files{i}];
           list_label_training =[list_label_training;label_action];
           SkeletonInformation =read_skeleton_information(list_of_all_files{i});
           list_MIJ_each_action = most_informative_joints(SkeletonInformation.X,SkeletonInformation.Y,SkeletonInformation.Z,nof_MIJ_joints);
           matrix_MIJ_joints{label_action} = [matrix_MIJ_joints{label_action};list_MIJ_each_action];
        else
           list_testing_files =[list_testing_files;list_of_all_files{i}];
           list_label_testing =[list_label_testing;label_action];
        end
    end
end

for t=1:length(matrix_MIJ_joints)
    matrix_joints_determine(t,:) = get_index_of_MIJ_joints(matrix_MIJ_joints{t},nof_MIJ_joints);
end
% Compute Covariance  with MIJ joints
model= cell(noAction,1);
nof_action_train =size(list_training_files,1);
fprintf('training \n');
for h=1:length(model)
    fprintf('model %d\n',h)
    data_train=[];
    for i =1:nof_action_train
        SkeletonInformation =read_skeleton_information(list_training_files(i,:));
        list_joints = matrix_joints_determine(h,:);
        Xnew = SkeletonInformation.X(:,sort(list_joints));
        Ynew = SkeletonInformation.Y(:,sort(list_joints));
        Znew = SkeletonInformation.Z(:,sort(list_joints));
        t =[1:size(Xnew,1)];
         [full_cov_matrix,cov_matrix] = covariance_features(Xnew, Ynew, Znew, t', nLevels,overlap,timevar,list_index_matrix);
        concatcate_cov_to_vec = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(cov_matrix, 1, []), 'UniformOutput', false));
        % normVec = normVec / (norm(normVec) + 1e-5);
        data_train =[data_train; concatcate_cov_to_vec];
        
    end
    % model{g} =  TreeBagger(nTrees,rowdata3_train,double(labels ==listLabel(g)), 'Method', 'classification');
    %  model{g} = ClassificationTree.fit(rowdata3_train,double(labels == listLabel(g)));
        % [labelPr,Pr] = predict(trainmodel,dataTest);
     model{h}=svmtrain(double(list_label_training==list_actions(h)), data_train, '-c 10  -q -t 0 -b 1');
end
 % test
 
fprintf('testing \n');
nof_action_test = size(list_testing_files,1);
prob = zeros(nof_action_test,noAction); 
for h=1:length(model) 
    fprintf('test on model %d\n',h)
    data_test=[];
    for i =1:nof_action_test
        SkeletonInformation =read_skeleton_information(list_testing_files(i,:));
        list_joints = matrix_joints_determine(h,:);
        Xnew = SkeletonInformation.X(:,sort(list_joints));
        Ynew = SkeletonInformation.Y(:,sort(list_joints));
        Znew = SkeletonInformation.Z(:,sort(list_joints));
        t =[1:size(Xnew,1)];
         [full_cov_matrix,cov_matrix] = covariance_features(Xnew, Ynew, Znew, t', nLevels,overlap,timevar,list_index_matrix);
        concatcate_cov_to_vec = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(cov_matrix, 1, []), 'UniformOutput', false));
        % normVec = normVec / (norm(normVec) + 1e-5);
        data_test =[data_test; concatcate_cov_to_vec];
        
    end
        [predict_label, accuracy, prob_estimates] = svmpredict(double(list_label_testing==list_actions(h)), data_test, model{h}, '-b 1 -q');
        prob(:,h) = prob_estimates(:,model{h}.Label==1);       
    end
    [~,pred] = max(prob,[],2);
%     for j = 1 : numel(pred)
%         pred(j) = listClass(pred(j));
%     end

    acc = sum(pred == list_label_testing) ./ numel(list_label_testing)



