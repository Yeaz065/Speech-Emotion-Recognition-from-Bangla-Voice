clear;
close all;
clc


emotions = [string("Angry") string("Happy") string("Neutral") string("Sad")];
fs = 44100;

TrainClass = [];
for i = 1 : size(emotions, 2) 

    toLearn = emotions(i);

    learningDir = dir(['Train' '/', char(toLearn), '\*.wav']);
    nFiles = length(learningDir(not([learningDir.isdir])));
       
    for j = 1 : nFiles
        [speech, fs] = audioread(['Train' '/' char(toLearn) '/' char(lower(toLearn)) ' (' int2str(j) ')'  '.wav']);
        
        if j==1 && i == 1
            TrainData = features(speech, fs);
        else
            TrainData = [TrainData; features(speech, fs)];
        end
            
        TrainClass = [TrainClass; i];
           
    end
    
end

TestClass = [];
for i = 1 : size(emotions, 2)
    toLearn = emotions(i);

    learningDir = dir(['Test' '/', char(toLearn), '\*.wav']);
    nTestFiles = length(learningDir(not([learningDir.isdir])));
       
    for j = nFiles + 1 : nFiles + nTestFiles
        [speech, fs] = audioread(['Test' '/' char(toLearn) '/' char(lower(toLearn)) ' (' int2str(j) ')'  '.wav']);
        
        if j == nFiles + 1 && i == 1
            TestData = features(speech, fs);
        else
            TestData = [TestData; features(speech, fs)];
        end
            
        TestClass = [TestClass; i];
           
    end
    
end

save('Data', 'TrainData', 'TrainClass', 'TestData', 'TestClass');

