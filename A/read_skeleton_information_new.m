function skeletonInformation = read_skeleton_information_new(filename)
    bodyinfo = read_skeleton_file(filename);
    noFrame = size(bodyinfo,2);
    noJoints =25;
    listJointX =[];
    listJointY =[];
    listJointZ =[];
    list_id_BodyID = filter_skeleton(bodyinfo(1));
    id_BodyID = find(list_id_BodyID); 
    if ~isempty(id_BodyID) 
       for i=1:noFrame
           if(id_BodyID >length(bodyinfo(i).bodies))
               continue
           else
               jointXinFrame = [];
               jointYinFrame = [];
               jointZinFrame = [];
               for j=1:noJoints
                   if isempty(bodyinfo(i).bodies)
                       continue
                   else
                   jointXinFrame = [jointXinFrame,bodyinfo(i).bodies(id_BodyID).joints(j).x];
                   jointYinFrame = [jointYinFrame,bodyinfo(i).bodies(id_BodyID).joints(j).y];
                   jointZinFrame = [jointZinFrame,bodyinfo(i).bodies(id_BodyID).joints(j).z];
                   end
               end
                   listJointX = [listJointX;jointXinFrame];
                   listJointY = [listJointY;jointYinFrame];
                   listJointZ = [listJointZ;jointZinFrame];
           end
        end
        skeletonInformation.X =normalize_skeleton(listJointX);
        skeletonInformation.Y =normalize_skeleton(listJointY);
        skeletonInformation.Z =normalize_skeleton(listJointZ);
    else
        skeletonInformation.X =[];
    end
end