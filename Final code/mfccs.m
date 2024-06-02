function mf=mfccs(x)

fs=44100;
time_duration=7;
if( max(abs(x))<=1 )
    x = x * 2^15;
end

%% preemphsis
a=[1];
b=[1 -.97];
y=filter(b,a,x);

%% framing
frame_dur=.02; %in seconds
frame_length=frame_dur*fs; %in samples
frame_over=.01; %amount of overlap
frameover_length=frame_over*fs;
frames=[];
i=1;


while (((i-1)*frameover_length)+frame_length)<=time_duration*fs
    frame=y((i-1)*frameover_length + 1: ((i-1)*frameover_length)+frame_length,1)';
    frames=[frames;frame];
    i=i+1;
end
if (((i-1)*frameover_length)+frame_length)<time_duration*fs
    frame=y(time_duration*fs-frame_length+1:time_duration*fs,1)';
    frames=[frames;frame];   
end

%% windowing
num_frames=size(frames,1);
h=hamming(frame_length);

for i=1:num_frames
   fr=frames(i,:);
   window(i,:)=fr.*h';
end

%% fft
Nfft = 2^nextpow2( frame_length );
for i=1:num_frames
    ft(i,:)=abs(fft((window(i,:)),Nfft));
end

ft=ft';
M=20; % no of filter
noCoeff=13;
N=noCoeff+1;
K=(Nfft/2)+1; %size of each filter
R=[300 3700]; % filter frequencies in Hz
hz2mel = @( hz )( 1125*log(1+hz/700) );     % Hertz to mel warping function
mel2hz = @( mel )( 700*exp(mel/1125)-700 ); % mel to Hertz warping function

dctm = @( N, M )( sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
    .* repmat(pi*([1:M]-0.5)/M,N,1) ) ); % DCT 

%% Cepstral lifter routine
ceplifter = @( N, L )( 1+0.5*L*sin(pi*[0:N-1]/L) );

f_min = 0;          % filter coefficients start at this frequency (Hz)
f_low = R(1);       
f_high = R(2);      
f_max = 0.5*fs;     % filter coefficients end at this frequency (Hz)
f = linspace( f_min, f_max, K ); % frequency points (Hz), size 1xK

%% computing mel filters
c = mel2hz( hz2mel(f_low)+[0:M+1]*((hz2mel(f_high)-hz2mel(f_low))/(M+1)) ); %converting linear melsacle to
                                                                            %Hz
H = zeros( M, K );   %initializing the filter bank
for m = 1:M
    k = f>=c(m)&f<=c(m+1); % up-slope
    H(m,k) = (f(k)-c(m))/(c(m+1)-c(m));
    k = f>=c(m+1)&f<=c(m+2); % down-slope
    H(m,k) = (c(m+2)-f(k))/(c(m+2)-c(m+1));
end
FBE = H * ft(1:K,:); %applying the filters 

%% computing MFCC
DCT = dctm( N, M );
CC =  DCT * log( FBE );
L=22;

% Cepstral lifter computation
lifter = ceplifter( N, L );

% Cepstral liftering gives liftered cepstral coefficients
mf = diag( lifter ) * CC;
mf=mf';