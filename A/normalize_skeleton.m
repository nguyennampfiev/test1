function X_norm  = normalize_skeleton(X)
    minX = min(X(:));
    maxX = max(X(:));
    X_norm = (X - minX) / (maxX - minX);
end