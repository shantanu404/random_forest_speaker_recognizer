close all;
clear;
clc;

% Parameters
fs = 16000; % Sampling rate (adjust as needed)
recordingDuration = 5; % Duration of the recording in seconds

% Create an audiorecorder object
recObj = audiorecorder(fs, 16, 1);

% Record audio
disp('Start speaking.');
recordblocking(recObj, recordingDuration);
disp('End of Recording.');

% Get the audio data
audioData = getaudiodata(recObj);

% Denoise and normalise
maxlen = fs * 5;
denoised = wdenoise(audioData, 10);
normalized = denoised / max(abs(denoised));
padded = padarray(normalized, maxlen - length(normalized), 'post');

% Extract MFCC features
mfccData = mfcc(padded, fs);

% Reshape the data for KNN prediction
[numFrames, numCoefficients] = size(mfccData);
dataForPrediction = reshape(mfccData', [1, numCoefficients * numFrames]);

% Load the saved KNN model
model = load('trained_model.mat').model;

% Make predictions using the loaded KNN model
[predictedLabel, confidence] = predict(model, dataForPrediction);

% Display the results
disp('Prediction Result:');
disp(['Model predicted Speaker: ', predictedLabel{1}]);
disp(['Model confidence: ', num2str(max(confidence))]);

% Check if the prediction is a "stranger"
if max(confidence) < 0.9
    disp('Low confidence. This maybe a stranger.');
else
    figure;
    bar(confidence);
    title('Confidence of Speaker Prediction');
    xlabel('Class');
    ylabel('Confidence');
end