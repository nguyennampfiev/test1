function skeletonInformation = normalize_skeleton_new(filename)
    bodyinfo = read_skeleton_file(filename);
    noFrame = size(bodyinfo,2);
    noJoints =25;
    list_id_BodyID = filter_skeleton(bodyinfo(1));
    id_BodyID = find(list_id_BodyID); 
    jointXinFrame=zeros(noFrame,25);
    jointYinFrame=zeros(noFrame,25);
    jointZinFrame=zeros(noFrame,25);
    if ~isempty(id_BodyID) 
       for i=1:noFrame
           if(id_BodyID >length(bodyinfo(i).bodies))
               continue
           else
               jointHipinFrame = [bodyinfo(i).bodies(id_BodyID).joints(1).x,bodyinfo(i).bodies(id_BodyID).joints(1).y,bodyinfo(i).bodies(id_BodyID).joints(1).z];
               for j=2:noJoints
                   if isempty(bodyinfo(i).bodies)
                       continue
                   else
                       distance_to_Hip = [bodyinfo(i).bodies(id_BodyID).joints(j).x,bodyinfo(i).bodies(id_BodyID).joints(j).y,bodyinfo(i).bodies(id_BodyID).joints(j).z]-jointHipinFrame;
                       distance_euclid= sqrt(sum(bsxfun(@times,distance_to_Hip,distance_to_Hip)));
                       new_cordinate_skeleton = distance_to_Hip/distance_euclid;
                       jointXinFrame(i,j) = new_cordinate_skeleton(1);
                       jointYinFrame(i,j) = new_cordinate_skeleton(2);
                       jointZinFrame(i,j) = new_cordinate_skeleton(3);
                   end
               end
           end
       end
         skeletonInformation.X =jointXinFrame;
         skeletonInformation.Y =jointYinFrame;
         skeletonInformation.Z =jointZinFrame;
    else
        skeletonInformation.X =[];
    end
end
        
   