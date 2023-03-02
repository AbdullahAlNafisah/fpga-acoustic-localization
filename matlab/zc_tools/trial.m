%%%%%%%%% ZC Generation and Normalization %%%%%%%%%%%%%%%
[a, b, tx,seq_r, seq_i] = tx_gen_v2(4096, 1, 1, 200000, 20000);
tx_pos = tx - min(tx); %% all between 0 and 2
tx_norm = (tx_pos/(max(tx_pos))).*(2^12 - 1); %% all between 0 and 4095
%seq_r = seq_r - min(seq_r);
seq_r_pos = seq_r - min(seq_r);
seq_i_pos = seq_i - min(seq_i);

seq_r_norm = (seq_r_pos/(max(seq_r_pos))).*(2^32- 1); %% all between 
seq_i_norm = (seq_i_pos/(max(seq_i_pos))).*(2^32 - 1); %% all between 

tx_round = round(tx_norm);
seq_r_round = round(seq_r_norm);
seq_i_round = round(seq_i_norm);

tx_bin = dec2bin(tx_round,12);
seq_r_bin = dec2bin(seq_r_round,32);
seq_i_bin = dec2bin(seq_i_round,32);

seq = [seq_i_bin seq_r_bin];

%demodulation

f_carr = 20000;
fs = 200000;
powerVal = 64;
n_block = 1;
samples_per_bit=64; %round(fs/sys_bandwidth);
b_len=powerVal*samples_per_bit; % this value should be less than 65,000
tempTime = (0:b_len*n_block-1)/fs;


cos_x= cos(2*pi*f_carr*tempTime)';
sin_x = sin(2*pi*f_carr*tempTime)';
re_data = tx.*cos(2*pi*f_carr*tempTime)';  % Carrier 1
im_data = tx.*-sin(2*pi*f_carr*tempTime)'; % Carrier 2







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fs = 200000;
Nsamps = length(seq);
% y_fft = abs(fft(tx));            %Retain Magnitude
% y_fft = y_fft(1:Nsamps/2);      %Discard Half of Points
f = Fs*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot

y_fft = abs(fft(seq_r_norm));
%Plot Sound File in Frequency Domain
figure()
% plot(f, y_fft)
plot(y_fft)

xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Frequency Response')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx_dec = bin2dec(tx_bin);
tx_awgn = awgn(tx_dec,10,'measured');

f_carr = 20000;
fs = 200000;
powerVal = 64;
n_block = 1;
samples_per_bit=64; %round(fs/sys_bandwidth);
b_len=powerVal*samples_per_bit; % this value should be less than 65,000
tempTime = (0:b_len*n_block-1)/fs;
cos_x= cos(2*pi*f_carr*tempTime)';
sin_x = sin(2*pi*f_carr*tempTime)';
re_data = tx.*cos(2*pi*f_carr*tempTime)';  % Carrier 1
im_data = tx.*-sin(2*pi*f_carr*tempTime)'; % Carrier 2

%% 


%% 

%y = filter(Hd, re_d2);

%figure(2)
%plot(y)
%title("Cosine After Filter")

figure(3)
subplot(5,1,1)
plot(tx)
title("Modulated ZC (Decimal)")

subplot(5,1,2)
plot(cos_x)
title("Cosine")

subplot(5,1,3)
plot(sin_x)
title("Sine")

subplot(5,1,4)
plot(re_data)
title("Real Demodulated")

subplot(5,1,5)
plot(im_data)
title("Imaginary Demodulated")







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 200000;
Nsamps = length(tx);
y_fft = abs(fft(tx));            %Retain Magnitude
y_fft = y_fft(1:Nsamps/2);      %Discard Half of Points
f = Fs*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot


%Plot Sound File in Frequency Domain
figure(4)
plot(f, y_fft)
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Frequency Response')

ss = tx.*tx;
t1 = fft(ss);
t2 = abs(t1);
m = argmax(t2);


ss2 = abs(xcorr(tx,tx));
m2 = argmax(ss2);





function y = argmax(x)
  [~,y] = max(x);
end

% %%%%%%%%% Plot ZC before and after normalization %%%%%%%%
% figure(1)
% subplot(1,2,1)
% x = 0:1:length(tx)-1;
% plot(x, tx)
% ylim([-1 1])
% title('ZC Sequence')
% 
% subplot(1,2,2)
% plot(x, tx_norm)
% ylim([0 4095])
% title('ZC Sequence Normalized')

%%%%%%%%% Convert to binary %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

