close all; clear;clc;
Ts=1e-3;               % ��Ԫʱ϶Ts=1ms ,��Ӧ��������Ϊ1000bps
r=0.3;                 % ����ϵ��
t=(-10e-3):1e-4:10e-3; % ʱ���-10ms ��+10ms ��20 ��ʱ϶
[num,den] = rcosine(1e3,1e4,'fir/sqrt',r,10); % ƽ���������˲������
data=sign(rand(1,5000)-0.5);                  % ����5000 ���������,˫���Ե�.
datain=[data;zeros(9,length(data))];          % ��ÿ������ȡ��10����
% datain = repmat(data, 10, 1);
datain=reshape(datain,1,10*length(data)); % ��1���������, ����9��Ϊ0,��ʾ�弤

wavout=filter(num,den,datain); % �����˲�
n=10;fs=10000;fc=500;          % ��ͨ�ŵ�
[B,A] = butter(n,fc/(fs/2));   % ��ֹƵ��Ϊfc=500Hz��10�װ�����˼��ͨ�˲���
noise=0.00*randn(size(wavout));
wavout=wavout+noise;           % ��������
wavout1=filter(B,A,wavout);    % �����ŵ�1(500Hz��ͨ)
wavout2=0.2*[zeros(1,24),wavout(1:length(wavout)-24)]+...
        1*[zeros(1,34),wavout(1:length(wavout)-34)]+...
        0.4*[zeros(1,44),wavout(1:length(wavout)-44)];  % �����ŵ�2(�ྶ�ŵ�)
% wavout=[wavout1(1:20000),wavout2(20001:length(wavout))];% �ŵ��ڵ�2��ʱ���л�
wavout = wavout;
wavout=filter(num,den,wavout);     % ����ƥ���˲���
rec=wavout(225:10:length(wavout)); % �����ʱ��ÿ��10��ȡ��һ��,Լ�ӳ�201+24��ֵ
recpj=sign(rec);                   % �о�����о�����Ϊ0,���÷��ź�����������о�

eyediagram(wavout(10001:19000),20);  % ����ǰ����ͼ����2����ǰ��
eyediagram(wavout(46001:50000),20);  % ����ǰ����ͼ����2���Ժ�