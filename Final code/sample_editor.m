clear;
close all;
clc
cd = 'D:\';
mkdir(cd,'Group7')
cd = strcat(cd,'Group7\')

emotions = [string("angry") string("happy") string("neutral") string("sad")];
fs = 44100;

for i = 1 : size(emotions, 2)
    toLearn = emotions(i);

    learningDir = dir(['Train' '/', char(toLearn), '\*.wav']);
    nFiles = length(learningDir(not([learningDir.isdir])));
       
    for j = 1 : (nFiles)
        p=1;
        [speech, fs] = audioread(['Train' '/' char(toLearn) '/' char(lower(toLearn)) int2str(j) '.wav']);
        if ((length(speech)/fs)> 7) || (fs>44100)
            speech1 = speech(1:fs*7,1);
            cd1 = strcat(cd,emotions(i),num2str(j),'.wav');
            audiowrite(cd1,speech1,44100);
        elseif (length(speech)/fs)<7
%             speech1 = [speech(1:end), ones(1, fs*7-length(speech))]
            silence = zeros(fs*7-length(speech), 1);
            speech1 = [speech(:,1); silence];
            cd1 = strcat(cd,emotions(i),num2str(j),'.wav');
            audiowrite(cd1,speech1,44100);
            p=p+1;
        end
    end
    
end