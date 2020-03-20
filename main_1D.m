    clc;
    clear all;
    clear global;
    close all;
    
    oned_testmode = 'theta_and_array_numb';
    
    switch oned_testmode
        case 'normal_theta_and_direction'
            %% 普通波束形成的波束宽度随方向的变化
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
            title(['16阵元线阵方向图，指向方向为',num2str(theta0(1)/pi*180) '度'])
            xlabel('theta/radian');ylabel('abs of P');
            subplot(412);
            plot(theta*180/pi,abs_f2,'r');grid on;
            title(['16阵元线阵方向图，指向方向为',num2str(theta0(2)/pi*180) '度'])
            xlabel('theta/radian');ylabel('abs of P');
            subplot(413);
            plot(theta*180/pi,abs_f3,'r');grid on;
            title(['16阵元线阵方向图，指向方向为',num2str(theta0(3)/pi*180) '度'])
            xlabel('theta/radian');ylabel('abs of P');
            subplot(414);
            plot(theta*180/pi,abs_f4,'r');grid on;
            title(['16阵元线阵方向图，指向方向为',num2str(theta0(4)/pi*180) '度'])
            xlabel('theta/radian');ylabel('abs of P');

        case 'normal_resolution'
            %% 普通波束形成的分辨力问题 
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
            title(['8阵元线阵功率谱，来波方向为',num2str(theta1/pi*180) '度'])
            xlabel('theta/radian');ylabel('abs of P');
            subplot(312);
            plot(theta*180/pi,abs_p2,'r');grid on;
            title(['8阵元线阵功率谱，来波方向为',num2str(theta2/pi*180) '度'])
            xlabel('theta/radian');ylabel('abs of P');
            subplot(313);
            plot(theta*180/pi,abs_p3,'r');grid on;
            title(['8阵元线阵功率谱，来波方向为',num2str(theta3/pi*180) '度'])
            xlabel('theta/radian');ylabel('abs of P');

        case 'theta_and_array_numb'
            %% 测试阵元数目对波束宽度的影响
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
            title([ '均匀线阵方向图','指向' num2str(theta0*180/pi) '度' ]);
            legend('8阵元','16阵元','32阵元');
            subplot(212);
            plot(theta*180/pi,abs_p1,'g');hold on;
            plot(theta*180/pi,abs_p2,'r');hold on;
            plot(theta*180/pi,abs_p3,'b');hold on;
            grid on;
            xlabel('theta/radian')
            ylabel('abs of P')
            title([ '均匀线阵功率谱','来波方向为' num2str(theta0*180/pi) '度']);
            legend('8阵元','16阵元','32阵元');

        case 'theta_and_array_span'
            %% 测试阵元间距对波束宽度的影响
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
            title([ '阵元间距' num2str(d_lamda/2) 'lamda均匀线阵方向图','指向' num2str(theta0*180/pi) '度' ]);
            subplot(412);
            plot(theta*180/pi,abs_f2,'r');
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '阵元间距' num2str(d_lamda) 'lamda均匀线阵方向图','指向' num2str(theta0*180/pi) '度' ]);
            subplot(413);
            plot(theta*180/pi,abs_f3,'b');
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '阵元间距' num2str(d_lamda/2*3) 'lamda均匀线阵方向图','指向' num2str(theta0*180/pi) '度' ]);
            subplot(414);
            plot(theta*180/pi,abs_f4,'k');
            grid on;
            xlabel('theta/radian')
            ylabel('abs of F')
            title([ '阵元间距' num2str(d_lamda*2*1.5) 'lamda均匀线阵方向图','指向' num2str(theta0*180/pi) '度' ]);

        case 'normal_and_capon'
            %% 对比一维普通波束形成与capon
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
            title([ '均匀线阵功率谱(普通波束形成)','来波方向为' num2str(theta0*180/pi) '度']);
            subplot(212);
            plot(theta*180/pi,abs_p2,'r');hold on;
            grid on;
            xlabel('theta/degree');
            ylabel('abs of P');
            title([ '均匀线阵功率谱(Capon)','来波方向为' num2str(theta0*180/pi) '度']);
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
            title([ '均匀线阵功率谱(普通波束形成)','来波方向为' num2str(theta0*180/pi) '度']);
            subplot(212);
            plot(theta*180/pi,abs_p2,'r');hold on;
            grid on;
            xlabel('theta/degree')
            ylabel('abs of P')
            title([ '均匀线阵功率谱(Capon)','来波方向为' num2str(theta0*180/pi) '度']);
        otherwise
            disp('Please input mode!');
    end