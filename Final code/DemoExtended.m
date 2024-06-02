clear;
close all;
clc

load('Data');

classifier = input('Which classification model do you want to you?\n1.Discriminant-analysis\n2.Support-Vector Machine\n3.Naive-Bayes\n');

if classifier == 1
    fprintf('Preparing discriminant-analysis Classifier.\n');
    classificationModel = fitcdiscr(TrainData, TrainClass);
    fprintf('discriminant-analysis Classifier Ready\n');
elseif classifier == 2
    fprintf('Preparing SVM Classifier.\n');
    classificationModel = fitcecoc(TrainData, TrainClass);
    fprintf('SVM Classifier Ready\n');
else 
    fprintf('Preparing naive-bayes Classifier.\n');
    classificationModel = fitcnb(TrainData, TrainClass);
    fprintf('naive-bayes Classifier Ready\n');
end

prediction = [];
for i = 1 : size(TestData, 1)
        label = predict(classificationModel, TestData(i, :));
        prediction = [prediction; label];
end

num_emotions = max(TestClass);
target_mat = zeros(num_emotions, length(TestClass));
pred_mat = zeros(num_emotions, length(prediction));
for i = 1:length(TestClass)
    target_mat(TestClass(i), i) = 1;
    pred_mat(prediction(i), i) = 1;
end

plotconfusion(target_mat, pred_mat);
[ C,CM ] = confusion( target_mat , pred_mat );
[ Precision , Recall , Specificity , F1score ]   = multiclass_metrics_common(CM)
