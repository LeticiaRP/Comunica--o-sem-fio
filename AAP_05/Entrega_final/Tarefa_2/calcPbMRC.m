function Pb_mrc = calcPbMRC(M,SNRdB)
 SNR = 10.^(SNRdB/10); % SNR linear
 Pb_mrc = zeros(1,length(SNRdB));
% Pb MRC, Goldsmith Eq. (7.20)
 Gama = sqrt(SNR./(1+SNR));
 for m = 0:M-1
 Pb_mrc = Pb_mrc +...
 nchoosek(M-1+m,m)*((1+Gama)/2).^m;
 end
 Pb_mrc = ((1-Gama)/2).^M .*Pb_mrc;
end