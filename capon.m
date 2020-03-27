function [abs_f,abs_p]=capon(theta0,element_num,d_lamda)
    %{
    Function description:
            һάCapon�㷨
    Syntax��
            Input:
                    theta0��Ŀ��Ƕ�,��λΪrad,�ɶ�Ŀ��,��: theta0 = [30,20]/180*pi
                    element_num����Ԫ����
                    d_lamda: ��Ԫ�����lamda�ı�������λ1��ʾ������0.5��ʾ�벨��
            Output:
                    abs_f������ͼ�ķ�ֵ
                    abs_p�������׷�ֵ
    Log description��
            2020.03.17  ��������
            2020.03.20  Ϊ�˶ԱȲ�ͬ�㷨����������ʾ�޳������������������
%}  
    if nargin == 0
        theta0 = 30/180*pi;
    end
    imag=sqrt(-1);
    snapshot = 200;
    snr = 10;
    theta=linspace(-pi/2,pi/2,200);
    a=exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0));%MxK
    if length(theta0) ~= 1
        steer = exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0(1)));
    else
        steer = exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0));
    end
    S = rand(length(theta0),snapshot);%KxP
    X = a*S;%MxP
    X1 = awgn(X,snr,'measured');
    Rxx = X1*X1'/snapshot; 
    R = inv(Rxx);
    A = R*steer/(steer'*R*steer);
    for  j=1:length(theta)
        w=exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta(j)));%Mx1
        f(j)=A'*w;%ȡ��һ����������ͼ
        p(j) = 1/(w'*R*w);
    end
    abs_f=abs(f);
    abs_f_max=max(abs_f);
    abs_f = 10*log10(abs_f/abs_f_max);
    abs_p=abs(p);
    abs_p_max=max(abs_p);
    abs_p = 10*log10(abs_p/abs_p_max);
end    

% function capon()
%     clc;
%     clear all;
%     close all;
%     imag=sqrt(-1);
%     element_num=8;%��Ԫ��
%     d_lambda=0.5;%��Ԫ����벨���Ĺ�ϵ
%     theta=-90:0.5:90; %������Χ
%     theta0=0; %�����ź�Դ����������
%     theta1=20;
%     theta2=60;
%     L=1000;%������Ԫ��
%     for i=1:L
%         amp0=10*randn(1);
%         amp1=200*randn(1);
%         amp2=200*randn(1);
%         ampn=3;  
%         x(:,i)=amp0*exp(imag*2*pi*d_lambda*sin(theta0*pi/180)*[0:element_num-1]')+amp1*exp(imag*2*pi*d_lambda*sin(theta1*pi/180)*[0:element_num-1]')+amp2*exp(imag*2*pi*d_lambda*sin(theta2*pi/180)*[0:element_num-1]')+ampn*(randn(element_num,1)+imag*randn(element_num,1));
%     end
%     Rx=1/L*x*x';
%     R=inv(Rx);
%     steer=exp(imag*2*pi*d_lambda*sin(theta0*pi/180)*[0:element_num-1]');
%     w=R*steer/(steer'*R*steer);%����Ȩʸ��
%     for j=1:length(theta)
%         a=exp(imag*2*pi*d_lambda*sin(theta(j)*pi/180)*[0:element_num-1]');
%         f(j)=w'*a;
%         p(j)=1/(a'*R*a);
%     end
%     F=20*log10(abs(f)/(max(max(abs(f)))));
%     subplot(1,2,1)
%     plot(theta,F);
%     grid on;
%     hold on;
%     plot(theta0,-50:0,'.');
%     plot(theta1,-50:0,'.');
%     plot(theta2,-50:0,'.');
%     xlabel('theta/��');
%     ylabel('F/dB');
%     title('Capon beamforming ����ͼ');
%     axis([-90 90 -50 0]);
%     P=20*log10(abs(p)/(max(max(abs(p)))));
%     subplot(1,2,2)
%     plot(theta,P);
%     grid on;
%     hold on;
%     xlabel('theta/��');
%     ylabel('P/dB');
%     title('Capon beamforming ������');
%     axis([-90 90 -90 0]);
% end
