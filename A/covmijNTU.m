addpath('./libsvm-3-4.22/matlab')
addpath('./nturgb+d_skeletons')
nof_MIJ_joints =3;
noAction =20;
nLevels =3;
overlap =true;
timevar =false;
training_subjects =[1, 2, 4, 5, 8, 9, 13, 14, 15, 16, 17, 18, 19, 25, 27, 28, 31, 34, 35, 38];
list_actions=[]
matrix_MIJ_joints = cell(noAction,1)


for k=1:length(G)
    matrixIndexJoint(G(k),:) = get_index_of_MIJ_joints(matrix_MIJ_joints{G(k)},nof_MIJ_joints);
end

