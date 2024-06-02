clear; close all; clc

Fs = 44100;
nBits = 16;
nChannels = 1;
recObj = audiorecorder(Fs, nBits, nChannels, 1);

filename = 'LiveAudio.wav';

disp('Start Speaking In...');
disp('5');
pause(1);disp('4');
pause(1);disp('3');
pause(1);disp('2');
pause(1);disp('1');
disp('NOW!!');
recordblocking(recObj,7);
disp('Recording Ended');

myRecording = getaudiodata(recObj);
audiowrite(filename, myRecording, Fs);

load('Data');
emotions = [string("Angry") string("Happy") string("Neutral") string("Sad")];

[speech, fs] = audioread(filename);
LiveFeatures = features(speech, fs);
predicted_label = KnnLive(1, TrainData, TrainClass, LiveFeatures);
 disp(predicted_label);
