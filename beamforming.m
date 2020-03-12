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

    wx=exp(-j*2*pi/g_signal.lamda*g_array.x_pos.'*cos(g_echos.theta.rad).*cos(g_echos.phi.rad));
    wx = sum(wx,2);%�������,���Ը�����Դ�ĵ��������ۼ�,��������wx = wx(:,1) + wx(:,2);
    wy=exp(-j*2*pi/g_signal.lamda*g_array.y_pos.'*cos(g_echos.theta.rad).*sin(g_echos.phi.rad));
    wy = sum(wy,2);
    W = kron(wx,wy);%�൱�ڽ�wx*wy�����ÿһ����λ����һ��ĩβ���γ�һά����
    for k = 1:length(theta.rad)
        for  i = 1:length(phi.rad)
            ax=exp(-j*2*pi/g_signal.lamda*g_array.x_pos.'*cos(theta.rad(k)).*cos(phi.rad(i)));
            ay=exp(-j*2*pi/g_signal.lamda*g_array.y_pos.'*cos(theta.rad(k)).*sin(phi.rad(i)));
            A = kron(ax,ay);
            P(k,i) = W'*A;
        end        
    end

    patternmag=abs(P);
    patternmagnorm=patternmag/max(max(patternmag));
    patterndB=20*log10(patternmag);
    patterndBnorm=20*log10(patternmagnorm);
    
%     absp_theta = abs(P(:,(g_echos.phi.num+91)));
%     absp_phi = abs(P((g_echos.theta.num+91),:));
    absp_theta = sum(patternmag,1);
    absp_phi = sum(patternmag,2);
    
    figure('Name','����ͼ','NumberTitle','off','Color','white','Position',[600 50 550 750]);
    subplot(311);
    %patternmag = patternmag';% mesh̫���ˣ�Ҫ��XY�û���
    %h = meshc(phi.num,theta.num,patternmag);% mesh(X,Y,Z)X,Y�ֱ��ӦZ���С���
    h = meshc(phi.num(91:181),theta.num(91:181),patternmag(91:181,91:181));% mesh(X,Y,Z)X,Y�ֱ��ӦZ���С���
    title(['��ά����ͼ ��������Ϊtheta=[' num2str(g_echos.theta.num) ']' ',phi=[' num2str(g_echos.phi.num) ']' ]);
    set(h,'Linewidth',2);
    xlabel('��λ��phi(degree)');
    ylabel('������theta(degree)');
    zlabel('abs of P');
    subplot(312);
    plot(theta.num(91:181),absp_theta(91:181));
    %plot(theta.num,absp_theta);
    title('������ �ķ���ͼ');
    xlabel('theta(degree)');
    ylabel('abs of Ptheta');
    subplot(313);
    plot(phi.num(91:181),absp_phi(91:181));   
    %plot(phi.num,absp_phi);
    title('��λ�� �ķ���ͼ');
    xlabel('phi(degree)');
    ylabel('abs of Pphi');
    toc;
    disp(['��ͨ�����γ��㷨��ʱ��',num2str(toc),'s']);
end 
