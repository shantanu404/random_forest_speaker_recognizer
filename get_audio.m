function audiodata = get_audio(filenames, Fs)
audiodata = [];
maxlen = Fs * 5;
for filename = filenames
    [singledata, fs] = audioread(filename);
    assert(fs == Fs);
    
    % filter using wavelet filter
    denoised = wdenoise(singledata, 10);
    normalized = denoised / max(abs(denoised));
    padded = padarray(normalized, maxlen - length(normalized), 'post');
    % append data
    audiodata = [audiodata padded];
end