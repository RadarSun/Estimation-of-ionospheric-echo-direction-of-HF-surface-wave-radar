function msnr()
    clc;
    clear all;
    close all;
    imag=sqrt(-1);
    element_num=8;%��Ԫ��Ϊ8
    d_lambda=0.5;%���Ϊ�벨��
    theta=-90:0.5:90;%ɨ�跶Χ
    theta0=0;%������λ
    theta1=20;%���ŷ���
    L=512;%��������
    for i=1:L
        amp0=10*randn(1);
        amp1=200*randn(1);
        ampn=1;    s(:,i)=amp0*exp(imag*2*pi*0.5*sin(theta0*pi/180)*[0:element_num-1]');   j(:,i)=amp1*exp(imag*2*pi*0.5*sin(theta1*pi/180)*[0:element_num-1]');    n(:,i)=ampn*exp(randn(element_num,1)+imag*randn(element_num,1));
    end
    Rs=1/L*s*s';%�ź�����ؾ���
    Rnj=1/L*(j*j'+n*n'); %����+����������ؾ���
    [V,D]=eig(Rs,Rnj); %��Rs,Rnj���Ĺ�������ֵ����������
    [D,I]=sort(diag(D)); %������������
    Wopt=V(:,I(8));%����Ȩʸ��
    for j=1:length(theta)
    a=exp(imag*2*pi*d_lambda*sin(theta(j)*pi/180)*[0:element_num-1]');
        f(j)=Wopt'*a;
        p(j)=a'*Rs*a+a'*Rnj*a;
    end
    F=20*log10(abs(f)/max(max(abs(f))));
    P=20*log10(abs(p)/max(max(abs(p))));
    subplot(1,2,1)
    plot(theta,F);
    grid on;
    hold on;
    plot(theta0,-80:0,'.');
    plot(theta1,-80:0,'.');
    xlabel('theta/0');
    ylabel('F in dB');
    title('max-SNR ����ͼ');
    axis([-90 90 -80 0]);
    hold on;
    subplot(1,2,2);
    plot(theta,P,'r');
    grid on;
    xlabel('theta/0');
    ylabel('���� in dB');
    title('max-SNR ������');
    grid on;
    axis([-90 90 -80 0]);
end