function output = preprocess(audioData, Fs)
maxlen = Fs * 5;
normalized = audioData / max(abs(audioData));
padded = padarray(normalized, maxlen - length(normalized), 'post');
output = awgn(padded, 50);