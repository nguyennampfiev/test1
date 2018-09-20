%USAGE: drawskt(1,3,1,4,1,2) --- show actions 1,2,3 performed by subjects 1,2,3,4 with instances 1 and 2.
function drawskt(filename)
filename
J=[12     12     11     10    9     21    3     5     2      4   6   8   8   7 7  1  17  13  17  18  19  13  14  15    ;
   24     25      12    11    10    9     21    21    21     3   5   22  23  8 6  2   1   1  18  19  20  14  15  16];
skeletonInformation = read_skeleton_information_new(filename);

X = skeletonInformation.X;
Y= skeletonInformation.Y;
Z=skeletonInformation.Z;
X = X';
Y = Y';
Z = Z';
for s=1:size(X,2)
    S=[X(:,s) Y(:,s) Z(:,s)];   
    h = plot3(S(:,1),S(:,2),S(:,3),'r.');    
    axis([-1 1 -1 1 -1 1])    
    xlabel('x-axis')
    ylabel('y-axis')
    zlabel('z-axis')
    for j=1:24
        c1=J(1,j);
        c2=J(2,j);
        line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)]);
    end
    view(0,90)
    drawnow;
end