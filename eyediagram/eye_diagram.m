close all; clear;clc;
Ts=1e-3;               % 码元时隙Ts=1ms ,相应地码速率为1000bps
r=0.3;                 % 滚降系数
t=(-10e-3):1e-4:10e-3; % 时间从-10ms 到+10ms 共20 个时隙
[num,den] = rcosine(1e3,1e4,'fir/sqrt',r,10); % 平方根滚降滤波器设计
data=sign(rand(1,5000)-0.5);                  % 输入5000 个随机数据,双极性的.
datain=[data;zeros(9,length(data))];          % 将每个数据取样10个点
% datain = repmat(data, 10, 1);
datain=reshape(datain,1,10*length(data)); % 用1点代表数据, 其余9点为0,表示冲激

wavout=filter(num,den,datain); % 发送滤波
n=10;fs=10000;fc=500;          % 低通信道
[B,A] = butter(n,fc/(fs/2));   % 截止频率为fc=500Hz的10阶巴特沃思低通滤波器
noise=0.00*randn(size(wavout));
wavout=wavout+noise;           % 加入噪声
wavout1=filter(B,A,wavout);    % 传输信道1(500Hz低通)
wavout2=0.2*[zeros(1,24),wavout(1:length(wavout)-24)]+...
        1*[zeros(1,34),wavout(1:length(wavout)-34)]+...
        0.4*[zeros(1,44),wavout(1:length(wavout)-44)];  % 传输信道2(多径信道)
% wavout=[wavout1(1:20000),wavout2(20001:length(wavout))];% 信道在第2秒时刻切换
wavout = wavout;
wavout=filter(num,den,wavout);     % 接收匹配滤波器
rec=wavout(225:10:length(wavout)); % 在最佳时刻每隔10点取样一次,约延迟201+24样值
recpj=sign(rec);                   % 判决最佳判决门限为0,利用符号函数即完成了判决

eyediagram(wavout(10001:19000),20);  % 均衡前的眼图（第2秒以前）
eyediagram(wavout(46001:50000),20);  % 均衡前的眼图（第2秒以后）