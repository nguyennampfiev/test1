function sum_variance = select_cur_skeleton(bodies)
    nof_joints = bodies.jointCounts;
    X = bodies.joints.X;
    Y = bodies.joints.Y;
    Z = bodies.joints.Z;
    sum_variance = 0;
%     list_value_variance_joints = zeros(nof_joints,1);
    for i=1:nof_joints
        list_value_joint =zeros(nof_frames,3);
        for j=1:nof_frames
%                a = [X(j,i),Y(j,i),Z(j,i)];
%                list_value_joint(j) = [list_value_joint;a];
            list_value_joint(j,:) = [X(j,i),Y(j,i),Z(j,i)];
        end
%         list_value_variance_joints(i) = compute_variance_joints(list_value_joint);
        sum_variance =+ compute_variance_joints(list_value_joint);
    end
end