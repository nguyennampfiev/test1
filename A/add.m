function result = add(A)
    result = sqrt(sum(bsxfun(@times,A,A),2))
end