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
        theta0 = 30/180*pi;
    end
    imag=sqrt(-1);
    snapshot = 100;
    snr = 10;
    %element_num=8;%��Ԫ��Ϊ8
    %d_lamda=1/2;%��Ԫ���d�벨��lamda�Ĺ�ϵ
    theta=linspace(-pi/2,pi/2,200);
    %theta0=[0,37]/180*pi;%��������
    w=exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0));%MxK
    if length(theta0) ~= 1
        wtemp = exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0(1)));
    else
        wtemp = exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta0));
    end
    S = rand(length(theta0),snapshot);%KxP
    X = w*S;%MxP
    X1 = awgn(X,snr,'measured');
    Rxx = X1*X1'/snapshot; 
    for  j=1:length(theta)
        a=exp(imag*2*pi*d_lamda*[0:element_num-1]'*sin(theta(j)));%Mx1
         f(j)=wtemp'*a;%ȡ��һ����������ͼ
        p(j) = a'*Rxx*a;
    end
    abs_f=abs(f);
    abs_p=abs(p);
end    
