function  list_MIJ_each_action = most_informative_joints(X,Y,Z,nof_MIJ_joints)
    nof_joints = size(X,2);
    nof_frames = size(X,1) ;
    assert(size(Y, 2) == nof_joints);
    assert(size(Z, 2) == nof_joints);
    assert(size(Y, 1) == nof_frames);
    assert(size(Z, 1) == nof_frames);
    list_value_variance_joints = zeros(nof_joints,1);
    for i=1:nof_joints
        list_value_joint =[];
        for j=1:nof_frames
               a = [X(j,i),Y(j,i),Z(j,i)];
               list_value_joint = [list_value_joint;a];
        end
        value_variance_joint = compute_variance_joints(list_value_joint);
        list_value_variance_joints(i)= value_variance_joint;
    end
    [value;ind] = sort(Fk,'descend');
    list_MIJ = ind(1:nof_MIJ_joints);
end