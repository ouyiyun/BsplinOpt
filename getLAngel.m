function [Lmin, angleMean]=getLAngel(path)
angleSum = 0;
Lmin = inf;
for i = 2:size(path,1)-1
    A=path(i,:);
    B=path(i-1,:);
    C=path(i+1,:);
    AB = B - A;
    AC = C - A;
    cosTheta = AB * AC' / (norm(AB) * norm(AC));
    theta = acos(cosTheta);
    angleSum = angleSum + theta;
    if(min(norm(AB),norm(AC)) < Lmin)
        Lmin = min(norm(AB),norm(AC));
    end
end
angleMean = angleSum / (size(path,1)-2);
end