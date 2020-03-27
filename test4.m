clc;
clear all;
close all;
imag=sqrt(-1);
element_num=8;%��Ԫ��
d_lambda=0.5;%��Ԫ����벨���Ĺ�ϵ
theta=-90:0.5:90; %������Χ
theta0=0; %�����ź�Դ����������
theta1=20;
theta2=60;
L=1000;%������Ԫ��
for i=1:L
    amp0=10*randn(1);
    amp1=200*randn(1);
    amp2=200*randn(1);
    ampn=3;   
    x(:,i)=amp0*exp(imag*2*pi*d_lambda*sin(theta0*pi/180)*[0:element_num-1]')...
    +amp1*exp(imag*2*pi*d_lambda*sin(theta1*pi/180)*[0:element_num-1]')...
    +amp2*exp(imag*2*pi*d_lambda*sin(theta2*pi/180)*[0:element_num-1]')...
    +ampn*(randn(element_num,1)+imag*randn(element_num,1));
end
Rx=1/L*x*x';
R=inv(Rx);
steer=exp(imag*2*pi*d_lambda*sin(theta0*pi/180)*[0:element_num-1]');
w=R*steer/(steer'*R*steer);%����Ȩʸ��
for j=1:length(theta)
    a=exp(imag*2*pi*d_lambda*sin(theta(j)*pi/180)*[0:element_num-1]');
    f(j)=w'*a;
    p(j)=1/(a'*R*a);
end
F=20*log10(abs(f)/(max(max(abs(f)))));
subplot(1,2,1)
plot(theta,F);
grid on;
hold on;
plot(theta0,-50:0,'.');
plot(theta1,-50:0,'.');
plot(theta2,-50:0,'.');
xlabel('theta/��');
ylabel('F/dB');
title('Capon beamforming ����ͼ');
axis([-90 90 -50 0]);
P=20*log10(abs(p)/(max(max(abs(p)))));
subplot(1,2,2)
plot(theta,P);
grid on;
hold on;
xlabel('theta/��');
ylabel('P/dB');
title('Capon beamforming ������');
axis([-90 90 -90 0]);



function doa(input)
    %{
        Function description:
                2D-DOA�����㷨ѡ����
        Syntax��
                input:doa�㷨����
        Log description��
                2020.03.10 ���doaѡ����������music2d
    %}
        if nargin<1
            input = "music2d";
        end
        switch input
            case 'music2d'
                music2d();
            otherwise 
                error('Error! Invalid input! ');
        end
    end
    
    
    function music2d()
    %{
        Function description:
                2D-MUSIC DOA�㷨
        Syntax��
        Log description��
                2020.03.10 ���music2d���������ڷ������׷������
    %}
        global g_signal;
        global g_array;
        global g_echos;
        global g_para;
        
        %������Ԫ���������ǻز�����
        Ax = exp( -j*2*pi/g_signal.lamda*(cos(g_echos.theta.rad).*cos(g_echos.phi.rad)).'*g_array.x_pos);
        %k =g_array.x_pos.'/g_signal.lamda
        Ay = exp( -j*2*pi/g_signal.lamda*(cos(g_echos.theta.rad).*sin(g_echos.phi.rad)).'*g_array.y_pos);
        A = [Ax ; Ay];%������Ԫ����
        X = A*g_echos.signal;
        X1 = awgn(X,g_echos.snr,'measured');
        %X1= X;%����������
        Rxx = X1*X1'/g_echos.snapshot;
        
        [eigenvector,eigenvalue] = eig(Rxx);
        [EVA,I] = sort(diag(eigenvalue).');
        eigenvector = fliplr(eigenvector(:,I));
        Un = eigenvector(:,g_echos.num+1:end);
        for ang1 = 1:90
            for ang2 = 1:90
                thet(ang1) = ang1-1;%0~89��
                phim1 = thet(ang1)*g_para.rad; 
                f(ang2) = ang2-1;
                phim2 = f(ang2)*g_para.rad;
                ax = exp(-j*2*pi/g_signal.lamda*g_array.x_pos.*cos(phim1)*cos(phim2));
                ay = exp(-j*2*pi/g_signal.lamda*g_array.y_pos.*cos(phim1)*sin(phim2));
                a = [ax;ay];
                SP(ang1,ang2) = 1/(a'*Un*Un'*a);
            end
        end
        SP=abs(SP);
        %[linemax,linemax_id] = max(SP);
        %[rowmax,rowmax_id] = max(linemax);
        %rowmax_id
        %SP(rowmax_id,linemax_id);
        SPmax=max(max(SP));
        SP=SP/SPmax; 
        figure('Color','white');
        h = mesh(thet,f,SP);
        set(h,'Linewidth',2)
        xlabel('����(degree)');
        ylabel('��λ(degree)');
        zlabel('magnitude(dB)');
    
    end

    function normaldbf()
        %{
            Function description:
                    ��ͨDBF�㷨������2D-DOA����
            Syntax��
            Log description��
                    2020.03.11  ����ʵ��DBF������Ŀ�겨�ź������⣺��Ŀ����ֶ��Ⲩ�壬��άͼXY�ߵ�
                    2020.03.12  ���mesh���ڵ�XY����ߵ����⣬��sum�����Ŀ�굼��ʸ����������Ⲩ��
        %}
            global g_signal;
            global g_array;
            global g_echos;
            global g_para;
            tic;
            
            theta.rad=linspace(-pi/2,pi/2,181);
            theta.num = theta.rad/pi*180;
            phi.rad=linspace(-pi/2,pi/2,181);
            phi.num = phi.rad/pi*180;
        
            %��ͨ���ֲ����γ�
            wx=exp(-j*2*pi/g_signal.lamda*g_array.x_pos.'*sin(g_echos.theta.rad).*cos(g_echos.phi.rad));
            wx = sum(wx,2);%�������,���Ը�����Դ�ĵ��������ۼ�,��������wx = wx(:,1) + wx(:,2);
            wy=exp(-j*2*pi/g_signal.lamda*g_array.y_pos.'*sin(g_echos.theta.rad).*sin(g_echos.phi.rad));
            wy = sum(wy,2);
            W = kron(wx,wy);%�൱�ڽ�wx*wy�����ÿһ����λ����һ��ĩβ���γ�һά����
            X = W*g_echos.signal;
            X1 = awgn(X,g_echos.snr,'measured');
            Rxx = X1*X1'/g_echos.snapshot;   
            for k = 1:length(theta.rad)
                for  i = 1:length(phi.rad)
                    ax=exp(-j*2*pi/g_signal.lamda*g_array.x_pos.'*sin(theta.rad(k)).*cos(phi.rad(i)));
                    ay=exp(-j*2*pi/g_signal.lamda*g_array.y_pos.'*sin(theta.rad(k)).*sin(phi.rad(i)));
                    A = kron(ax,ay);
                    F(k,i) = W'*A;
                    P(k,i) = A'*Rxx*A;
                end        
            end
            toc;
            disp(['��ͨ�����γ��㷨��ʱ��',num2str(toc),'s']);
        
            %������ͼ
            abs_F=abs(F);
            %abs_F_norm=abs_F/max(max(abs_F));
            %abs_F_dB=20*log10(abs_F);
            %abs_F_norm_dB=20*log10(abs_F_norm);
            absf_theta = sum(abs_F,2);
            absf_phi = sum(abs_F,1);
            figure('Name','����ͼ','NumberTitle','off','Color','white','Position',[600 50 550 750]);
            subplot(311);
            f = meshc(phi.num,theta.num,abs_F);% mesh(X,Y,Z)X,Y�ֱ��ӦZ���С��У�mesh̫���ˣ�Ҫ��XY�û���
            title(['��ά����ͼ,��Ԫ��:' num2str(g_array.num) ',��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda,ָ��[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']' ]);
            set(f,'Linewidth',2);
            xlabel('��λ��phi(degree)');
            ylabel('������theta(degree)');
            zlabel('abs of F');
            subplot(312);
            plot(theta.num,absf_theta);
            title('������ �ķ���ͼ');
            xlabel('theta(degree)');
            ylabel('abs of Ptheta');
            subplot(313);
            plot(phi.num,absf_phi);
            title('��λ�� �ķ���ͼ');
            xlabel('phi(degree)');
            ylabel('abs of Pphi');
            
            %��������
            abs_P = abs(P);
            absp_theta = sum(abs_P,2);%2�Ƕ�����ӣ��õ���������1���ǵõ�������
            absp_phi = sum(abs_P,1);
            %�׷�����
            [temp_ptheta,theta_estimation] = max(absp_theta);
            [temp_pphi,phi_estimation] = max(absp_phi);
            theta_estimation = theta_estimation-91;
            phi_estimation = phi_estimation-91;
            disp(['���ƽǶ�Ϊ[',num2str(theta_estimation),',',num2str(phi_estimation),']']);
            
            figure('Name','������','NumberTitle','off','Color','white');
            subplot(311);
            p = meshc(phi.num(91:181),theta.num(91:181),abs_P(91:181,91:181));
            title(['��ά������,��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda, ʵ�ʷ���Ϊ[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']' ...
                '���Ʒ���Ϊ[' num2str(theta_estimation) ',' num2str(phi_estimation) ']']);
            set(p,'Linewidth',2);
            xlabel('��λ��phi(degree)');
            ylabel('������theta(degree)');
            zlabel('abs of P');
            subplot(312);
            plot(theta.num,absp_theta);
            title('������ �Ĺ�����');
            xlabel('theta(degree)');
            ylabel('abs of Ptheta');
            subplot(313);
            plot(phi.num,absp_phi);
            title('��λ�� �Ĺ�����');
            xlabel('phi(degree)');
            ylabel('abs of Pphi');
        
        end 
        
        

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
            snr = 10;               
            n = 500;                 
            A=exp(-j*twpi*d.'*sin(theta0));
            if strcmp(multipath_mode,'multi_path')==1
                S0 = randn(iwave-1,n);
                S = [S0(1,:);S0];
            else
                S=randn(iwave,n);
            end
            X=A*S;
            snr0=0:3:100;
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
                for iang = 2:360
                    if( (abs_p(iang)>abs_p(iang-1)) && (abs_p(iang)>abs_p(iang+1)) && (derivative(iang-1)>0.5) )
                        peak_ang = [peak_ang iang];
                    end
                end
                peak_ang = (peak_ang-181)/2;
                size(peak_ang)
                rmse(isnr) = sqrt( sum((theta0/pi*180-peak_ang).^2)/iwave);
            end
                snr = snr0(1:20);
            end