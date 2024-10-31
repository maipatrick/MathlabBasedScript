function Y = drehen(V)
if ndims(V) == 3
    for i = 1:size(V,3)
        Y(1,i) = V(1,1,i);
    end
end

if ndims(V) == 2
    for i = 1:size(V,2)
        Y(1,1,i) = V(1,i);
    end
end