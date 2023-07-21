clc;
close all;
clear;

%% Generate Signals
load Hd.mat;
fs = 200000;
f_carr = 20000;
N = 16;
M = 1;
samples_per_bit = 256;
b_len = N*samples_per_bit; % block length
n_block = 3;
% timeIndx = (0:2*b_len*n_block-1)/fs; % 8192
timeIndx = (0:b_len*n_block-1)/fs; % 4096
[ZC, tx] = Mod_ZC(N, M, n_block, fs, f_carr, samples_per_bit);
ZC = ZC(b_len+1:end-b_len);
%tx = tx.*tukeywin(n_block*b_len,0.25)';

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
snr = 1;
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
     
    re_demod = 2*filter(Hd, tx_cos);
    im_demod = 2*filter(Hd, tx_sin);
    re_demod = re_demod(b_len+1:end-b_len);
    im_demod = im_demod(b_len+1:end-b_len);
    demod_sig = re_demod + 1i.*im_demod;

    % Cross Correlation
    fft_ZC = fft(ZC);
    fft_Rx = fft(demod_sig);
    conjFFT = conj(fft_ZC);
    g = fft_Rx.*conjFFT;
    corr = ifft(g);
    
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

%% AcoTx ROM (all real)
figure(4)
subplot(2,1,1)
title("Modulated ZC")
tx_AcoTx = tx;
plot(tx_AcoTx)

tx_AcoTx = tx_AcoTx - min(tx_AcoTx);
tx_AcoTx = (tx_AcoTx/(max(tx_AcoTx))).*(2^12 - 1);
tx_AcoTx = floor(tx_AcoTx);
tx_AcoTx = dec2bin(tx_AcoTx,12);

subplot(2,1,2)
plot(bin2dec(tx_AcoTx))

%% AcoRx ROM fft(ZC) (real & imag)
figure(5)
subplot(2,1,1)
title("Demodulated ZC")
AcoRx_ZC = fft(ZC);
plot(real(AcoRx_ZC))
AcoRx_ZC = conj(AcoRx_ZC);

seq_r = real(AcoRx_ZC);
seq_i = imag(AcoRx_ZC);
seq_r_pos = seq_r - min(seq_r);
seq_i_pos = seq_i - min(seq_i);
seq_r_norm = (seq_r_pos/(max(seq_r_pos))).*(2^31- 1); %% all between 
seq_i_norm = (seq_i_pos)/(max(seq_i_pos)).*(2^31 - 1); %% all between 
seq_r_round = floor(seq_r_norm);
seq_i_round = floor(seq_i_norm);
seq_r_bin = dec2bin(seq_r_round,31);
seq_i_bin = dec2bin(seq_i_round,31);
seq_fft = [seq_i_bin seq_r_bin];

subplot(2,1,2)
plot(bin2dec(seq_r_bin))


%% AcoRx ROM modulated ZC (real & imag)
AcoRx_Mod_ZC = tx;
AcoRx_Mod_ZC = AcoRx_Mod_ZC - min(AcoRx_Mod_ZC); %% all between 0 and 2
AcoRx_Mod_ZC = (AcoRx_Mod_ZC/(max(AcoRx_Mod_ZC))).*(2^11 - 1); %% all between 0 and 4095
AcoRx_Mod_ZC = floor(AcoRx_Mod_ZC);
AcoRx_Mod_ZC = dec2bin(AcoRx_Mod_ZC,11);

figure(6)
subplot(2,1,1)
plot(tx)
subplot(2,1,2)
plot(bin2dec(AcoRx_Mod_ZC))
