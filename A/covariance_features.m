function [full_cov,cov] = covariance_features(X, Y, Z, T, nLevels, overlap, add_time,list_index_matrix)
    nFrames = size(X, 1);
    nJoints = size(X, 2);
    assert(size(Y, 1) == nFrames);
    assert(size(Z, 1) == nFrames);
    assert(size(T, 1) == nFrames);
    assert(size(Y, 2) == nJoints);
    assert(size(Z, 2) == nJoints);
    assert(size(T, 2) == 1);
    if nargin < 7 || isempty(add_time)
        timeVar = true;
    end
    %
    normX =normCor(X);
    normY =normCor(Y);
    normZ =normCor(Z);
    normT =normSeT(T);

    %  Compute  covariance matrix
    fullCovMats = cell(nLevels, 1);
    covMats = cell(nLevels, 1);
    for l = 1:nLevels
        nofMats = 2 ^ (l - 1);
        size_window = 1 / nofMats;
        step_window = size_window;
        if overlap
            step_window = size_window / 2;
            nofMats = nofMats * 2 - 1;
        end
        startFrameTimes = step_window * (0:(nofMats-1));
        full_cov{l} = cell(1, nofMats);
        cov{l}      = cell(1, nofMats);
        for i = 1:length(startFrameTimes)
            startTime = startFrameTimes(i);
            endTime = startFrameTimes(i) + sizeWindow + 2 * eps;
            sliceInds = find(normT >= startTime & normT < endTime);
            sliceX = normX(sliceInds, :);
            sliceY = normY(sliceInds, :);
            sliceZ = normZ(sliceInds, :);
            sliceT = normT(sliceInds, :);
            if ~timeVar
                sliceVars = [sliceX sliceY sliceZ];
            else 
                sliceVars = [sliceX sliceY sliceZ sliceT];
            end
            covarianceMat = cov(sliceVars);
            full_cov{l}{i} = covarianceMat;
            cov{l}{i} = covarianceMat(list_index_matrix);
        end

    end
end