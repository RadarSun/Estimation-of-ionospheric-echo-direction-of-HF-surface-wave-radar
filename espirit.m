function [rmse]=espirit(theta0,element_num)
    %*******************************************************
    % ����ESPRIT�㷨
    %
    % Inputs
    %    d_lamda       sensor separation in wavelength
    %    Rxx(K,K)      array output covariance matrix
    %    echos_num     estimated number of sources ==L=iwave
    %   
    % Output
    %    estimate  estimated angles in degrees
    %              estimated powers
    %*******************************************************
    source_number=length(theta0);%��Ԫ��
    sub_sensor_number=element_num-1;%����Ԫ��
    theta0_sort = sort(theta0);
    snapshot_number=1024; 
    d_lamda = 0.5;
    A=exp(j*d_lamda*2*pi*(0:element_num-1).'*sin(theta0/180*pi));
    %������Դ����
    snr=10;
    s=sqrt(10.^(snr/10))*randn(source_number,snapshot_number);%�����ź�
    x=A*s+(1/sqrt(2))*(randn(element_num,snapshot_number)+1j*randn(element_num,snapshot_number));
    Rxx = x*x'/snapshot_number;
    [~,value]=eig(Rxx);
    value = diag(value);
    [value_sort,~] = sort(value,'descend');
    for i = 1:(size(value)-2)
        gama(i) = value_sort(i)/value_sort(i+1);
    end
    [~,esti_source_num] = max(gama);
    disp(['�����Ϊ10dB�¹�����Դ��Ŀ��' num2str(esti_source_num)]);

    snr0=-10:1:10;
    rmse = zeros(1,20);
    store_doa = zeros(20,source_number);
    for isnr=1:20
        s=sqrt(10.^(snr0(isnr)/10))*randn(source_number,snapshot_number);%�����ź�
        x=A*s+(1/sqrt(2))*(randn(element_num,snapshot_number)+1j*randn(element_num,snapshot_number));
        x1=x(1:sub_sensor_number,:);
        x2 = x(2:sub_sensor_number+1,:);

        %�����������ģ�ͽ��кϲ�
        X=[x1;x2];
        R=X*X'/snapshot_number;

        %��R��������ֵ�ֽ�
        [U,S,V]=svd(R);
        R=R-S(2*sub_sensor_number,2*sub_sensor_number)*eye(2*sub_sensor_number);
        [U,S,V]=svd(R);
        Us=U(:,1:source_number);
        Us1=Us(1:sub_sensor_number,:);
        Us2=Us((sub_sensor_number+1):2*sub_sensor_number,:);
        %�γɾ���Us12
        Us12=[Us1,Us2];
        %�ԡ�Us12'*Us12�����������ֽ⣬�õ�����E
        [F,Sa,Va]=svd(Us12'*Us12);
        %��E�ֽ�Ϊ�ĸ�С����
        %F11=F(1:source_number,1:source_number);
        F12=F(1:source_number,(1+source_number):(2*source_number));
        %F21=F((1+source_number):(2*source_number),1:source_number);
        F22=F((1+source_number):(2*source_number),(1+source_number):(2*source_number));
        %���չ�ʽ�õ���ת�������M
        E=-(F12*(inv(F22)));
        %�Եõ�����ת���������������ֽ�
        [V,d_lamda]=eig(E);
        d_lamda=(diag(d_lamda)).';
        doa=asin(angle(d_lamda)/pi)*180/pi;
        doa=sort(doa);
        rmse(isnr) = sqrt( sum(((theta0_sort-doa).^2))/source_number );
        i = 1:source_number;
        store_doa(isnr,i) = doa(i);
    end 
    figure('Color','white');
    plot(snr0(1:20),store_doa(1:20,1:source_number).','o-');
    grid on;
    xlabel('SNR/dB');
    ylabel('DOA ����/��');
    title('ESPRIT �㷨�ڲ�ͬ������µ�DOA����');
end
