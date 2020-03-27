    clc;
    clear all;
    clear global;
    close all;
    
    oned_testmode = 'music_and_espirit';
    
    switch oned_testmode
        case 'music_and_espirit'
            theta0 = [10 30 60]/180*pi;
            theta=linspace(-90,90,361);
            [abs_p,peak_ang,snr1,rmse1] = music(theta0,8,0.5,'not_multi');
            [snr2,rmse2] = espirit(theta0,8,0.5);
            figure('Color','white');
            plot(snr1,rmse1,'r*-',snr2,rmse2,'b*-');
            title('MUSIC�㷨��ESPRIT�㷨��ͬ������²�Ǿ������');
            xlabel('SNR');ylabel('RMSE');
            legend('MUSIC','ESPIRIT');
        case 'rootmusic_and_espirit'
            theta0 = [0 30 60]/180*pi;
            [snr1,rmse1] = root_music(theta0,8,0.5);  
            [snr2,rmse2] = espirit(theta0,8,0.5);
            figure('Color','white');
            plot(snr1,rmse1,'ro-',snr2,rmse2,'g*-');
            grid on;
            title('ROOT-MUSIC�㷨��ESPRIT�㷨��ͬ������²�Ǿ������');
            xlabel('SNR');ylabel('RMSE');
            legend('ROOT-MUSIC','ESPIRIT');
        case 'nor_and_ss_music'
            theta0 = [10 30 60]/180*pi;
            theta=linspace(-90,90,361);
            [abs_p1,peak_ang1] = music(theta0,8,0.5,'multi_path');
            abs_p2 = ss_music(theta0,8,0.5,'multi_path');
            figure('Color','white');
            h=plot(theta,abs_p1,'g',theta,abs_p2,'r');
            set(h,'Linewidth',2)
            xlabel('angle (degree)')
            ylabel('abs of P (dB)')
            axis([-90 90 -60 0]);
            set(gca, 'XTick',[-90:30:90]);
            grid on;
            legend('MUSIC','�ռ�ƽ��MUSIC');
            title({['MUSIC�㷨�Ϳռ�ƽ��MUSIC�㷨�ڶྶ�����µ����ܱȽ�']...
                    ['��������Ϊ:' num2str(theta0/pi*180) '��Դ��ͬ�ķ���Ϊ:' num2str(theta0(1:2)/pi*180)]});
        case 'espirit'
            theta0 = [45 30 60]/180*pi;
            [snr,rmse] = espirit(theta0,8,0.5);
            figure('Color','white');
            plot(snr,rmse,'ro-');
            title('ESPRIT�㷨��ͬ������²�Ǿ������');
            xlabel('SNR');ylabel('RMSE');
        case 'root_music'
            theta0 = [45 30 60]/180*pi;
            [snr,rmse] = root_music(theta0,8,0.5);  
            figure('Color','white');
            plot(snr,rmse,'ro-');
            title('ROOT-MUSIC�㷨��ͬ������²�Ǿ������');
            xlabel('SNR');ylabel('RMSE');
        case 'ss_music'
            theta=linspace(-90,90,361);
            theta0 = [0 30 60]/180*pi;
            abs_p = ss_music(theta0,8,0.5,'multi_path');
            figure('Color','white');
            h=plot(theta,abs_p);
            set(h,'Linewidth',2);
            xlabel('angle (degree)');
            ylabel('abs of P (dB)');
            axis([-90 90 -60 0]);
            set(gca, 'XTick',[-90:30:90], 'YTick',[-60:10:0]);
            grid on;
            title('ƽ��MUSIC������');
        case 'music'
            theta0 = [10 30 60]/180*pi;
            [abs_p,peak_ang,snr,rmse] = music(theta0,8,0.5,'not_multi');
            theta=linspace(-90,90,361);
            figure('Color','white');
            h=plot(theta,abs_p);
            hold on;
            plot(peak_ang,abs_p(peak_ang*2+181),'ro');
            set(h,'Linewidth',2);
            xlabel('angle (degree)');
            ylabel('abs of P (dB)');
            axis([-90 90 -60 0]);
            set(gca, 'XTick',[-90:30:90]);
            grid on;
            title( {['MUSIC������,��������Ϊ:' num2str(theta0/pi*180)]...
                ['�׷��������Ϊ:' num2str(peak_ang)]});
            figure('Color','white');
            plot(snr,rmse,'ro-');
            title('MUSIC�㷨��ͬ������²�Ǿ������');
            xlabel('SNR');ylabel('RMSE');
        case 'normal_theta_and_direction'
            %% ��ͨ�����γɵĲ�������淽��ı仯
            theta=linspace(-pi/2,pi/2,200);
            d_lamda = 1/2;
            theta0 = [0 30 60 80]/180*pi;
            [abs_f1,abs_p1] = normal(theta0(1),16,d_lamda);
            [abs_f2,abs_p2] = normal(theta0(2),16,d_lamda);
            [abs_f3,abs_p3] = normal(theta0(3),16,d_lamda);
            [abs_f4,abs_p4] = normal(theta0(4),16,d_lamda);

            figure('Color','white');
            subplot(411);
            plot(theta*180/pi,abs_f1,'r');grid on;
            title(['16��Ԫ������ͼ��ָ����Ϊ',num2str(theta0(1)/pi*180) '��']);
            xlabel('theta/radian');ylabel('abs of P');
            subplot(412);
            plot(theta*180/pi,abs_f2,'r');grid on;
            title(['16��Ԫ������ͼ��ָ����Ϊ',num2str(theta0(2)/pi*180) '��']);
            xlabel('theta/radian');ylabel('abs of P');
            subplot(413);
            plot(theta*180/pi,abs_f3,'r');grid on;
            title(['16��Ԫ������ͼ��ָ����Ϊ',num2str(theta0(3)/pi*180) '��']);
            xlabel('theta/radian');ylabel('abs of P');
            subplot(414);
            plot(theta*180/pi,abs_f4,'r');grid on;
            title(['16��Ԫ������ͼ��ָ����Ϊ',num2str(theta0(4)/pi*180) '��']);
            xlabel('theta/radian');ylabel('abs of P');
        case 'normal_resolution'
            %% ��ͨ�����γɵķֱ������� 
            theta=linspace(-pi/2,pi/2,200);
            d_lamda = 1/2;
            theta1 = [0 30 60]/180*pi;
            [abs_f1,abs_p1] = normal(theta1,8,d_lamda);
            theta2 = [0 10 60]/180*pi;
            [abs_f2,abs_p2] = normal(theta2,8,d_lamda);
            theta3 = [0 50 60]/180*pi;
            [abs_f3,abs_p3] = normal(theta3,8,d_lamda);
            figure('Color','white');
            subplot(311);
            plot(theta*180/pi,abs_p1,'r');grid on;
            title(['8��Ԫ�������ף���������Ϊ',num2str(theta1/pi*180) '��']);
            xlabel('theta/radian');ylabel('abs of P');
            subplot(312);
            plot(theta*180/pi,abs_p2,'r');grid on;
            title(['8��Ԫ�������ף���������Ϊ',num2str(theta2/pi*180) '��']);
            xlabel('theta/radian');ylabel('abs of P');
            subplot(313);
            plot(theta*180/pi,abs_p3,'r');grid on;
            title(['8��Ԫ�������ף���������Ϊ',num2str(theta3/pi*180) '��']);
            xlabel('theta/radian');ylabel('abs of P');

        case 'theta_and_array_numb'
            %% ������Ԫ��Ŀ�Բ�����ȵ�Ӱ��
            theta0 = 0/180*pi;
            d_lamda = 1/2;
            [abs_f1,abs_p1] = normal(theta0,8,d_lamda);
            [abs_f2,abs_p2] = normal(theta0,16,d_lamda);
            [abs_f3,abs_p3] = normal(theta0,32,d_lamda);
            theta=linspace(-pi/2,pi/2,200);
            figure('Color','white');
            subplot(211);
            plot(theta*180/pi,abs_f1,'g');hold on;
            plot(theta*180/pi,abs_f2,'r');hold on;
            plot(theta*180/pi,abs_f3,'b');hold on;
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '����������ͼ','ָ��' num2str(theta0*180/pi) '��' ]);
            legend('8��Ԫ','16��Ԫ','32��Ԫ');
            subplot(212);
            plot(theta*180/pi,abs_p1,'g');hold on;
            plot(theta*180/pi,abs_p2,'r');hold on;
            plot(theta*180/pi,abs_p3,'b');hold on;
            grid on;
            xlabel('theta/radian')
            ylabel('abs of P')
            title([ '������������','��������Ϊ' num2str(theta0*180/pi) '��']);
            legend('8��Ԫ','16��Ԫ','32��Ԫ');

        case 'theta_and_array_span'
            %% ������Ԫ���Բ�����ȵ�Ӱ��
            theta0 = 0/180*pi;
            d_lamda = 1/2;
            [abs_f1,abs_p1] = normal(theta0,8,d_lamda/2);
            [abs_f2,abs_p2] = normal(theta0,8,d_lamda);
            [abs_f3,abs_p3] = normal(theta0,8,d_lamda/2*3);
            [abs_f4,abs_p4] = normal(theta0,8,d_lamda*2*1.5);
            theta=linspace(-pi/2,pi/2,200);
            figure('Color','white');
            subplot(411);
            plot(theta*180/pi,abs_f1,'g');
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '��Ԫ���' num2str(d_lamda/2) 'lamda����������ͼ','ָ��' num2str(theta0*180/pi) '��' ]);
            subplot(412);
            plot(theta*180/pi,abs_f2,'r');
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '��Ԫ���' num2str(d_lamda) 'lamda����������ͼ','ָ��' num2str(theta0*180/pi) '��' ]);
            subplot(413);
            plot(theta*180/pi,abs_f3,'b');
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '��Ԫ���' num2str(d_lamda/2*3) 'lamda����������ͼ','ָ��' num2str(theta0*180/pi) '��' ]);
            subplot(414);
            plot(theta*180/pi,abs_f4,'k');
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '��Ԫ���' num2str(d_lamda*2*1.5) 'lamda����������ͼ','ָ��' num2str(theta0*180/pi) '��' ]);

        case 'normal_and_capon'
            %% �Ա�һά��ͨ�����γ���capon
            theta0 = [30,60]/180*pi;
            d_lamda = 1/2;
            [abs_f1,abs_p1] = normal(theta0,8,d_lamda);
            [abs_f2,abs_p2] = capon(theta0,16,d_lamda);
            theta=linspace(-pi/2,pi/2,200);
            figure('Color','white');
            subplot(211);
            plot(theta*180/pi,abs_p1,'r');hold on;
            grid on;
            xlabel('theta/degree');
            ylabel('abs of P');
            title([ '������������(��ͨ�����γ�)','��������Ϊ' num2str(theta0*180/pi) '��']);
            subplot(212);
            plot(theta*180/pi,abs_p2,'r');hold on;
            grid on;
            xlabel('theta/degree');
            ylabel('abs of P');
            title([ '������������(Capon)','��������Ϊ' num2str(theta0*180/pi) '��']);
            theta0 = [30,40]/180*pi;
            d_lamda = 1/2;
            [abs_f1,abs_p1] = normal(theta0,8,d_lamda);
            [abs_f2,abs_p2] = capon(theta0,16,d_lamda);
            theta=linspace(-pi/2,pi/2,200);
            figure('Color','white');
            subplot(211);
            plot(theta*180/pi,abs_p1,'r');hold on;
            grid on;
            xlabel('theta/degree')
            ylabel('abs of P')
            title([ '������������(��ͨ�����γ�)','��������Ϊ' num2str(theta0*180/pi) '��']);
            subplot(212);
            plot(theta*180/pi,abs_p2,'r');hold on;
            grid on;
            xlabel('theta/degree')
            ylabel('abs of P')
            title([ '������������(Capon)','��������Ϊ' num2str(theta0*180/pi) '��']);
        otherwise
            disp('Please input mode!');
    end