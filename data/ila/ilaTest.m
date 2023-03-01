clc;

ila = csvread("ila_zc_fifo.csv", 2, 3);
ila_new = [ila(1)];

for c = 1:length(ila)
    if ila(c,2) == 1
        ila_new(length(ila_new)+1) = ila(c);
    end
end

figure(1)
plot(ila_new)

f_carr = 20000;
powerVal = 81;
n_block=1;
fs=200000;
samples_per_bit=50; %round(fs/sys_bandwidth);
b_len=powerVal*samples_per_bit; % this value should be less than 65,000
tempTime = (0:33-1)/fs;%(0:b_len*n_block-1)/fs;
x = cos(2*pi*f_carr*tempTime);
re = ila_new.*cos(2*pi*f_carr*tempTime);
im = ila_new.*-sin(2*pi*f_carr*tempTime);

f1 = filter(Hd,re);
f2 = filter(Hd,im);
sig = f1;% + 1j.*f2;
figure(2)
plot(x)

figure(3)
plot(sig)