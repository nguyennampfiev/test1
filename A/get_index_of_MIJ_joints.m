function MIJ_of_action = get_index_of_MIJ_joints(matrix_MIJ_joints,nof_MIJ_joints)
% Determine the  MIJ of each action 
    list_unique_joints = unique(matrix_MIJ_joints);
    num_of_occurrences_joints = zeros(1,size(list_unique_joints,1));
    for i=1:size(list_unique_joints,1)
        number_of_occurrences_joints(i) = sum(sum(matrix_MIJ_joints ==list_unique_joints(i)));
    end
    [value ind] = sort(number_of_occurrences_joints,'descend');
    list_index = ind(1:nof_MIJ_joints);
    MIJ_of_action = list_unique_joints(list_index);
end