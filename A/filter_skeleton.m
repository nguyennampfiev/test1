function list_id_bodyID =filter_skeleton(bodyinfo)
    nof_cur_skeleton = size(bodyinfo.bodies,2);
    list_id_bodyID = zeros(nof_cur_skeleton,1);
    for i=1:nof_cur_skeleton
        if((bodyinfo.bodies(i).leanX -bodyinfo.bodies(i).leanY)>0.8)
             list_id_bodyID(i)=0;
        else
            list_id_bodyID(i)=i;
            break;
        end
    end
    nof_real_skeleton = find(list_id_bodyID);
    if(length(nof_real_skeleton) ==2)
       if(select_cur_skeleton(bodyinfo.bodies(nof_real_skeleton(1)))>select_cur_skeleton(bodyinfo.bodies(nof_real_skeleton(2))))
            list_id_bodyID(nof_real_skeleton(2))= 0;
       else
            list_id_bodyID(nof_real_skeleton(1))= 0;
       end
    end
end