function asc_mse()
    clc;
    close all;
    clear all;
    imag=sqrt(-1);
    M=32;%����������Ŀ
    d_lambda=0.5;%��Ԫ���
    theta0=-30;%��������
    theta1=60;%���ŷ���
    L=512;%������Ԫ��
    s=zeros(1,512); %Ԥ����һ������
    for ii=1:L
        amp0=1*randn(1);%�źŵķ��������������֤�ź�֮���ǲ���ص�
        amp1=200*randn(1);
    ampn=1;   
    
    jam(:,ii)=amp1*exp(imag*2*pi*d_lambda*sin(theta1*pi/180)*[0:M-1]')+ampn*(randn(M,1)+imag*randn(M,1)); %����+���� 

    s(ii)=amp0*exp(imag*2*pi*d_lambda*sin(theta0*pi/180))+amp1*exp(imag*2*pi*d_lambda*sin(theta1*pi/180))+ampn*(randn(1,1)+imag*randn(1,1));%�����źţ��ź�+����+������

    s0(ii)=amp0*exp(imag*2*pi*d_lambda*sin(theta0*pi/180));
    end
    Rx=1/L*jam*jam';
    r_xd=1/L*jam*s';
    Wopt=pinv(Rx)*r_xd;
    delta=s0-(s-Wopt'*jam);
    delta1=abs(mean(delta.^2)-(mean(delta)).^2);
    theta=linspace(-pi/2,pi/2,200);
    for jj=1:length(theta)
        a=exp(imag*2*pi*d_lambda*sin(theta(jj))*[0:M-1]');
        f(jj)=Wopt'*a;
    end
    F=20*log10(abs(f)/max(max(abs(f))));
    figure(1)
    plot(theta*180/pi,F);
    grid on;
    hold on;
    plot(theta0,-50:0,'.');
    plot(theta1,-50:0,'.');
    xlabel('theta/��');
    ylabel('F/dB');
    title('MSE׼���µķ���ͼ');
    axis([-90 90 -50 0]);
end