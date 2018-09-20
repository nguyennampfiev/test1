function  [list_MIJ_each_action,list_MIJ_binary] = most_informative_joints(X,Y,Z,nof_MIJ_joints)
    nof_joints = size(X,2);
    nof_frames = size(X,1) ;
    assert(size(Y, 2) == nof_joints);
    assert(size(Z, 2) == nof_joints);
    assert(size(Y, 1) == nof_frames);
    assert(size(Z, 1) == nof_frames);
    list_value_variance_joints = zeros(nof_joints,1);
    list_MIJ_binary = zeros(nof_joints,1);
    for i=1:nof_joints
        list_value_joint =zeros(nof_frames,3);
        for j=1:nof_frames
%                a = [X(j,i),Y(j,i),Z(j,i)];
%                list_value_joint(j) = [list_value_joint;a];
            list_value_joint(j,:) = [X(j,i),Y(j,i),Z(j,i)];
        end
         value_variance_joint = compute_variance_joints(list_value_joint);
%         list_angular_joints = compute_angular_joints(list_value_joint);
%         kinematic_features_joint = compute_kinematic_features(list_angular_joints);
%         list_value_variance_joints(i)= kinematic_features_joint;
        list_value_variance_joints(i)= value_variance_joint
    end
    [~, ind] = sort(list_value_variance_joints,'descend');
    list_MIJ_each_action = ind(1:nof_MIJ_joints);
    list_MIJ_binary(list_MIJ_each_action) =1;
end