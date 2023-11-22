close all;
clear;
clc;

%% Reading audio
base_path = "D:\Labs\EEE4702\database";
Fs = 16e3;

nowshin_files = get_files(fullfile(base_path, "Nowshin"));
anika_files = get_files(fullfile(base_path, "audio_anika"));

nowshin_audio = get_audio(nowshin_files, Fs);
anika_audio = get_audio(anika_files, Fs);

nowshin_mfcc = mfcc(nowshin_audio, Fs);
anika_mfcc = mfcc(anika_audio, Fs);

%% Taking two samples of each mfcc and plot them
rnd = randsample(1:20, 2);

% For nowshin
for i = 1:2
    subplot(4, 2, 2*(i-1) + 1);
    plot(nowshin_audio(:, rnd(i)));
    title(['Nowshin Sample #' num2str(rnd(i)) ' Audio']);
    
    subplot(4, 2, 2*(i-1) + 2);
    imagesc(nowshin_mfcc(:, :, rnd(i)))
    title(['Nowshin Sample #' num2str(rnd(i)) ' MFCC']);
end

% For anika
for i = 1:2
    subplot(4, 2, 2*(i-1) + 1 + 4);
    plot(anika_audio(:, rnd(i)));
    title(['Anika Sample #' num2str(rnd(i)) ' Audio']);
    
    subplot(4, 2, 2*(i-1) + 2 + 4);
    imagesc(anika_mfcc(:, :, rnd(i)))
    title(['Anika Sample #' num2str(rnd(i)) ' MFCC']);
end

%% Use Ensemble Classifier to classify who is the speaker
X = [reshape(nowshin_mfcc, 498 * 14, 20) ...
     reshape(anika_mfcc, 498 * 14, 20)];
Y = [zeros(1, 20) ones(1, 20)];

% Train Random Forest
model = TreeBagger(30, X', Y', 'Method', 'classification');

% Predict with the trained model
[~, scores] = predict(model, X');

% Display the scores
disp('Confidence Scores:');
disp(scores);

%% Save the KNN Model
save('trained_model.mat', 'model');