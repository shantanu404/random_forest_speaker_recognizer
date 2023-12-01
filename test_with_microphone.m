close all;
clear;

%% Record audio
Fs = 16000;
recordingDuration = 5;

recObj = audiorecorder(Fs, 16, 1);

disp('Start speaking.');
recordblocking(recObj, recordingDuration);
disp('End of Recording.');

audioData = getaudiodata(recObj);

padded = preprocess(audioData, Fs);

features = get_audio_feature(padded, Fs);

dataForPrediction = features';

model = load('trained_model.mat').model;

[predictedLabel, confidence] = predict(model, dataForPrediction);

disp('Prediction Result:');
disp(['Model predicted Speaker: ', predictedLabel{1}]);
disp(['Model confidence: ', num2str(max(confidence))]);

%% Check if the prediction is a "stranger"
if max(confidence) < 0.7
    disp('Low confidence. This maybe a stranger.');
else
    figure;
    bar(confidence);
    title('Confidence of Speaker Prediction');
    xlabel('Class');
    ylabel('Confidence');
end