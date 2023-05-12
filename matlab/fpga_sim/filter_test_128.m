clc;
close all;
% clear;

%% Generate Signals
% load fir_128.mat;
fs = 200000;
f_carr = 20000;
N = 16;
M = 1;
samples_per_bit = 128;
b_len = N*samples_per_bit; % block length
n_block = 1;
% timeIndx = (0:2*b_len*n_block-1)/fs; % 8192
timeIndx = (0:b_len*n_block-1)/fs; % 4096
[ZC, tx] = Mod_ZC(N, M, n_block, fs, f_carr, samples_per_bit);
tx = tx(1:b_len).*tukeywin(b_len,0.25)';

% Append same size by zeros
% tx = [tx zeros(1,b_len)];
% ZC = [ZC zeros(1,b_len)];


figure(1)
subplot(2,1,1)
title("Noiseless Tx")
plot(tx)
subplot(2,1,2)
title("ZC Signal")
plot(real(ZC))


%%
% figure(2)
% title("Sent Signal")
% snr = 1;

% Demodulation
tx_cos = tx_delay.*cos(2*pi*f_carr*timeIndx);
tx_sin = tx_delay.*-sin(2*pi*f_carr*timeIndx);

re_demod = 2*filter(fir_128, tx_cos);
im_demod = 2*filter(fir_128, tx_sin);
demod_sig = re_demod + 1i.*im_demod;
plot(real(demod_sig))
title("Demod Signal")


MaxIndxArray = zeros(1, b_len);
for i=1:1:b_len
    delay = i;

    % Appended case
%     tx_delay = [zeros(1,delay) tx(1,1:end-delay)];
    % Without appending case
    if delay > 1
        tx_delay = [tx(1,(b_len - delay + 1):end) tx(1,1:b_len-(delay))];
    else
        tx_delay = tx;
    end
    
%     tx_delay = awgn(tx_delay, snr, 'measured');
    
    % Demodulation
    tx_cos = tx_delay.*cos(2*pi*f_carr*timeIndx);
    tx_sin = tx_delay.*-sin(2*pi*f_carr*timeIndx);
    
    re_demod = 2*filter(fir_128, tx_cos);
    im_demod = 2*filter(fir_128, tx_sin);
    demod_sig = re_demod + 1i.*im_demod;

    % Cross Correlation
    fft_ZC = fft(ZC);
    fft_Rx = fft(demod_sig);
    conjFFT = conj(fft_ZC);
    g = fft_Rx.*conjFFT;
    corr = ifft(g);

%     plot(abs(real(corr)));
%     pause(0.01);
    
    % index of max peak
    [~,idx1] = max(corr);
    idx1 = (idx1 - 16);
    MaxIndxArray(1, i) = idx1;
end
%
figure(3);
x= 0:b_len-1;
plot(x,MaxIndxArray);
title("Delay Index Measurement")
xlabel('Exact Delay Index')
ylabel('Computed Delay Index')
