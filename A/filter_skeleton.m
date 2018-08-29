function id_bodyID =filter_skeleton(bodyinfo)
    nof_cur_skeleton = size(bodyinfo.bodies,2);
    for i=1:nof_cur_skeleton
        if((bodyinfo.bodies(i).leanX -bodyinfo.bodies(i).leanY)>0.8)
            id_bodyID = 0;
            continue;
        else
            id_bodyID = i;
            break;
        end
    end
end