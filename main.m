%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ���ڶ�ά��ĸ�Ƶ�ز��״�����ز��������
% % Author:RadarSun(ZhicongSun)
% % Data:from 2020.03.05 to 2020.xx.xx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%ȫ�ֱ�����ʼ��
clear; close all;
derad = pi/180;
num_of_echoes = 1;			%��Դ����

signal.freq = 4.7*10^6;		%���䣨���գ��ź�Ƶ��4.7Mhz
signal.theta = 0;			%���䣨���գ��źų�ʼ��λ
signal.lamda = (3*10^8)/signal.freq;%���䣨���գ��źŲ���

array.num = 8;			%������Ԫ�ܸ���
array.x_num = 4;		%X������Ԫ����
array.y_num = 4;		%Y������Ԫ����
array.spacing = signal.lamda/2;%��Ԫ���

%%��Ԫλ����Ϣ 8x8��16����Ԫ
axis_range.x = [array.spacing  2*array.spacing  3*array.spacing  4*array.spacing ...
                5*array.spacing 6*array.spacing 7*array.spacing 8*array.spacing 0 0 0 0 0 0 0 0];
axis_range.y = [0 0 0 0 0 0 0 0 0  array.spacing  2*array.spacing  3*array.spacing ...
                4*array.spacing 5*array.spacing 6*array.spacing 7*array.spacing];
axis_range.z = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

figure(1);
scatter3(axis_range.x, axis_range.y, axis_range.z);
axis([0, 9*array.spacing, 0, 9*array.spacing, 0, 9*array.spacing]);
title("L���������ʾ��ͼ");
xlabel('X');
ylabel('Y��������');
zlabel('Z');
