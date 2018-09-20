function list_angular_joints = compute_angular_joints(list_value_joint)
list_angular_joints =zeros(size(list_value_joint,1),3);
    for i=2:length(list_value_joint)-1
        list_angular_joints(i,:) = list_value_joint(i+1,:) -list_value_joint(i-1,:);
    end
end