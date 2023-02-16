powerVal = 81;
R = 1;
n_block = 1;
fs = 200000;
f_carr = 20000;
samples_per_bit=50; %round(fs/sys_bandwidth);

b_len=powerVal*samples_per_bit; % this value should be less than 65,000
tempTime = (0:b_len*n_block-1)/fs;

sig = -sin(2*pi*f_carr*tempTime);


sig_pos = sig - min(sig); %% all between 0 and 2
sig_norm = (sig_pos/(max(sig_pos))).*(2^12 - 1); %% all between 0 and 4095

sig_round = round(sig_norm);
sig_bin = dec2bin(sig_round,12);