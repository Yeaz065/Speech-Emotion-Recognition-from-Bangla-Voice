clear
close all
clc

load('Data');
% classifier = input('Which classification model do you want to use?\n1.K-Nearest Neighbour\n2.Dynamic Time Warping\n');
% if classifier == 1
    [target_mat, pred_mat] = KnnClassifier(1, TrainData, TrainClass, TestData, TestClass);
    plotconfusion(target_mat, pred_mat);
    [ C,CM ] = confusion( target_mat , pred_mat );
    [ Precision , Recall , Specificity , F1score ]   = multiclass_metrics_common(CM)
%     metrics.Precision 
%     metrics.Recall 
%     metrics.Accuracy 
%     metrics.Specificity 
%     metrics.F1score 
    
% else
%     [target_mat, pred_mat] = DtwClassifier(1, TrainData, TrainClass, TestData, TestClass);
%     plotconfusion(target_mat, pred_mat);
% end