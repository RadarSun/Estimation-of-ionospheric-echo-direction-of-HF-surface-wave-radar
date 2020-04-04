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
        case 'conj_esprit2d'
            conj_esprit2d();
        case 'esprit2d'
            esprit2d();
        otherwise 
            error('Error! Invalid input! ');
    end
end

function conj_esprit2d()
%{
    Function description:
            2D-MUSIC DOA�㷨
    Syntax��
    Log description��
            2020.03.10 ���music2d���������ڷ������׷������
            2020.03.19 ����������׷�����⣬ԭ������Ȩ�����ٳ���lamda
%}
    global g_signal;
    global g_array;
    global g_echos;
    global g_para;

    sub_sensor_number = g_array.x_num;
    %������Ԫ���������ǻز����� MxK
    Ax = exp( -j*2*pi/g_signal.lamda*g_array.x_pos.'*(sin(g_echos.theta.rad).*cos(g_echos.phi.rad)));
    Ay = exp( -j*2*pi/g_signal.lamda*g_array.y_pos.'*(sin(g_echos.theta.rad).*sin(g_echos.phi.rad)));
    X = Ax*g_echos.signal;

    [theta0_sort,theta0_sort_i] = sort(g_echos.theta.num);
    phi0_sort = g_echos.phi.num(theta0_sort_i);

    snr0=0:4:80;
    rmse = zeros(1,20);    
    for isnr = 1:20
        for jj = 1:5
            X = awgn(X,snr0(isnr),'measured');
            Y = Ay*g_echos.signal;
            Y = awgn(Y,snr0(isnr),'measured');
            X1 = X(1:sub_sensor_number,:);
            X2 = [conj(X(2,:)); X(1:sub_sensor_number-1,:)];
            Y1 = Y(1:sub_sensor_number,:);
            Y2 = [conj(Y(2,:)); Y(1:sub_sensor_number-1,:)];

            C11 = X1*Y1'/g_echos.snapshot;
            C12 = X1*Y2'/g_echos.snapshot;
            C21 = X2*Y1'/g_echos.snapshot;
            C22 = X2*Y2'/g_echos.snapshot;
            C = [C11 C21 C12 C22].';
            Rc = C*C';

            [E,value] = eig(Rc);
            value = diag(value);value = value.';
            [~,valuesort] = sort(value,'descend');
            E = E(:,valuesort);
            E = E(:,1:g_echos.num);
            E1 = E(1:sub_sensor_number,:);
            E2 = E(sub_sensor_number+1:2*sub_sensor_number,:);
            E3 = E(2*sub_sensor_number+1:3*sub_sensor_number,:);
            E4 = E(3*sub_sensor_number+1:4*sub_sensor_number,:);

            Ux = pinv([E1;E3])*[E2;E4];
            Uy = pinv([E1;E2])*[E3;E4];

            [dlem1,u] = eig(Ux);
            u = diag(u);u = u.';
            [~,v] = eig(Uy);
            v = diag(v);v = v.';
            [~,I] = sort(angle(v),'descend');
            vtmp = (inv(dlem1))*Uy*dlem1;
            vtmp = diag(vtmp);vtmp = vtmp.';
            [~,II] = sort(angle(vtmp),'descend');
            u = u(II);
            v = v(I);

            u = angle(u)./(2*pi*g_array.span)*g_signal.lamda;
            v = angle(v)./(2*pi*g_array.span)*g_signal.lamda;
            doa_theta = asind( sqrt(u.^2+v.^2));
            [doa_theta,III] = sort(doa_theta);
            doa_phi = atand(v./u);
            doa_phi = doa_phi(III);
            doa_theta
            theta0_sort
            doa_phi
            phi0_sort
            rmse(jj,isnr) = sqrt( sum( ((theta0_sort-doa_theta).^2)+((phi0_sort-doa_phi).^2) )/g_echos.num );
        end
    end
    per_rmse = sum(rmse,1)/5;
    figure('Color','white');
    plot(snr0(1:20),per_rmse,'g*-');
    xlabel('SNR/dB');
    ylabel('RMSE/��');
    title('��ά����ESPRIT�㷨�����������SNR��С�ı仯');
end
    
function esprit2d()
%{
    Function description:
            2D-MUSIC DOA�㷨
    Syntax��
    Log description��
            2020.03.10 ���music2d���������ڷ������׷������
            2020.03.19 ����������׷�����⣬ԭ������Ȩ�����ٳ���lamda
%}
    global g_signal;
    global g_array;
    global g_echos;
    global g_para;

    sub_sensor_number = g_array.x_num-1;
    %������Ԫ���������ǻز����� MxK
    Ax = exp( j*2*pi/g_signal.lamda*g_array.x_pos.'*(sin(g_echos.theta.rad).*cos(g_echos.phi.rad)));
    Ay = exp( j*2*pi/g_signal.lamda*g_array.y_pos.'*(sin(g_echos.theta.rad).*sin(g_echos.phi.rad)));
    X = Ax*g_echos.signal;

    [theta0_sort,theta0_sort_i] = sort(g_echos.theta.num);
    phi0_sort = g_echos.phi.num(theta0_sort_i);

    snr0=0:4:80;
    rmse = zeros(1,20);    
    for isnr = 1:20
        for ii = 1:5
            X = awgn(X,snr0(isnr),'measured');
            Y = Ay*g_echos.signal;
            Y = awgn(Y,snr0(isnr),'measured');
            X1 = X(1:sub_sensor_number,:);
            X2 = X(2:sub_sensor_number+1,:);
            Y1 = Y(1:sub_sensor_number,:);
            Y2 = Y(2:sub_sensor_number+1,:);

            C11 = X1*Y1'/g_echos.snapshot;
            C12 = X1*Y2'/g_echos.snapshot;
            C21 = X2*Y1'/g_echos.snapshot;
            C22 = X2*Y2'/g_echos.snapshot; 
            C = [C11 C21 C12 C22].';
            Rc = C*C';

            [E,value] = eig(Rc);
            value = diag(value);value = value.';
            [~,valuesort] = sort(value,'descend');
            E = E(:,valuesort);
            E = E(:,1:g_echos.num);
            E1 = E(1:sub_sensor_number,:);
            E2 = E(sub_sensor_number+1:2*sub_sensor_number,:);
            E3 = E(2*sub_sensor_number+1:3*sub_sensor_number,:);
            E4 = E(3*sub_sensor_number+1:4*sub_sensor_number,:);

            Ux = pinv([E1;E3])*[E2;E4];
            Uy = pinv([E1;E2])*[E3;E4];

            [dlem1,u] = eig(Ux);
            u = diag(u);u = u.';
            [~,v] = eig(Uy);
            v = diag(v);v = v.';
            [~,I] = sort(angle(v),'descend');
            vtmp = (inv(dlem1))*Uy*dlem1;
            vtmp = diag(vtmp);vtmp = vtmp.';
            [~,II] = sort(angle(vtmp),'descend');
            u = u(II);
            v = conj(v(I));

            u = angle(u)./(2*pi*g_array.span)*g_signal.lamda;
            v = angle(v)./(2*pi*g_array.span)*g_signal.lamda;
            doa_theta = asind( sqrt(u.^2+v.^2));
            [doa_theta,III] = sort(doa_theta);
            doa_phi = atand(v./u);
            doa_phi = doa_phi(III);
            doa_theta
            theta0_sort
            doa_phi
            phi0_sort
            rmse(ii,isnr) = sqrt( sum( ((theta0_sort-doa_theta).^2)+((phi0_sort-doa_phi).^2) )/g_echos.num );
        end
    end
    per_rmse = sum(rmse,1)/5;
    figure('Color','white');
    plot(snr0(1:20),per_rmse,'g*-');
    xlabel('SNR/dB');
    ylabel('RMSE/��');
    title('��άESPRIT�㷨�����������SNR��С�ı仯');
end

% function conj_esprit2d()
% %{
%     Function description:
%             2D-MUSIC DOA�㷨
%     Syntax��
%     Log description��
%             2020.03.10 ���music2d���������ڷ������׷������
%             2020.03.19 ����������׷�����⣬ԭ������Ȩ�����ٳ���lamda
% %}
%     global g_signal;
%     global g_array;
%     global g_echos;
%     global g_para;
%     
%     sub_sensor_number = g_array.x_num-1;
%     %������Ԫ���������ǻز����� MxK
%     Ax = exp( -j*2*pi/g_signal.lamda*g_array.x_pos.'*(sin(g_echos.theta.rad).*cos(g_echos.phi.rad)));
%     Ay = exp( -j*2*pi/g_signal.lamda*g_array.y_pos.'*(sin(g_echos.theta.rad).*sin(g_echos.phi.rad)));
%     X = Ax*g_echos.signal;
%     X = awgn(X,g_echos.snr,'measured');
%     Y = Ay*g_echos.signal;
%     Y = awgn(Y,g_echos.snr,'measured');
%     X1 = X(1:sub_sensor_number,:);
%     X2 = X(2:sub_sensor_number+1,:);
%     Y1 = Y(1:sub_sensor_number,:);
%     Y2 = Y(2:sub_sensor_number+1,:);
%     Z = [X1;X2;Y1;Y2];
% 
%     Rzz = Z*Z'/g_echos.snapshot;
% 
%     %��R��������ֵ�ֽ�
%     [~,S,~]=svd(Rzz);
%     I = eye(sub_sensor_number);
%     L = diag([1 zeros(1,sub_sensor_number-1)]);
%     J = diag(ones(1,sub_sensor_number-1),-1);
%     O = zeros(sub_sensor_number,sub_sensor_number);
%     SS = [  I,J,L,O;...
%             J',I,O,O;...
%             L',O,I,J;...
%             O,O,J',I ];
%     Ct=Rzz-S(4*sub_sensor_number,4*sub_sensor_number)*SS;
%     [U,~,~]=svd(Ct);
%     Es=U(:,1:g_echos.num);
%     Es1=Es(1:sub_sensor_number,:);
%     Es2=Es(sub_sensor_number+1:2*sub_sensor_number,:);
%     Es3=Es(2*sub_sensor_number+1:3*sub_sensor_number,:);
%     Es4=Es(3*sub_sensor_number+1:4*sub_sensor_number,:);
%     
%     Ux = (inv(Es1'*Es1))*(Es1'*Es2);
%     Uy = (inv(Es3'*Es3))*(Es3'*Es4);
% 
%     [u1,s1,v1] = svd(Ux);
%     u = diag(s1);u = u.';
%     [u2,s2,v2] = svd(Uy);
%     v = diag(s2);v = v.';
%     tmps2 = diag(u1*Uy*v1);
%     [~,I] = sort(angle(tmps2),'descend');
%     v = v(I);
%     doa_phi = atan(angle(v)./angle(u))
%     doa_theta = asin(g_signal.lamda/(2*pi*g_array.span)*angle(v)./cos(doa_phi))
%     
% end

function music2d()
%{
    Function description:
            2D-MUSIC DOA�㷨
    Syntax��
    Log description��
            2020.03.10 ���music2d���������ڷ������׷������
            2020.03.19 ����������׷�����⣬ԭ������Ȩ�����ٳ���lamda
%}
    global g_signal;
    global g_array;
    global g_echos;
    global g_para;
    
    %������Ԫ���������ǻز����� MxK
    Ax = exp( -j*2*pi/g_signal.lamda*g_array.x_pos.'*(cos(g_echos.theta.rad).*cos(g_echos.phi.rad)));
    %k =g_array.x_pos.'/g_signal.lamda
    Ay = exp( -j*2*pi/g_signal.lamda*g_array.y_pos.'*(cos(g_echos.theta.rad).*sin(g_echos.phi.rad)));
    A = [Ax ; Ay];%������Ԫ����2MxK
    X = A*g_echos.signal;%2MxP
    X1 = awgn(X,g_echos.snr,'measured');
    %X1= X;%����������
    Rxx = X1*X1'/g_echos.snapshot;%2Mx2M
    
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
            ax = exp(-j*2*pi/g_signal.lamda*g_array.x_pos.'*cos(phim1)*cos(phim2));
            ay = exp(-j*2*pi/g_signal.lamda*g_array.y_pos.'*cos(phim1)*sin(phim2));
            a = [ax;ay];%2Mx1
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
    zlabel('abs of P');
    title({['��ά������(MUSIC),��Ԫ���:' num2str(g_array.span/g_signal.lamda) 'lamda,']...
        ['ʵ�ʷ���Ϊ[theta,phi]=[' num2str(g_echos.theta.num) ',' num2str(g_echos.phi.num) ']']} );
end