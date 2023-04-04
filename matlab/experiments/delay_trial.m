clc;
close all;

%% Generate Signals
fs = 200000;
f_carr = 20000;
N = 16;
M = 1;
samples_per_bit = 256;
b_len = N*samples_per_bit; % block length
n_block = 1;
timeIndx = (0:2*b_len*n_block-1)/fs; % change
[ZC, tx] = Mod_ZC(N, M, n_block, fs, f_carr, samples_per_bit);
tx = tx(1:b_len).*hamming(b_len,'periodic')';
tx = [tx zeros(1,b_len)];
ZC = [ZC zeros(1,b_len)];


figure(1)
plot(tx)
title("Noiseless Tx")
MaxIndxArray = zeros(1, b_len);
%% ROM
% % Modulated ZC
% tx_pos = tx - min(tx); %% all between 0 and 2
% tx_norm = (tx_pos/(max(tx_pos))).*(2^12 - 1); %% all between 0 and 4095
% tx_round = floor(tx_norm);
% tx_bin = dec2bin(tx_round,12);
% 
% figure,
% subplot(2,1,1)
% plot(tx)
% subplot(2,1,2)
% plot(bin2dec(tx_bin))

%%
snr = 0;
for i=1:b_len
    delay = i;
    tx_delay = [zeros(1,delay) tx(1,1:end-delay)];
    tx_delay = awgn(tx_delay, snr, 'measured');
    
    %% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%% Demodulation %%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tx_cos = tx_delay.*cos(2*pi*f_carr*timeIndx);
    tx_sin = tx_delay.*-sin(2*pi*f_carr*timeIndx);
    
    re_demod = 2*filter(Hd, tx_cos);
    im_demod = 2*filter(Hd, tx_sin);
    demod_sig = re_demod + 1i.*im_demod;

    %% Cross Correlation
    
    fft_ZC = fft(ZC);
    fft_Rx = fft(demod_sig);
    conjFFT = conj(fft_ZC);
    g = fft_Rx.*conjFFT;
    corr = ifft(g);
    
    % index of max peak
    [~,idx1] = max(corr);
    idx1 = idx1 - 15;
    MaxIndxArray(1, i) = idx1;
end

figure(2);
plot(MaxIndxArray);


%% ROMs
