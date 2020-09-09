function [smoothPath] = getSmoothPath(path, k, alpha)
%smoothPath：平滑之后的控制点
%path：原始路径点
%k：最大曲率
%alpha：最小夹角

% Lmin = 112;
% assignAngle = pi/2;
% assignAngle = alpha;
% Lmin = (sin(alpha) / (0.125 * (1 - cos(alpha)))^(1.5)) / (6*k);
[Lmin, assignAngle] = getLAngel(path);
% assignAngle = pi/2;
%检查夹角
m = size(path,1);
newPath = [path(1,:)];% 存储符合最小夹角的点，包括更新后满足夹角的点
waitCheckPoint = path; %待检测的点
id = 2; %waitCheckPoint中的第几个点
% deg =[]; 

% 设定循环上限
maxNum = 2*m;
num = 0;
while (id < size(waitCheckPoint,1))
    %算两向量的cos
    A = waitCheckPoint(id,:);
    B = waitCheckPoint(id-1,:);
    C = waitCheckPoint(id+1,:);
    AB = B - A;
    AC = C - A;
    % 有问题
    cosTheta = AB * AC' / (norm(AB) * norm(AC));
    theta = acos(cosTheta);
    angle = rad2deg(theta);
    %若该点不满足最小夹角，那么waitCheckPoint需更新
    %id重置为1，同时将该点与新得到的点压入newPath
    if (theta - alpha < -0.01) %一定范围内认为theta与alpha差别不大
        % 利用叉积和点积求新的控制点D
        H = [AB(1,1) AB(1,2); -1*AB(1,2) AB(1,1)];
        % \：左除，a\b表示矩阵a的逆乘以b
%         ADT = H\[norm(AB)*Lmin*cos(alpha);norm(AB)*Lmin*sin(alpha)];
        %求AB与AC的叉积
        crossABAC = cross([AB 0], [AC 0]);
        if (crossABAC(1,3) < 0)
            ADT = H\[norm(AB)*Lmin*cos(assignAngle);norm(AB)*Lmin*sin(-1*assignAngle)];
        else
            ADT = H\[norm(AB)*Lmin*cos(assignAngle);norm(AB)*Lmin*sin(assignAngle)];
        end
        DT = ADT + A';
        D = DT';
        %更新newPath
        newPath = [newPath; A];
        %更新waitCheckPoint与id
        waitCheckPoint = [A;D;waitCheckPoint(id+1:end,:)];
        id = 2;
    %若该点满足最小夹角，那么waitCheckPoint无需更新
    %但需要对id与newPath更新
    else
        newPath = [newPath;A];
        id = id+1;
    end
    num = num + 1;
    if(num > maxNum)
        break;
    end
end

newPath = [newPath;path(end,:)];

%中间点插值 insertPoint
midPath = [newPath(1,:)];

for i=2:size(newPath,1)
    A = newPath(i,:);
    B = newPath(i-1,:);
    D = (A+B)./2;
    midPath = [midPath;D;A];
end
smoothPath = midPath;
end