function beamforming(input)
 %{
    Function description:
            ���ֲ����γ��㷨ѡ����
    Syntax��
    Log description��
            2020.03.11  ����normaldbf
            2020.03.19  ����capondbf
%}
    if nargin<1
        input = "normal";
    end
    switch input
        case 'normal'
            normaldbf();
        case 'capon'
            capondbf();
        otherwise 
            error('Error! Invalid input! ');
    end
end

function capondbf()
%{
    Function description:
            ��ͨDBF�㷨������2D-DOA����
    Syntax��
    Log description��
            2020.03.19  ʵ���㷨�������ͨ�����γ���߷ֱ���
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

    %Capon���ֲ����γ�
    ax=exp(j*2*pi/g_signal.lamda*g_array.x_pos.'*(sin(g_echos.theta.rad).*cos(g_echos.phi.rad)));
    ay=exp(j*2*pi/g_signal.lamda*g_array.y_pos.'*(sin(g_echos.theta.rad).*sin(g_echos.phi.rad)));
    A = khatri_rao(ay,ax);%M^2xK
    X = A*g_echos.signal;%M^2xK*KxP=M^2xP 
    X1 = awgn(X,g_echos.snr,'measured');
    Rxx = X1*X1'/g_echos.snapshot;
    R = inv(Rxx);
    if g_echos.num ~= 1
        steerA = A(:,2);%ѡ��һ������ΪĿ�귽������Ϊ����
    else
        steerA = A;
    end
    oneA = R*steerA/(steerA'*R*steerA);
    for k = 1:length(theta.rad)
        for  i = 1:length(phi.rad)
            wx=exp(j*2*pi/g_signal.lamda*g_array.x_pos.'*sin(theta.rad(k)).*cos(phi.rad(i)));
            wy=exp(j*2*pi/g_signal.lamda*g_array.y_pos.'*sin(theta.rad(k)).*sin(phi.rad(i)));
            W = khatri_rao(wy,wx);
            F(k,i) = W'*oneA;%1xM^2 * M^2x1 
            P(k,i) = 1/(W'*R*W);%1xM^2 * M^2xM^2 *M^2x1
        end        
    end
    toc;
    disp(['Capon�����γ��㷨��ʱ��',num2str(toc),'s']);

    %������ͼ
    abs_F=abs(F);
    absf_theta = sum(abs_F,2);
    absf_phi = sum(abs_F,1);
    abs_F_max = max(max(abs_F));
    abs_F = 10*log10(abs_F/abs_F_max);
    absf_theta_max = max(absf_theta);
    absf_theta = 10*log10(absf_theta/absf_theta_max);
    absf_phi_max = max(absf_phi);
    absf_phi = 10*log10(absf_phi/absf_phi_max);
    figure('Name','����ͼ','NumberTitle','off','Color','white','Position',[600 50 550 750]);
    subplot(311);
    f = meshc(theta.num,phi.num,abs_F);% mesh(X,Y,Z)X,Y�ֱ��ӦZ���С��У�mesh̫���ˣ�Ҫ��XY�û���
    title(['��ά����ͼ,��Ԫ��:' num2str(g_array.num) ',��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda,ָ��[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']' ]);
    set(f,'Linewidth',2);
    xlabel('��λ��phi/degree');
    ylabel('������theta/degree');
    zlabel('abs of F');
    subplot(312);
    plot(theta.num,absf_theta);
    title('������ �ķ���ͼ');
    xlabel('theta/degree');
    ylabel('abs of Ptheta');
    subplot(313);
    plot(phi.num,absf_phi);
    title('��λ�� �ķ���ͼ');
    xlabel('phi/degree');
    ylabel('abs of Pphi');
    
    %��������
    abs_P = abs(P);
    absp_theta = sum(abs_P,2);%2�Ƕ�����ӣ��õ���������1���ǵõ�������
    absp_phi = sum(abs_P,1);
    abs_P_max = max(max(abs_P));
    abs_P = 10*log10(abs_P/abs_P_max);
    absp_theta_max = max(absp_theta);
    absp_theta = 10*log10(absp_theta/absp_theta_max);
    absp_phi_max = max(absp_phi);
    absp_phi = 10*log10(absp_phi/absp_phi_max);
    %�׷�����
    [temp_ptheta,theta_estimation] = max(absp_theta);
    [temp_pphi,phi_estimation] = max(absp_phi);
    theta_estimation = theta_estimation-91;
    phi_estimation = phi_estimation-91;
    disp(['���ƽǶ�Ϊ[',num2str(theta_estimation),',',num2str(phi_estimation),']']);
    
    figure('Name','������','NumberTitle','off','Color','white');
    subplot(311);
    p = meshc(theta.num,phi.num,abs_P);
    if g_echos.num ~=1
        title(['��ά������,��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda, ʵ�ʷ���Ϊ[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']'] );
    else
        title(['��ά������,��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda, ʵ�ʷ���Ϊ[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']' ...
        '���Ʒ���Ϊ[' num2str(theta_estimation) ',' num2str(phi_estimation) ']']);
    end
    set(p,'Linewidth',2);
    xlabel('��λ��phi/degree');
    ylabel('������theta/degree');
    zlabel('abs of P');
    subplot(312);
    plot(theta.num,absp_theta);
    title('������ �Ĺ�����');
    xlabel('theta/degree');
    ylabel('abs of Ptheta');
    subplot(313);
    plot(phi.num,absp_phi);
    title('��λ�� �Ĺ�����');
    xlabel('phi(degree)');
    ylabel('abs of Pphi');

   
    figure('Color','white');
    imagesc(phi.num,theta.num,abs_P,'CDataMapping','scaled');
    title('��άCapon�㷨����ɨ�蹦����');
    xlabel('��λ��phi/degree');
    ylabel('������theta/degree');    
    colorbar;

end 
    

function normaldbf()
%{
    Function description:
            ��άCapon�㷨������2D-DOA����
    Syntax��
    Log description��
            2020.03.11  ����ʵ��DBF������Ŀ�겨�ź������⣺��Ŀ����ֶ��Ⲩ�壬��άͼXY�ߵ�
            2020.03.12  ���mesh���ڵ�XY����ߵ����⣬��sum�����Ŀ�굼��ʸ����������Ⲩ��
            2020.03.19  Ax��Ay��������������������ѧģ��
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
    ax=exp(-j*2*pi/g_signal.lamda*g_array.x_pos.'*(sin(g_echos.theta.rad).*cos(g_echos.phi.rad)));
    ay=exp(-j*2*pi/g_signal.lamda*g_array.y_pos.'*(sin(g_echos.theta.rad).*sin(g_echos.phi.rad)));
    A = khatri_rao(ay,ax);%M^2xK
    X = A*g_echos.signal;%M^2xK*KxP=M^2xP 
    X1 = awgn(X,g_echos.snr,'measured');
    Rxx = X1*X1'/g_echos.snapshot;
    if g_echos.num ~= 1
        oneA = A(:,1);%ѡ��һ�����򻭷���ͼ
    else
        oneA = A;
    end
    for k = 1:length(theta.rad)
        for  i = 1:length(phi.rad)
            wx=exp(-j*2*pi/g_signal.lamda*g_array.x_pos.'*sin(theta.rad(k)).*cos(phi.rad(i)));
            wy=exp(-j*2*pi/g_signal.lamda*g_array.y_pos.'*sin(theta.rad(k)).*sin(phi.rad(i)));
            W = khatri_rao(wy,wx);
            F(k,i) = W'*oneA;%1xM^2 * M^2x1 
            P(k,i) = W'*Rxx*W;%1xM^2 * M^2xM^2 *M^2x1
        end        
    end
    toc;
    disp(['��ͨ�����γ��㷨��ʱ��',num2str(toc),'s']);

    %������ͼ
    abs_F=abs(F);
    absf_theta = sum(abs_F,2);
    absf_phi = sum(abs_F,1);
    abs_F_max = max(max(abs_F));
    abs_F = 10*log10(abs_F/abs_F_max);
    absf_theta_max = max(absf_theta);
    absf_theta = 10*log10(absf_theta/absf_theta_max);
    absf_phi_max = max(absf_phi);
    absf_phi = 10*log10(absf_phi/absf_phi_max);

    figure('Name','����ͼ','NumberTitle','off','Color','white','Position',[600 50 550 750]);
    subplot(311);
    f = meshc(theta.num,phi.num,abs_F);% mesh(X,Y,Z)X,Y�ֱ��ӦZ���С��У�mesh̫���ˣ�Ҫ��XY�û���
    if  g_echos.num ~=1
        title(['��ά����ͼ,��Ԫ��:' num2str(g_array.num) ',��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda,ָ��[theta,phi]=[' num2str(g_echos.theta.num(1)) ',' num2str(g_echos.phi.num(1)) ']' ]);
    else
        title(['��ά����ͼ,��Ԫ��:' num2str(g_array.num) ',��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda,ָ��[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']' ]);
    end
    set(f,'Linewidth',2);
    xlabel('��λ��phi/degree');
    ylabel('������theta/degree');
    zlabel('abs of F');
    subplot(312);
    plot(theta.num,absf_theta);
    title('������ �ķ���ͼ');
    xlabel('theta/degree');
    ylabel('abs of Ftheta');
    subplot(313);
    plot(phi.num,absf_phi);
    title('��λ�� �ķ���ͼ');
    xlabel('phi/degree/');
    ylabel('abs of Fphi');
    
    %��������
    abs_P = abs(P);
    absp_theta = sum(abs_P,2);%2�Ƕ�����ӣ��õ���������1���ǵõ�������
    absp_phi = sum(abs_P,1);
    abs_P_max = max(max(abs_P));
    abs_P = 10*log10(abs_P/abs_P_max);
    absp_theta_max = max(absp_theta);
    absp_theta = 10*log10(absp_theta/absp_theta_max);
    absp_phi_max = max(absp_phi);
    absp_phi = 10*log10(absp_phi/absp_phi_max);

    %�׷�����
    [temp_ptheta,theta_estimation] = max(absp_theta);
    [temp_pphi,phi_estimation] = max(absp_phi);
    theta_estimation = theta_estimation-91;
    phi_estimation = phi_estimation-91;
    disp(['���ƽǶ�Ϊ[',num2str(theta_estimation),',',num2str(phi_estimation),']']);
    
    figure('Name','������','NumberTitle','off','Color','white','Position',[600 50 550 750]);
    subplot(311);
    p = meshc(theta.num,phi.num,abs_P);
    if g_echos.num ~=1
        title(['��ά������,��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda, ʵ�ʷ���Ϊ[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']'] );
    else
        title(['��ά������,��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda, ʵ�ʷ���Ϊ[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']' ...
        '���Ʒ���Ϊ[' num2str(theta_estimation) ',' num2str(phi_estimation) ']']);
    end
    set(p,'Linewidth',2);
    xlabel('��λ��phi/degree');
    ylabel('������theta/degree');
    zlabel('abs of P');
    subplot(312);
    plot(theta.num,absp_theta);
    title('������ �Ĺ�����');
    xlabel('theta/degree');
    ylabel('abs of Ptheta');
    subplot(313);
    plot(phi.num,absp_phi);
    title('��λ�� �Ĺ�����');
    xlabel('phi/degree');
    ylabel('abs of Pphi');
    
    figure('Color','white');
    imagesc(phi.num,theta.num,abs_P,'CDataMapping','scaled');
    title('��ά�ӳ���ӷ�����ɨ�蹦����');
    xlabel('��λ��phi/degree');
    ylabel('������theta/degree');    
    colorbar;

end 

function mm=khatri_rao(A,B)
    mm=[];
    n=size(A,1);
    for im=1:n
         mm=[mm;B*diag(A(im,:))];
    end
end
