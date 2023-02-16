function sig = cos_gen(tx,n_block, b_len, fs, f_carr)
tempTime = (0:b_len*n_block-1)/fs;
sig = tx.*cos(2*pi*f_carr*tempTime);