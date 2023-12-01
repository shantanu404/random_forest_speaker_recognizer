function audiodata = get_audio(filenames, Fs)
audiodata = [];
maxlen = Fs * 5;
for filename = filenames
    [singledata, fs] = audioread(filename);
    assert(fs == Fs);
    
    % append data
    audiodata = [audiodata preprocess(singledata, Fs)];
end