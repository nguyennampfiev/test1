function sum_kinematic = compute_kinematic_features(list_angular_joints)
    sum_kinematic = sum(sqrt(sum(bsxfun(@times,list_angular_joints,list_angular_joints),2)));
end