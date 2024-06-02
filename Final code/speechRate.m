function sr=speechRate(Sig, fs)

nSig = Sig / max(abs(Sig)); %normalization 
thr1=0.03;% set the threshold to decide the voice part 
thr2=0.3;% threshold to decide how many words 
word=1;%variable to calculate words     

v=find(abs(nSig)>thr1);%low threshold to find the voice part 
voicePart=length(v)/fs;   
w=find(abs(nSig)>thr2);%high threshold to find the words 

n=length(w); 
for i=1:n-1     
    if w(i+1)-w(i)>800%define the gap between words
    word=word+1;%count words          
    end
end
nw=word; 
sr=voicePart/nw;

