function [abs_f,abs_p]=normal(theta0,element_num,d_lamda)
%{
    Function description:
            һά��ͨ�����γ�
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
        theta0 = 30;
        element_num=8;%��Ԫ��Ϊ8
        d_lamda=1/2;%��Ԫ���d�벨��lamda�Ĺ�ϵ
    end
    imag=sqrt(-1);
    snapshot = 100;
    snr = 10;
    theta=linspace(-90,90,200);
    %theta0=[0,37]/180*pi;%��������
    w=exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0/180*pi));%MxK
    if length(theta0) ~= 1
        wtemp = exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0(1)/180*pi));
    else
        wtemp = exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0/180*pi));
    end
    S = rand(length(theta0),snapshot);%KxP
    X = w*S;%MxP
    X1 = awgn(X,snr,'measured');
    Rxx = X1*X1'/snapshot; 
    for  j=1:length(theta)
        a=exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta(j)/180*pi));%Mx1
        f(j)=wtemp'*a;%ȡ��һ����������ͼ
        p(j) = a'*Rxx*a;
    end
    abs_f=abs(f);
%     abs_f_max=max(abs_f);
%     abs_f = 10*log10(abs_f/abs_f_max);
    abs_p=abs(p);
    abs_p_max=max(abs_p);
    abs_p = 10*log10(abs_p/abs_p_max);
end    
