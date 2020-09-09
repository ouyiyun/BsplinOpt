%b样条实验
clc;clear;close all;
path = ginput() * 100.0;
% 实验一
% path =[8 5;7 15;2 10;11 10;11 14;45 30;45 12;25 45;12 45; 25 25];

% 实验二
% path =[0 50;100 0;250 140;400 0;475 75];

controlPointX = path(:,1)';
controlPointY = path(:,2)';
subplot(2,2,1);
plot(controlPointX, controlPointY , 'Color', [1.0 0 0], 'LineWidth', 1);
hold on
plot(controlPointX, controlPointY , 'k.','MarkerSize', 20);
title('原始路径点');

% [Lmin, ~] = getLAngel(path);
%思想来源：Continuous Path Smoothing for Car-Like Robots Using B-Spline Curves
%B样条平滑：输入原始路径、最大曲率、两线的最小夹角，输出平滑B样条的控制点
%最大曲率
kMax =0.6;
%最小夹角
alphaMin = deg2rad(55); %弧度表示
% alphaMin = getMinAngel(kMax, Lmin);
%输出
Lmin =1/(6*kMax)*sin(alphaMin)*((1-cos(alphaMin))/8)^(-1.5);
%获取平滑后的控制点
boundPath = getSmoothPath(path, kMax,alphaMin);
subplot(2,2,2);
plot(boundPath(:,1), boundPath(:,2) , 'Color', [0 0 1.0], 'LineWidth', 2);
hold on
plot(boundPath(:,1), boundPath(:,2), 'ko','MarkerSize', 5);
title('平滑后路径点');

m = length(boundPath) + 3 + 1;
kv = linspace(0,1,m-6);
kv =[0 0 0 kv 1 1 1];
%deboor
[X,Y] = BSpline(3,boundPath, kv);
subplot(2,2,3);
plot(X', Y' , 'Color', [1 0 0], 'LineWidth', 2);
hold on
plot(boundPath(1:end,1), boundPath(1:end,2) , 'Color', [0 0 1], 'LineWidth', 1);
plot(boundPath(1:end,1), boundPath(1:end,2) , 'ko','MarkerSize', 5);
title('带有曲率约束');

subplot(2,2,4);
[s, cur] = getBsplineCur(3,boundPath,kv);
plot(s, cur, 'Color',[255 128 0]/255, 'LineWidth', 1);
title('曲率');

