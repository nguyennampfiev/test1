function [full_cov_matrix,cov_matrix] = covariance_features(X, Y, Z, T, nLevels, overlap, add_time,list_index_matrix)
    nFrames = size(X, 1);
    nJoints = size(X, 2);
    assert(size(Y, 1) == nFrames);
    assert(size(Z, 1) == nFrames);
    assert(size(T, 1) == nFrames);
    assert(size(Y, 2) == nJoints);
    assert(size(Z, 2) == nJoints);
%     assert(size(T, 2) == 1);
%     if nargin < 7 || isempty(add_time)
%         add_time = true;
%     end
    %
    normX =normalize_skeleton(X);
    normY =normalize_skeleton(Y);
    normZ =normalize_skeleton(Z);
    normT =normalize_skeleton(T);
    %  Compute  covariance matrix
    full_cov_matrix = cell(1, nLevels);
    cov_matrix = cell(1, nLevels);
    for l = 1:nLevels
        nofMats = 2 ^ (l - 1);
        size_window = 1 / nofMats;
        step_window = size_window;
        if overlap
            step_window = step_window / 2;
            nofMats = nofMats * 2 - 1;
        end
        startFrameTimes = step_window * (0:(nofMats-1));
        full_cov_matrix{l} = cell(1, nofMats);
        cov_matrix{l}      = cell(1, nofMats);
        for i = 1:length(startFrameTimes)
            startTime = startFrameTimes(i);
            endTime = startFrameTimes(i) + size_window + 2 * eps;
            sliceInds = find(normT >= startTime & normT < endTime);
            sliceX = normX(sliceInds, :);
            sliceY = normY(sliceInds, :);
            sliceZ = normZ(sliceInds, :);
%             sliceT = normT(sliceInds, :);
            if ~add_time
                slice_vars = [sliceX sliceY sliceZ];
            else 
                slice_vars = [sliceX sliceY sliceZ sliceT];
            end
             covariance_mat =cov(slice_vars);
            full_cov_matrix{l}{i} = covariance_mat;
            cov_matrix{l}{i} = covariance_mat(list_index_matrix);
        end

    end
end