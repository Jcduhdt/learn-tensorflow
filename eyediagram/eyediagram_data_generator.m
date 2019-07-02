function [im, ber] = eyediagram_data_generator(SNR)
%EYEDIAGRAM_DATA_GENERATOR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

close all;

snr = 10.^(SNR/10);
Ts=1e-3;               % ��Ԫʱ϶Ts=1ms ,��Ӧ��������Ϊ1000bps
r=0.3;                 % ����ϵ��
t=(-10e-3):1e-4:10e-3; % ʱ���-10ms ��+10ms ��20 ��ʱ϶
symble_num = 50000;

% [num,den] = rcosine(1e3,1e4,'fir/sqrt',r,10); % ƽ���������˲������
h = rcosdesign(r,6,10);

data=sign(rand(1,symble_num)-0.5);                  % ����5000 ���������,˫���Ե�.
datain=[data;zeros(9,length(data))];          % ��ÿ������ȡ��10����
datain=reshape(datain,1,10*length(data)); % ��1���������, ����9��Ϊ0,��ʾ�弤

% wavout=filter(num,den,datain); % �����˲�
wavout=upfirdn(datain, h, 1);

wave_power = norm(wavout).^2 / symble_num;
noise_pow = sqrt(wave_power / snr);
noise=noise_pow*randn(size(wavout));
wavout=wavout + noise;           % ��������

% wavout=filter(num,den,wavout);     % ����ƥ���˲���
wavout=upfirdn(wavout, h, 1);

rec=wavout(1:10:length(wavout));
pt = (length(rec)-length(data)) / 2;
rec=rec(pt+1 : length(rec)-pt);
recpj=sign(rec);                   % �о�����о�����Ϊ0,���÷��ź�����������о�

% eyediagram(wavout(10001:19000),20);  % ����ǰ����ͼ��ǰ2�룩
% eyediagram(wavout(46001:50000),20);  % ����ǰ����ͼ����2��)

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

