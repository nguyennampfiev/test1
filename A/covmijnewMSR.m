addpath('./libsvm-3-4.22/matlab')
addpath('/Users/nguyennam/Downloads/DATN/20132689_NguyenTienNam/MSRAction3d')
actionSet='ActionSet2.txt';
nofJoints=20;
noMostJoints =5;
nLevels =3;
overlap =true;
nof_centroid =2;
timevar =true;
datadir ='/Users/nguyennam/Downloads/DATN/20132689_NguyenTienNam/MSRAction3d/data';
file = fopen(actionSet,'r');
filename = cell(1,1);
h=1;
if(timevar)
    length_vecS = noMostJoints *3+1;
else
    length_vecS = noMostJoints *3;
end
while ~feof(file)
    filename(h) = textscan(file,'%str\n');
    h =h+1;
end
fclose(file);
traindata =cell(2,1);
trainlabels = zeros(2,1);
testdata = cell(2,1);
testlabels =zeros(2,1);
di = 1; % counter for data
ti = 1;
len =size(filename,2);
list_index_matrix= get_upper_index_matrix(length_vecS);
matrix_MIJ_binary = [];
matrix_joints_determine =zeros(nof_centroid,20);
traningsubjects =[1,3,5,7,9];
for i = 1:len
    if( ~isempty(find(traningsubjects == getSubject(char(filename{i})),1)));
        traindata{di} = load(fullfile(datadir,[char(filename{i}),'_skeleton3D.txt']));
        trainlabels(di) = getLabelAction(char(filename{i}));
        [n d] = size(traindata{di});
        noframes = n / nofJoints;
        x = reshape(traindata{di}(:,1), nofJoints, noframes); % x
        y = reshape(traindata{di}(:,2), nofJoints, noframes); % y
        z = reshape(traindata{di}(:,3), nofJoints, noframes);
        t = 1:noframes; % z
        [~ ,list_MIJ_binary]= most_informative_joints(x',y',z',noMostJoints);
         matrix_MIJ_binary = [matrix_MIJ_binary;list_MIJ_binary'];
        di=di+1;
    else
        testdata{ti} =load(fullfile(datadir,[char(filename{i}),'_skeleton3D.txt']));
        testlabels(ti) = getLabelAction(char(filename{i}));
        ti = ti+1;   
    end
end
% minc = min(matrix_MIJ_binary, 1);
% maxc = max(matrix_MIJ_binary, 1);
% nsamp = size(matrix_MIJ_binary,1);
% s = RandStream('mt19937ar','Seed',0);
% RandStream.setGlobalStream(s);
% initialcenters = randn(nof_centroid,20)
[idx,C] = kmeans(matrix_MIJ_binary,nof_centroid);
[ii,jj]=sort(C,2,'descend');
 for t=1:nof_centroid
     matrix_joints_determine(t,jj(t,1:noMostJoints)) = 1;
 end
%  cluster1 = matrix_MIJ_binary(idx == 1, :);
%  cluster2 = matrix_MIJ_binary(idx == 2, :);
% figure
% axes
% plot(cluster1(:, [1, 2]), '*'); hold all
% plot(cluster2(:, [1, 2]), '-')
% matrix_joints_determine

fprintf('training \n');
    feature_train=[];
    for i =1:size(traindata,1)
        onetrain =traindata{i};
        noframes = size(onetrain,1) / nofJoints;
        x = reshape(traindata{i}(:,1),nofJoints,noframes);
        y = reshape(traindata{i}(:,2),nofJoints,noframes);
        z = reshape(traindata{i}(:,3),nofJoints,noframes);
        t =1:noframes;
        [~ ,list_MIJ_binary]= most_informative_joints(x',y',z',noMostJoints);
        centroid= compute_distance_centroid(list_MIJ_binary',C);
        list_joints = matrix_joints_determine(centroid,:);
        list_joints = find(list_joints==1);
        Xnew = x(sort(list_joints),:);
        Ynew = y(sort(list_joints),:);
        Znew = z(sort(list_joints),:);
        [full_cov_matrix,cov_matrix] = covariance_features(Xnew', Ynew', Znew', t', nLevels,overlap,timevar,list_index_matrix);
        concatcate_cov_to_vec = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(cov_matrix, 1, []), 'UniformOutput', false));
        feature_train =[feature_train; concatcate_cov_to_vec];     
    end
     model= svmtrain(trainlabels, feature_train, '-c 4  -q -t 0 -b 1');

% test

   
fprintf('testing \n');
    feature_test=[];
    for i =1:size(testdata,1)
        onetrain =testdata{i};
        noframes = size(onetrain,1) / nofJoints;
        x = reshape(testdata{i}(:,1),nofJoints,noframes);
        y = reshape(testdata{i}(:,2),nofJoints,noframes);
        z = reshape(testdata{i}(:,3),nofJoints,noframes);
        t =1:noframes;
        [~ ,list_MIJ_binary]= most_informative_joints(x',y',z',noMostJoints);
        centroid= compute_distance_centroid(list_MIJ_binary',C);
        list_joints = matrix_joints_determine(centroid,:);
        list_joints = find(list_joints==1);
        [list_MIJ_each_action ,list_MIJ_binary]= most_informative_joints(x',y',z',noMostJoints);
        centroid= compute_distance_centroid(list_MIJ_binary',C);
        list_joints = matrix_joints_determine(centroid,:);
        list_joints = find(list_joints==1);
        Xnew = x(sort(list_joints),:);
        Ynew = y(sort(list_joints),:);
        Znew = z(sort(list_joints),:);
        [full_cov_matrix,cov_matrix] = covariance_features(Xnew', Ynew', Znew', t', nLevels,overlap,timevar,list_index_matrix);
        concatcate_cov_to_vec = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(cov_matrix, 1, []), 'UniformOutput', false));
        feature_test =[feature_test; concatcate_cov_to_vec];
    end
        [predict_label, accuracy, prob_estimates] = svmpredict(testlabels, feature_test, model, '-b 1');
    




