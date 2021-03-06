# Estimation-of-ionospheric-echo-direction-of-HF-surface-wave-radar
- Project name: Estimation of ionosphere echo direction of high frequency ground wave radar
- Engineering function: simulate various echo estimation algorithms, including optimal weight vector beamforming algorithm, weight adaptive adjustment algorithm and super resolution DOA algorithm;
The algorithm covers one dimension and two dimensions.
- This instruction was updated on June 17, 2020.
- For updates on uncovered matters, see: [ https://github.com/RadarSun ](https://github.com/RadarSun)
- With problem mail contact, welcome to submit issues to improve this code if any problems were found
- Programming Language: matlab



##  Procedure description:


###  1. Functions of each file in the code:


a) the main program is main.m: various simulations corresponding to two-dimensional arrays;  
b) the main program is main_1D.m: various simulations corresponding to one-dimensional arrays;  
c) beamforming.m: various beamforming angle measurement algorithms for two-dimensional arrays;  
d) doa.m: various super-resolution algorithms for two-dimensional arrays;  
e) gui.fig: Open the runnable GUI interface through matlab GUI tool, because global variables are used in it,  
Therefore, before running the GUI, you should run main.m to cache the global variables to the workspace;
f) normal.m/capon.m: one-dimensional beam scanning angle measurement algorithm;  
g) music.m/root_music.m/espirit.m/speechgate_esprit.m/ss_music.m/: one-dimensional super-resolution DOA estimation algorithm;  
h) lcmv.m/msnr.m: one-dimensional optimal weight vector beamforming algorithm;  
i) the one-dimensional adaptive weight adjustment algorithm;  
j) m file starting with test: Archive a small part of the old code. Do not use it;  
k) drawRect.m: The function of drawing a hollow box on an image;  
l) singlepulse.m: the attempt of single pulse angle measurement is immature, please do not use it;  
m) sidelencydata. mat: Doppler spectrum data of measured data.  
n) recognise_area.m: the function of recognizing a color block, whose function is similar to the location of the license plate during license plate recognition;  


###  2. Simple user guide:


a) the function of selecting and testing through testmode variables in the main.m file; The test of selecting beam scanning angle measurement through dbf_mode;  
b) the function of selecting and testing through the oned_testmode variable in the main_1D.m file;  


###  3. Precautions


a) the frequently used array parameter is global, which needs to be declared as global when used elsewhere  
b) most individual function files encapsulate the implementation and only need to use input and output variables.  
c) some functions do not set initial default variables. Input variables, variable functions, and formats are required. See the description at the beginning of the function. For specific examples, see the corresponding main program main.m or main_1D.m.


* 工程名称：高频地波雷达电离层回波方向估计
* 工程功能：仿真各种回波估计算法，包括最佳权矢量波束形成算法、权值自适应调整算法、超分辨率DOA算法；  
    算法覆盖一维和二维
* 本说明更新时间：2020.6.17
* 未尽事宜的更新见：https://github.com/RadarSun
* 有问题邮件联系，参考代码过程中发现问题，欢迎提交issues，共同把程序完善
* 编程语言：matlab

## 程序说明：
### 1.	代码各文件功能：  
a)	主程序为main.m：对应二维阵列的各种仿真；  
b)	主程序为main_1D.m：对应着一维阵列的各种仿真；  
c)	beamforming.m：二维阵列的各种波束形成测角算法；  
d)	doa.m：二维阵列的各种超分辨率算法；  
e)	gui.fig：通过matlab GUI工具打开可运行GUI界面，因为其中使用到了global变量，  
    故在运行GUI前应先运行一次main.m，使global变量缓存到工作区；  
f)	normal.m/capon.m：一维的波束扫描测角算法；  
g)	music.m/root_music.m/espirit.m/conjugate_esprit.m/ss_music.m/：一维的超分辨率DOA估计算法；  
h)	lcmv.m/msnr.m：一维最佳权矢量波束形成算法；  
i)	lms.m/nlms.m/rls.m：一维的自适应权值调整算法；  
j)	test开头的m文件：小部分旧版代码的存档，请勿使用；  
k)	drawRect.m：在图像上画空心方框的函数；  
l)	singlepulse.m：单脉冲测角的尝试，不成熟，请勿使用；  
m)	frequencyData.mat：实测数据的多普勒谱数据。  
n)	recognise_area.m：识别一个色块的函数，功能类似于车牌识别时车牌位置的定位；  
### 2.	简易使用指南：    
a)	main.m文件中通过testmode变量选择测试的功能；通过dbf_mode选择波束扫描测角的测试；  
b)	main_1D.m文件中通过oned_testmode变量选择测试的功能；  
### 3.	注意事项    
a)	经常使用的阵列参数是global型，在其他地方要使用时需要声明是global  
b)	绝大部分单独的函数文件都对实现进行了封装，仅需使用到输入输出变量  
c)	部分函数未设置初始默认变量，需要有输入变量，变量作用以及格式，查看函数开头的说明，具体使用例子查看对应的主程序main.m或者  main_1D.m
