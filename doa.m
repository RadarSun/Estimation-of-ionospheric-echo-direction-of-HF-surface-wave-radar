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