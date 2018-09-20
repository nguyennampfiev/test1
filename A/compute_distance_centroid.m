function centroid= compute_distance_centroid(data,C)
    nof_centroid = size(C,1);
    x = zeros(nof_centroid,1);
    for c=1:nof_centroid
        x(c,:) = sum(abs(data-C(c,:)));
    end 
    [~,centroid] = min(x);
end
