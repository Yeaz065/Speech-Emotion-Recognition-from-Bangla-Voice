function f=features(Sig, fs)

%Speech rate
sr=speechRate(Sig, fs);

%energy
nSig = Sig / max(abs(Sig)); 
eng = sum(nSig.^2);

%pitch
mfps=pitch(Sig, fs);
meanp=mean(mfps);
varp=var(mfps);
maxp=max(mfps);
minp=min(mfps);

%mfcc
 
cc=mfccs(Sig);

mediancc = median(cc, 2)';
mediancc=mediancc(1:13);
f=[sr eng meanp varp maxp minp mediancc];

end
