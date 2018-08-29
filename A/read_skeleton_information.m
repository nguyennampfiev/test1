function skeletonInformation = read_skeleton_information(filename)
    bodyinfo = read_skeleton_file(filename);
    noFrame = size(bodyinfo,2);
%     noJoint =bodyinfo(1).bodies.jointCount;
      noJoint =25;
    listJointX =[];
    listJointY =[];
    listJointZ =[];
    for i=1:noFrame
        if(isempty(bodyinfo(i).bodies))
            continue;
        end
        if(size(bodyinfo(i).bodies,2)>1)
            id_BodyID = filter_skeleton(bodyinfo(i));
        else
            id_BodyID =1;
        end
        if(id_BodyID==0)
            continue;
        end
        jointXinFrame = [];
        jointYinFrame = [];
        jointZinFrame = [];
        for j=1:noJoint
            jointXinFrame = [jointXinFrame,bodyinfo(i).bodies(id_BodyID).joints(j).x];
            jointYinFrame = [jointYinFrame,bodyinfo(i).bodies(id_BodyID).joints(j).y];
            jointZinFrame = [jointZinFrame,bodyinfo(i).bodies(id_BodyID).joints(j).z];
        end
        listJointX = [listJointX;jointXinFrame];
        listJointY = [listJointY;jointYinFrame];
        listJointZ = [listJointZ;jointZinFrame];
       
    end
    skeletonInformation.X =listJointX;
    skeletonInformation.Y =listJointY;
    skeletonInformation.Z =listJointZ;
end