clearvars;
clc;

coefficients1 = polyfit([0, 4096/2], [0, 4096/2], 1);
a1 = coefficients1 (1);
b1 = coefficients1 (2);

coefficients2 = polyfit([4096/2, 4096], [4096/2, 0], 1);
a2 = coefficients2 (1);
b2 = coefficients2 (2);

x1 = 0:4096/2-1;
y1 = a1*x1 + b1;
x2 = 4096/2:4096-1;
y2 = a2*x2 + b2;

z = [y1, y2];
unmod = z;

fs = 200000;
f_carr = 20000;
N = 16;
M = 1;
samples_per_bit = 256;
b_len = N*samples_per_bit; % block length
n_block = 1;
tempTime = (0:b_len*n_block-1)/fs;

seq_cos = real(z).*cos(2*pi*f_carr*tempTime);  % Carrier 1
seq_sin = imag(z).*-sin(2*pi*f_carr*tempTime); % Carrier 2

z = seq_cos + seq_sin;

z_pos = z - min(z); %% all between 0 and 2
z_norm = (z_pos/(max(z_pos))).*(2^11 - 1); %% all between 0 and 4095
z_round = floor(z_norm);
z_bin = dec2bin(z_round,11);

figure(1)
plot(bin2dec(z_bin))


seq_r = real(unmod);
seq_i = imag(unmod);
seq_r_pos = seq_r - min(seq_r);
seq_i_pos = seq_i - min(seq_i);
seq_r_norm = (seq_r_pos/(max(seq_r_pos))).*(2^31 -1); %% all between 
seq_i_norm = (seq_i_pos/(max(seq_r_pos))).*(2^31 -1); %% all between 
seq_r_round = floor(seq_r_norm);
seq_i_round = floor(seq_i_norm);
seq_r_bin = dec2bin(seq_r_round,31);
seq_i_bin = dec2bin(seq_i_round,31);
seq = [seq_i_bin seq_r_bin];

figure(2)
plot(bin2dec(seq_r_bin))


%% 

%%%% Cos and Sin Generation %%%%%%

fs = 200000;
f_carr = 20000;
samples_per_bit = 256;
b_len = N*samples_per_bit; % block length
n_block = 1;
tempTime = (0:b_len*n_block-1)/fs;

cos_data = cos(2*pi*f_carr*tempTime);
sin_data = -sin(2*pi*f_carr*tempTime);

plot(cos_data)
