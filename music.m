function [abs_p,peak_ang,snr,rmse]=music(theta0,element_num,d_lamda,multipath_mode)
%{
        Function description:
                һά��ͨ�����γ�
        Syntax��
                Input:
                        theta0��Ŀ��Ƕ�,��λΪrad,�ɶ�Ŀ��,��: theta0 = [30,20]/180*pi
                        element_num����Ԫ����
                        d_lamda: ��Ԫ�����lamda�ı�������λ1��ʾ������0.5��ʾ�벨��
                Output:
                        abs_p�������׷�ֵ
        Log description��
                2020.03.25  ��������
%}  
derad = pi/180;        
radeg = 180/pi;
twpi = 2*pi;
d=0:d_lamda:(element_num-1)*d_lamda;     
iwave = 3;              
n = 200;                 
A=exp(-j*twpi*d.'*sin(theta0));
if strcmp(multipath_mode,'multi_path')==1
    S0 = randn(iwave-1,n);
    S = [S0(1,:);S0];
else
    S=randn(iwave,n);
end
X=A*S;
snr0=0:1:30;
for isnr=1:20
    X1=awgn(X,snr0(isnr),'measured');
    Rxx=X1*X1'/n;
    InvS=inv(Rxx); 
    [EV,D]=eig(Rxx); 
    EVA=diag(D)';
    [EVA,I]=sort(EVA);
    EVA=fliplr(EVA);
    EV=fliplr(EV(:,I));
    % MUSIC
    for iang = 1:361
            angle(iang)=(iang-181)/2;
            phim=derad*angle(iang);
            a=exp(-j*twpi*d*sin(phim)).';
            L=iwave;    
            En=EV(:,L+1:element_num);
            P(iang)=(a'*a)/(a'*En*En'*a);
    end
    abs_p=abs(P);
    abs_p_max=max(abs_p);
    abs_p=10*log10(abs_p/abs_p_max);
    peak_ang = [];
    derivative = diff(abs_p);
    for iang = 5:360
        if( (abs_p(iang)>abs_p(iang-1)) && (abs_p(iang)>abs_p(iang+1)) && (derivative(iang-4)>0.5) )
            peak_ang = [peak_ang iang];
        end
    end
    peak_ang = (peak_ang-181)/2;
    size(peak_ang)
    rmse(isnr) = sqrt( sum((theta0/pi*180-peak_ang).^2)/iwave);
end
    snr = snr0(1:20);
end