function skeletonInformation = read_skeleton_information(filename)
    bodyinfo = read_skeleton_file(filename);
    noFrame = size(bodyinfo,2);
    noJoint =bodyinfo(1).bodies.jointCount;
    listJointX=[];
    listJointY=[];
    listJointZ =[];
    for i=1:noFrame
    jointXinFrame = [];
    jointYinFrame = [];
    jointZinFrame = [];
        for j=1:noJoint
            jointXinFrame = [jointXinFrame,bodyinfo(i).bodies.joints(j).x];
            jointYinFrame = [jointYinFrame,bodyinfo(i).bodies.joints(j).y];
            jointZinFrame = [jointZinFrame,bodyinfo(i).bodies.joints(j).z];
        end
    listJointX = [listJointX;jointXinFrame];
    listJointY = [listJointY;jointYinFrame];
    listJointZ = [listJointX;jointZinFrame];
    end
    skeletonInformation.X =listJointX;
    skeletonInformation.Y =listJointY;
    skeletonInformation.Z =listJointZ;
end