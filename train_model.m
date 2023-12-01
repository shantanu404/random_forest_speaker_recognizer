close all;
clear;

%% Reading audio
base_path = "D:\Labs\EEE4702\database";
Fs = 16e3;

nowshin_files = get_files(fullfile(base_path, "Nowshin"));
anika_files = get_files(fullfile(base_path, "audio_anika"));

nowshin_audio = get_audio(nowshin_files, Fs);
anika_audio = get_audio(anika_files, Fs);

X = [nowshin_audio anika_audio];
Y = [zeros(1, 20) ones(1, 20)];

%% Train Test split
cv = cvpartition(size(X, 2), "HoldOut", 0.2);

Xtrain = X(:, ~cv.test);
Ytrain = Y(:, ~cv.test);
Xtest = X(:, cv.test);
Ytest = Y(:, cv.test);

%% Extract Audio Features
features = get_audio_feature(Xtrain, Fs);

%% Train Random forest
labels = unique(Ytrain);
model = TreeBagger(30, features', Ytrain', 'Method', 'classification');

%% Testing
good = 0;
bad = 0;
for idx = 1:size(Xtest, 2)
    testing_audio = Xtest(:, idx);
    ta_feature = get_audio_feature(testing_audio, Fs);
    og_label = Ytest(idx);
    [pd_label, confidence] = predict(model, ta_feature');
    pd_label = pd_label{1} - '0';
    fprintf("%d predicted to be %d with confidence (%.2f, %.2f)\n", ...
            og_label, pd_label, confidence(1), confidence(2));
        
    if og_label == pd_label
        good = good + 1;
    else
        bad = bad + 1;
    end
end

fprintf("Accuracy: %.2f %%\n", (good/(good + bad)) * 100);

%% Save the random forest model
% save('trained_model.mat', 'model');