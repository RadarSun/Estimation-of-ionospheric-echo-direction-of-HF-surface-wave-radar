function [snr,rmse]=root_music(theta0,element_num,d_lamda)
%{
        Function description:
                һά��ͨ�����γ�
        Syntax��
                Input:
                        theta0��Ŀ��Ƕ�,��λΪrad,�ɶ�Ŀ��,��: theta0 = [30,20]/180*pi
                        element_num����Ԫ����
                        d_lamda: ��Ԫ�����lamda�ı�������λ1��ʾ������0.5��ʾ�벨��
                Output:
        Log description��
                2020.03.25  ��������
%} 
twpi = 2*pi;
d=0:d_lamda:(element_num-1)*d_lamda;     
iwave = length(theta0);             
n =200;                 
A=exp(-j*twpi*d.'*(sin(theta0/180*pi)));
S=randn(iwave,n);
X0=A*S;
theta0_sort = sort(theta0);
snr0=0:1:30;
for isnr=1:20
    X=awgn(X0,snr0(isnr),'measured');
    Rxx=X*X';
    InvS=inv(Rxx); 
    [EVx,Dx]=eig(Rxx);
    EVAx=diag(Dx)';
    [EVAx,Ix]=sort(EVAx);
    EVAx=fliplr(EVAx);
    EVx=fliplr(EVx(:,Ix));
    % Root-MUSIC
    Unx=EVx(:,iwave+1:element_num);
    syms z;
    pz = z.^([0:element_num-1]');
    pz1 = (z^(-1)).^([0:element_num-1]);
    fz = z.^(element_num-1)*pz1*Unx*Unx'*pz;
    a = sym2poly(fz);
    zx = roots(a);
    rx=zx.';
    [as,ad]=(sort(abs((abs(rx)-1))));
    DOAest=asin(sort(-angle(rx(ad([1,3,5])))/pi))*180/pi;
    doaes_sort = sort(DOAest);
    rmse(isnr) = sqrt( sum((theta0_sort-doaes_sort).^2)/iwave);
end
snr = snr0(1:20);
end