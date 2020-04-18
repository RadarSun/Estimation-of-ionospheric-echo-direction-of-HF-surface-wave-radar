function lcmv()
    clc;
    clear all;
    close all;
    imag=sqrt(-1);
    element_num=8;%��Ԫ��
    d_lambda=0.5;%��Ԫ����벨���Ĺ�ϵ
    theta=-90:0.5:90; %������Χ
    theta0=0; %�����ź�Դ����������
    theta1=30;
    theta2=60;
    L=200;%������Ԫ��
    for i=1:L
        amp0=10*randn(1);
        amp1=10*randn(1);
        amp2=10*randn(1);
        ampn=10;
        x(:,i)=amp0*exp(imag*2*pi*d_lambda*sin(theta0*pi/180)*[0:element_num-1]')...
        +amp1*exp(imag*2*pi*d_lambda*sin(theta1*pi/180)*[0:element_num-1]')...
        +amp2*exp(imag*2*pi*d_lambda*sin(theta2*pi/180)*[0:element_num-1]')...
        +ampn*(randn(element_num,1)+imag*randn(element_num,1));
    end
    Rx=1/L*x*x';
    steer1=exp(imag*2*pi*d_lambda*sin(theta0*pi/180)*[0:element_num-1]');
    steer2=exp(imag*2*pi*d_lambda*sin(theta1*pi/180)*[0:element_num-1]');
    steer3=exp(imag*2*pi*d_lambda*sin(theta2*pi/180)*[0:element_num-1]');
    C=[steer1 steer2 steer3];
    F=[1 0 0]';%������������Ϊ��������
    w=inv(Rx)*C*(inv(C'*inv(Rx)*C))*F;
    for j=1:length(theta)
        a=exp(imag*2*pi*d_lambda*sin(theta(j)*pi/180)*[0:element_num-1]');
        f(j)=w'*a;
        p(j)=1/(a'*inv(Rx)*a);
    end
    F=20*log10(abs(f)/(max(max(abs(f)))));
    figure('Color','white');
    plot(theta,F);
    grid on;
    hold on;
%     plot(theta0,-30:0,'.');
%     plot(theta1,-30:0,'.');
%     plot(theta2,-30:0,'.');
    xlabel('theta/degree');
    ylabel('F/dB');
    title('����LCMV׼��ķ���ͼ');
%     axis([-90 90 -20 0]);
    
    P=20*log10(abs(p)/(max(max(abs(p)))));
    figure('Color','white');
    plot(theta,P);
    grid on;
    hold on;
    plot(theta0,-20:0,'.');
    plot(theta1,-20:0,'.');
    plot(theta2,-20:0,'.');
    xlabel('theta/��');
    ylabel('P/dB');
    title('Capon beamforming ������');
    axis([-90 90 -20 0]);
end