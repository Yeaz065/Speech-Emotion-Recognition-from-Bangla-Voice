function [target_mat, pred_mat] = DtwClassifier(k,data,labels,t_data,t_labels)

num_emotions = max(t_labels);

if nargin < 4
    error('Too few input arguments.')
elseif nargin < 5
    t_labels=[];
    acc=0;
end

if size(data,2)~=size(t_data,2)
    error('data should have the same dimensionality');
end

fprintf('Preparing DTW classifier..\n');

%initialization
predicted_labels=zeros(size(t_data,1),1);
dtwdistance=zeros(size(t_data,1),size(data,1)); %ed: (MxN) euclidean distances 
ind=zeros(size(t_data,1),size(data,1)); %corresponding indices (MxN)
k_dtw=zeros(size(t_data,1),k); %k-nearest neighbors for testing sample (Mxk)

fprintf('Evaluating Prediction on Test data...\n');
%calc dtw distances between each testing data point and the training data samples
for test_point=1:size(t_data,1)
    for train_point=1:size(data,1)
        %calc and store sorted dynamic distances with corresponding indices
        dtwdistance(test_point,train_point)= dynamicDist(test_point, train_point);
    end
    [dtwdistance(test_point,:),ind(test_point,:)]=sort(dtwdistance(test_point,:));
end

%find the nearest k for each data point of the testing data
k_dtw=ind(:,1:k);

%get the majority vote 
for i=1:size(k_dtw,1)
    options=unique(labels(k_dtw(i,:)'));
    max_count=0;
    max_label=0;
    for j=1:length(options)
        L=length(find(labels(k_dtw(i,:)')==options(j)));
        if L>max_count
            max_label=options(j);
            max_count=L;
        end
    end
    predicted_labels(i)=max_label;
end

target_mat = zeros(num_emotions, length(t_labels));
pred_mat = zeros(num_emotions, length(predicted_labels));
for i = 1:length(t_labels)
    target_mat(t_labels(i), i) = 1;
    pred_mat(predicted_labels(i), i) = 1;
end


end