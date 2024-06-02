function [f0,sampleStamp] = pitchs(x, fs,varargin)
params = audio.internal.pitchValidator(x,fs,varargin{:});

% Determine pitch
f0 = stepMethod(x,params);

% Create sample stamps corresponding to pitch decisions
hopLength   = params.WindowLength - params.OverlapLength;
numHops     = cast(floor((size(x,1)-params.WindowLength)/hopLength),'like',x);
sampleStamp = cast(((0:numHops)*hopLength + params.WindowLength)','like',x);

% Apply median filtering
if params.MedianFilterLength ~= 1
    f0 = movmedian(f0,params.MedianFilterLength,1);
end

% Trim off zero-padded last estimate
f0 = f0(1:(numHops+1),:);
end

function f0 = stepMethod(x,params)
oneCast = cast(1,'like',x);
r       = cast(size(x,1),'like',x);
c       = cast(size(x,2),'like',x);
hopLength = params.WindowLength - params.OverlapLength;

numHopsFinal = ceil((r-params.WindowLength)/hopLength) + oneCast;

% The SRH method uses a fixed-size intermediate window and hop
% length to determine the residual signal.
if strcmpi(params.Method,'SRH')
    N       = round(cast(0.025*params.SampleRate,'like',x));
    hopSize = round(cast(0.005*params.SampleRate,'like',x));
else
    N       = cast(params.WindowLength,'like',x);
    hopSize = cast(hopLength,'like',x);
end
numHops = ceil((r-N)/hopSize) + oneCast;

% Convert to matrix for faster processing
y = zeros(N,numHops*c,'like',x);
for channel = 1:c
    for hop = 1:numHops
        temp = x(1+hopSize*(hop-1):min(N+hopSize*(hop-1),r),channel);
        y(1:min(N,numel(temp)),hop+(channel-1)*numHops) = temp;
    end
end
% Run pitch detection algorithm
extraParams = struct('NumCandidates',1,'MinPeakDistance',1);
switch params.Method
    case 'SRH'
        f0 = cast(audio.internal.pitch.SRH(y,x,params,extraParams),'like',x);
    case 'PEF'
        f0 = audio.internal.pitch.PEF(y,params,extraParams);
    case 'CEP'
        f0 = audio.internal.pitch.CEP(y,params,extraParams);
    case 'LHS'
        f0 = audio.internal.pitch.LHS(y,params,extraParams);
    otherwise %'NCF'
        f0 = audio.internal.pitch.NCF(y,params,extraParams);
end

% Force pitch estimate inside band edges
bE = params.Range;
f0(f0<bE(1))   = bE(1);
f0(f0>bE(end)) = bE(end);

% Reshape to multichannel
f0 = reshape(f0,numHopsFinal,c);
end