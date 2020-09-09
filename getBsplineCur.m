function [s, cur]=getBsplineCur(degree, contrlPoint, kv)
% 获取均匀B-spline或clamped B-spline的曲率
% degree B-spline 阶数
% contrlPoint控制点
% kv 节点向量 
m = length(kv) - 1;
n = size(contrlPoint,1) - 1;
if(m ~= n + 1 + degree)
    disp('输入的点数与节点向量数不匹配');
end

deltaKV = kv(degree+2) - kv(degree+1);
%一阶导控制点
contrlPoint1 = [];
kv1 = kv(:,2:end-1);
%二阶导控制点
contrlPoint2 = [];
kv2 = kv1(:,2:end-1);
%求一阶导
for i=1:size(contrlPoint)-1
    point_ = degree .* (contrlPoint(i+1,:) - contrlPoint(i,:)) ./ deltaKV;
    contrlPoint1 = [contrlPoint1; point_];
end
[dif1X, dif1Y, s] = BSpline(degree-1,contrlPoint1, kv1);
%求二阶导

for i=1:size(contrlPoint1)-1
    point_ = (degree-1) .* (contrlPoint1(i+1,:) - contrlPoint1(i,:)) ./ deltaKV;
    contrlPoint2 = [contrlPoint2; point_];
end
[dif2X, dif2Y, ~] = BSpline(degree-2,contrlPoint2, kv2);

%计算曲率
cur = (dif1X.*dif2Y - dif2X.*dif1Y)./((dif1X.^2 + dif1Y.^2).^1.5);

end