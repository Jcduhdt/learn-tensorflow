function [im, ber] = eyediagram_data_generator(SNR)
%EYEDIAGRAM_DATA_GENERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

close all;

snr = 10.^(SNR/10);
Ts=1e-3;               % 码元时隙Ts=1ms ,相应地码速率为1000bps
r=0.3;                 % 滚降系数
t=(-10e-3):1e-4:10e-3; % 时间从-10ms 到+10ms 共20 个时隙
symble_num = 50000;

% [num,den] = rcosine(1e3,1e4,'fir/sqrt',r,10); % 平方根滚降滤波器设计
h = rcosdesign(r,6,10);

data=sign(rand(1,symble_num)-0.5);                  % 输入5000 个随机数据,双极性的.
datain=[data;zeros(9,length(data))];          % 将每个数据取样10个点
datain=reshape(datain,1,10*length(data)); % 用1点代表数据, 其余9点为0,表示冲激

% wavout=filter(num,den,datain); % 发送滤波
wavout=upfirdn(datain, h, 1);

wave_power = norm(wavout).^2 / symble_num;
noise_pow = sqrt(wave_power / snr);
noise=noise_pow*randn(size(wavout));
wavout=wavout + noise;           % 加入噪声

% wavout=filter(num,den,wavout);     % 接收匹配滤波器
wavout=upfirdn(wavout, h, 1);

rec=wavout(1:10:length(wavout));
pt = (length(rec)-length(data)) / 2;
rec=rec(pt+1 : length(rec)-pt);
recpj=sign(rec);                   % 判决最佳判决门限为0,利用符号函数即完成了判决

% eyediagram(wavout(10001:19000),20);  % 均衡前的眼图（前2秒）
% eyediagram(wavout(46001:50000),20);  % 均衡前的眼图（后2秒)

p = eyediagram(wavout(10001:20000),20);
xlabel('')
ylabel('')
title('')
axis off

f = getframe(p);
im = f.cdata;
im = rgb2gray(im);
im = imresize(im, [360 460]);

% waveout = wavout(10001:40000);
% for i = 0 : (length(waveout) / 20 - 1)
%     ss(i+1, :) = waveout(1 + i*20 : 20 + i*20);
% end


recpj = (recpj + 1)/2;
data = (data + 1)/2;
[errorbit, ber] = biterr(data, recpj);

end

