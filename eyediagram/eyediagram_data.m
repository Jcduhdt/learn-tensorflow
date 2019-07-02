clear; close all; clc;

SNR = -10:0.1:10;
for sample_num = 1:1
    for i = 1:length(SNR)
        [im, ber] = eyediagram_data_generator(SNR(i));
        data(sample_num * i, :, :) = im;
        labels(sample_num * i) = ber;
%         saveas(gcf,['F:\dadaset\',num2str(ber),'.jpg']);
    end
end

h5create('eyediagram.h5', '/data', size(data))
h5write('eyediagram.h5', '/data', data);
h5create('eyediagram.h5', '/labels', size(labels))
h5write('eyediagram.h5', '/labels', labels);
