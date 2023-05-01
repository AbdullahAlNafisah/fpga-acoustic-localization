clc;

fs = 200000;
f_carr = 20000;
N = 16;
M = 1;
samples_per_bit = 256;
b_len = N*samples_per_bit; % block length
n_block = 1;
timeIndx = (0:2*b_len*n_block-1)/fs; %%change

%generate signals
[ZC, tx] = Mod_ZC(N, M, n_block, fs, f_carr, samples_per_bit);
%ZC = [ZC zeros(1,length(ZC))];
%tx = tx(1:b_len).*hamming(b_len,'periodic')';
% delay = 500;
% tx_delay = [zeros(1,delay) tx(1,1:end-delay)];
tx = [tx zeros(1,b_len)];
ZC = [ZC zeros(1,b_len)];

figure(1) 
% subplot(2,1,1)
plot(tx)
title("Noiseless Tx")
% delay = 50;
% tx_delay = [zeros(1,delay) tx(1,1:end-delay)];
% %tx_noise = awgn([zeros(1,delay) tx(1,1:end-delay)], 0, 'measured');
% subplot(2,1,2)
% plot(tx_delay)
% title("Noisy Tx")


%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Demodulation %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tx = cos(2*pi*5000*timeIndx);
tx_cos = tx.*cos(2*pi*f_carr*timeIndx);
tx_sin = tx.*-sin(2*pi*f_carr*timeIndx);

plot(tx_cos)
title("Real Part After Multiplication")

re_demod = 2*filter(Hd, tx_cos);
im_demod = 2*filter(Hd, tx_sin);




demod_sig = re_demod + 1i.*im_demod;
figure(2)
plot(real(demod_sig))
title("Real of Demodulated Signal")

figure(3)
plot(re_demod)
title("After filter")
hold on
plot(real(ZC))

%%

vec = [1];
test = filter(Hd, vec);

plot(test)
%% Cross Correlation

fft_ZC = fft(ZC);
fft_Rx = fft(demod_sig);
conjFFT = conj(fft_ZC);
g = fft_Rx.*conjFFT;
corr = ifft(g);

figure(3)
plot(real(fft_Rx))
title("Received Signal Frequency Response")

figure(4)
plot(real(g))
title("Real of complex multiplier")

figure(5)
plot(real(abs(corr)))
title("Real of Correlation Absolute Value")

% index of max peak
[~,idx1] = max(corr);
idx1 = idx1 - 15;


%% Rom Generation: conjFFT


seq_r = real(conjFFT);
seq_i = imag(conjFFT);
seq_r_pos = seq_r - min(seq_r);
seq_i_pos = seq_i - min(seq_i);
seq_r_norm = (seq_r_pos/(max(seq_r_pos))).*(2^31- 1); %% all between 
seq_i_norm = (seq_i_pos)/(max(seq_i_pos)).*(2^31 - 1); %% all between 
seq_r_round = floor(seq_r_norm);
seq_i_round = floor(seq_i_norm);
seq_r_bin = dec2bin(seq_r_round,31);
seq_i_bin = dec2bin(seq_i_round,31);
seq_fft = [seq_i_bin seq_r_bin];


%% Generate required ROMs

% Modulated ZC
tx_pos = tx - min(tx); %% all between 0 and 2
tx_norm = (tx_pos/(max(tx_pos))).*(2^12 - 1); %% all between 0 and 4095
tx_round = floor(tx_norm);
tx_bin = dec2bin(tx_round,12);

figure,
subplot(2,1,1)
plot(tx)
subplot(2,1,2)
plot(bin2dec(tx_bin))
%% 
%ZC = x;

% Unmodulated ZC
seq_r = real(ZC);
seq_i = imag(ZC);
seq_r_pos = seq_r - min(seq_r);
seq_i_pos = seq_i - min(seq_i);
seq_r_norm = (seq_r_pos/(max(seq_r_pos))).*(2^31- 1); %% all between 
seq_i_norm = (seq_i_pos).*(2^31 - 1); %% all between 
seq_r_round = floor(seq_r_norm);
seq_i_round = floor(seq_i_norm);
seq_r_bin = dec2bin(seq_r_round,31);
seq_i_bin = dec2bin(seq_i_round,31);
seq = [seq_i_bin seq_r_bin];
%plot(bin2dec(seq_r_bin))

%%


