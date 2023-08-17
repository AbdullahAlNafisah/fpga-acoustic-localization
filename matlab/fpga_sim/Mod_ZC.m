function [ZC_Seq, tx] = Mod_ZC(N, M, n_block, fs, f_carr, samples_per_bit)
    % N is the length of the ZC
    % M must be coprime with N %it's used as the root of ZC
    % n_block is number of blocks (signal snapshots?)
    % fs is sampling frequency
    % f_carr is carrier frequency
    % samples_per_bit is the upsampling factor

    b_len=N*samples_per_bit; % block length

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Zadoff-Chu Sequence Generation %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (mod(N,2) == 0)
        Zadoff_Chu = EvenZC(N, M);  % Zadoff-Chu Sequence of length N
    else
        Zadoff_Chu = zadoffChuSeq(M,N); % Zadoff-Chu Sequence of length N
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Up-Sampling %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r_zc = real(Zadoff_Chu);             % Real part of the sequecne
    i_zc = imag(Zadoff_Chu);             % Imaginary part of the sequence

%     if samples_per_bit > 1
%        r_zc=interp(r_zc,samples_per_bit)';
%        i_zc=interp(i_zc,samples_per_bit)';
%     end
    if samples_per_bit > 1
      r_zc=repmat(r_zc, samples_per_bit, 1);
      i_zc=repmat(i_zc, samples_per_bit, 1);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if samples_per_bit > 1
%         r_zc(end-samples_per_bit:end) = real(Zadoff_Chu(end));
%         i_zc(end-samples_per_bit:end) = imag(Zadoff_Chu(end));
%     end

    r_zc=r_zc(:)';
    i_zc=i_zc(:)';

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    tempTime = (0:b_len*n_block-1)/fs;

    sequence_r = repmat(r_zc,1,n_block);   % Sequence for the whole transmission
    sequence_i = repmat(i_zc,1,n_block);   % Sequence for the whole transmission

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Modulation %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    seq_cos = sequence_r.*cos(2*pi*f_carr*tempTime);  % Carrier 1
    seq_sin = sequence_i.*-sin(2*pi*f_carr*tempTime); % Carrier 2
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Modulated ZC Generation
    tx = (seq_cos+seq_sin);

    % ZC Generation Without Modulation
    ZC_Seq = (sequence_r + 1i.*sequence_i);

end