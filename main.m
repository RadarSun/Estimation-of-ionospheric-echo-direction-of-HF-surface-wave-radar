%{
    * ���ڶ�ά��ĸ�Ƶ�ز��״�����ز��������
    * Description: my graduation projec
    * Author: ZhicongSun from HITWH
    * Email:hitsunzhicong@163.com
    * Github address: https://github.com/RadarSun
    * Data: from 2020.03.05 to 2020.03.12
%}

%%
%%ȫ�ֱ�����ʼ��
close all; 
clear global;
clear all; 

global g_para g_signal g_array g_axis_range;
global g_echos;

g_para.rad = pi/180;        %����

%g_signal.numb = 1;            %��Դ������δʹ�ã�
g_signal.freq = 4.7*10^6;     %���䣨���գ��ź�Ƶ��4.7Mhz
%g_signal.theta = 0;           %���䣨���գ��źų�ʼ��λ��δʹ�ã�

g_signal.lamda = (3*10^8)/g_signal.freq;%���䣨���գ��źŲ���
%g_signal.lamda = 1%���䣨���գ��źŲ���

g_array.num = 16;                %������Ԫ�ܸ���
g_array.x_num = 8;		        %X������Ԫ����
g_array.y_num = 8;		        %Y������Ԫ����
g_array.span = g_signal.lamda/2; %��Ԫ���
g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;
% g_array.x_pos = 0 : g_array.span : (g_array.x_num-1)*g_array.span;
% g_array.y_pos = g_array.span : g_array.span : (g_array.y_num-1)*g_array.span;


g_axis_range.x = [g_array.span  2*g_array.span  3*g_array.span  4*g_array.span ...    %��Ԫλ����Ϣ 8x8��16����Ԫ
    5*g_array.span 6*g_array.span 7*g_array.span 8*g_array.span 0 0 0 0 0 0 0 0];
g_axis_range.y = [0 0 0 0 0 0 0 0 0  g_array.span  2*g_array.span  3*g_array.span ...
    4*g_array.span 5*g_array.span 6*g_array.span 7*g_array.span];
g_axis_range.z = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
figure();
scatter3(g_axis_range.x, g_axis_range.y, g_axis_range.z);
axis([0, 9*g_array.span, 0, 9*g_array.span, 0, 9*g_array.span]);
title("L���������ʾ��ͼ");
xlabel('X/m');
ylabel('Y/m��������');
zlabel('Z');

%g_echos.theta.num = [10  30 50];%����
g_echos.theta.num = 10;
g_echos.theta.rad = g_echos.theta.num*g_para.rad;
%g_echos.phi.num = [15 25 35];%��λ
g_echos.phi.num = 60;
g_echos.phi.rad = g_echos.phi.num*g_para.rad;

%g_echos.num = 3;            %�ز���
g_echos.num = 1;            %�ز���
g_echos.snr = 10;
g_echos.snapshot = 100; %������
g_echos.t = (0:99)/1000;
%g_echos.signal = [sin(2*pi*g_signal.freq*g_echos.t) ;...
%                  sin(2*pi*g_signal.freq*(g_echos.t+10));...
%                  sin(2*pi*g_signal.freq*(g_echos.t+20))];
% g_echos.signal = [sin(2*pi*g_signal.freq*g_echos.t) ;...
%                   sin(2*pi*g_signal.freq*(g_echos.t+10))];

% g_echos.signal = [sin(2*pi*g_signal.freq*g_echos.t);...
%                   sin((2*pi*g_signal.freq*g_echos.t)+30*g_para.rad );...
%                   sin((2*pi*g_signal.freq*g_echos.t)+60*g_para.rad )];

%size(g_echos.signal)
%g_echos.signal = zeros(g_echos.num,g_echos.snapshot);
%g_echos.signal(1,:) = 20;
%g_echos.signal(2,:) = 10
%g_echos.signal = rand(g_echos.num,g_echos.snapshot);

%test3();
beamforming('normal');
%doa();


%%
