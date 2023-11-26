close all;
clear;
clc;

% Parameters
Fs = 16000; % Sampling rate (adjust as needed)
recordingDuration = 5; % Duration of the recording in seconds

% Create an audiorecorder object
recObj = audiorecorder(Fs, 16, 1);

% Record audio
disp('Start speaking.');
recordblocking(recObj, recordingDuration);
disp('End of Recording.');

% Get the audio data
audioData = getaudiodata(recObj);

% Denoise and normalise
maxlen = Fs * 5;
denoised = wdenoise(audioData, 10);
normalized = denoised / max(abs(denoised));
padded = padarray(normalized, maxlen - length(normalized), 'post');

% Extract MFCC features
features = get_audio_feature(padded, Fs);

% Transpose for TreeBag prediction
dataForPrediction = features';

% Load the saved TreeBag model
model = load('trained_model.mat').model;

% Make predictions using the loaded TreeBag model
[predictedLabel, confidence] = predict(model, dataForPrediction);

% Display the results
disp('Prediction Result:');
disp(['Model predicted Speaker: ', predictedLabel{1}]);
disp(['Model confidence: ', num2str(max(confidence))]);

% Check if the prediction is a "stranger"
if max(confidence) < 0.8
    disp('Low confidence. This maybe a stranger.');
else
    figure;
    bar(confidence);
    title('Confidence of Speaker Prediction');
    xlabel('Class');
    ylabel('Confidence');
end