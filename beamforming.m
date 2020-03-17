function beamforming(input)
 %{
    Function description:
            ���ֲ����γ��㷨ѡ����
    Syntax��
    Log description��
            2020.03.11 ����normaldbf
%}
    if nargin<1
        input = "normal";
    end
    switch input
        case 'normal'
            normaldbf();
        otherwise 
            error('Error! Invalid input! ');
    end
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
    X = g_echos.signal*W;
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
    title(['��ά����ͼ ��������Ϊtheta=[' num2str(g_echos.theta.num) ']' ',phi=[' num2str(g_echos.phi.num) ']' ]);
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
    figure('Name','������','NumberTitle','off','Color','white');
    subplot(311);
    p = meshc(phi.num(91:181),theta.num(91:181),abs_P(91:181,91:181));
    title(['��ά������ ��������Ϊtheta=[' num2str(g_echos.theta.num) ']' ',phi=[' num2str(g_echos.phi.num) ']' ]);
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

    %�׷�����
    [temp_ptheta,theta_estimation] = max(absp_theta);
    [temp_pphi,phi_estimation] = max(absp_phi);
    theta_estimation = theta_estimation-91;
    phi_estimation = phi_estimation-91;
    disp(['���ƽǶ�Ϊ[',num2str(theta_estimation),',',num2str(phi_estimation),']']);

end 
