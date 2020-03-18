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

%��̬����
g_para.rad = pi/180;        %����
g_signal.freq = 4.7*10^6;     %���䣨���գ��ź�Ƶ��4.7Mhz
g_signal.lamda = (3*10^8)/g_signal.freq;%���䣨���գ��źŲ���

%Ĭ�ϵĿɱ����
testmode = 'array_num';
g_array.num = 16;                %������Ԫ�ܸ���
g_array.x_num = 8;		        %X������Ԫ����
g_array.y_num = 8;		        %Y������Ԫ����
g_array.span = g_signal.lamda/2; %��Ԫ���
g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;

g_echos.theta.num = 60;
g_echos.phi.num = 10;
g_echos.theta.rad = g_echos.theta.num*g_para.rad;
g_echos.phi.rad = g_echos.phi.num*g_para.rad;
g_echos.num = 1;        %�ز���
g_echos.snr = 10;
g_echos.snapshot = 100; %������
g_echos.t = [0:99]/1000;
g_echos.signal=sqrt(10^(g_echos.snr/10))*exp(j*2*pi*g_signal.freq*g_echos.t);  %���������ź� 

if((strcmp(testmode,'array_num')==0)&(strcmp(testmode,'array_span')==0))
    plotarray();
end
switch testmode
    case 'array_num'
        g_array.num = 8;                %������Ԫ�ܸ���
        g_array.x_num = 4;		        %X������Ԫ����
        g_array.y_num = 4;		        %Y������Ԫ����
        g_array.span = g_signal.lamda/2; %��Ԫ���
        g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
        g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;
        beamforming('normal');
        g_array.num = 16;                %������Ԫ�ܸ���
        g_array.x_num = 8;		        %X������Ԫ����
        g_array.y_num = 8;		        %Y������Ԫ����
        g_array.span = g_signal.lamda/2; %��Ԫ���
        g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
        g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;
        beamforming('normal');
        g_array.num = 32;                %������Ԫ�ܸ���
        g_array.x_num = 16;		        %X������Ԫ����
        g_array.y_num = 16;		        %Y������Ԫ����
        g_array.span = g_signal.lamda/2; %��Ԫ���
        g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
        g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;
        beamforming('normal');
    case 'array_span'
        g_array.span = g_signal.lamda/4; %��Ԫ���
        g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
        g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;
        beamforming('normal');
        g_array.span = g_signal.lamda/2; %��Ԫ���
        g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
        g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;
        beamforming('normal');
        g_array.span = g_signal.lamda/2*3; %��Ԫ���
        g_array.x_pos = g_array.span : g_array.span : (g_array.x_num)*g_array.span;
        g_array.y_pos = 0 : g_array.span : (g_array.y_num-1)*g_array.span;
        beamforming('normal');
    case 'snapshot_num'
    case 'doa'
        g_echos.num = 3;            %�ز��� 
        g_echos.theta.num = [15 45 75] ;
        g_echos.phi.num = [70 46 10];
        g_echos.theta.rad = g_echos.theta.num*g_para.rad;
        g_echos.phi.rad = g_echos.phi.num*g_para.rad;
        g_echos.signal = rand(g_echos.num,g_echos.snapshot);
        doa();
%         g_echos.signal = [exp(j*2*pi*g_signal.freq*g_echos.t);...
%                           exp(j* (2*pi*(g_signal.freq+1)*g_echos.t+30*g_para.rad) );...
%                           exp(j* (2*pi*(g_signal.freq+2)*g_echos.t+60*g_para.rad) )];
    case 'dbf'
        beamforming('normal');
    otherwise
end

function  plotarray()
%{
    Function description:
            ��8x8����ͼ���������ǹ̶���
    Syntax��
    Log description��
            2020.03.17  ��������
%}  
    global   g_array g_axis_range;
    g_axis_range.x = [g_array.span  2*g_array.span  3*g_array.span  4*g_array.span ...    %��Ԫλ����Ϣ 8x8��16����Ԫ
        5*g_array.span 6*g_array.span 7*g_array.span 8*g_array.span 0 0 0 0 0 0 0 0];
    g_axis_range.y = [0 0 0 0 0 0 0 0 0  g_array.span  2*g_array.span  3*g_array.span ...
        4*g_array.span 5*g_array.span 6*g_array.span 7*g_array.span];
    g_axis_range.z = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    figure('Name','L��ʾ��ͼ','NumberTitle','off','Color','white','Position',[200 200 400 400]);
    scatter3(g_axis_range.x, g_axis_range.y, g_axis_range.z);
    axis([0, 9*g_array.span, 0, 9*g_array.span, 0, 9*g_array.span]);
    title("L���������ʾ��ͼ");
    xlabel('X/m');
    ylabel('Y/m��������');
    zlabel('Z');
end
