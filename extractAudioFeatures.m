function feats = extractAudioFeatures(signal, Fs)
    % Time-domain features
    RMS_Val = rms(signal);
    Std_Val = std(signal);
    SNR_Val = snr(signal);
    zeroCrossCount = sum(abs(diff(sign(signal)))) / 2;
    zeroCrossRate = zeroCrossCount / length(signal);

    % SINAD (if available)
    try
        sinadVal = sinad(signal, Fs);
    catch
        sinadVal = NaN;
        warning('SINAD unavailable without DSP System Toolbox; set to NaN.');
    end

    shapeFactorVal = RMS_Val / (mean(abs(signal)) + eps);

    % Frequency-domain analysis (for spectral entropy)
    [pxx, f] = pwelch(signal, [], [], [], Fs);
    pxx = pxx + eps; 

    % Spectral Entropy
    spectralEntropyVal = spectralEntropy(pxx, f);


    % AR-based spectrum (for Wn, Zeta, BandPower)
    Ts = 1 / Fs;
    data = iddata(signal, [], Ts);
    arModel = ar(data, 4);
    [ps, W] = spectrum(arModel);
    ps = squeeze(ps);
    W = W / (2 * pi);  % Convert to Hz

    % Remove frequencies above Nyquist
    idx = W <= Fs / 2;
    W = W(idx);
    ps = ps(idx);

    % Find peaks in AR-based spectrum
    [~, peakFreqs] = findpeaks(ps, W, "SortStr", "descend", "NPeaks", 2);

    % Handle peak frequency outputs safely
    if isempty(peakFreqs)
        peakFreq1 = NaN;
        peakFreq2 = NaN;
    elseif isscalar(peakFreqs)
        peakFreq1 = peakFreqs(1);
        peakFreq2 = NaN;
    else
        peakFreq1 = peakFreqs(1);
        peakFreq2 = peakFreqs(2);
    end

    % Natural Frequency (Wn) = dominant peak
    Wn = peakFreq1;

    % Damping Ratio proxy (Zeta) = spectral flatness
    Zeta = geomean(ps) / mean(ps);

    % Band Power
    BandPower = trapz(W, ps);

    % Final feature table
    feats = table(RMS_Val, Std_Val, SNR_Val, zeroCrossRate, ...
                  sinadVal, shapeFactorVal, peakFreq1, peakFreq2, ...
                  Wn, Zeta, BandPower, spectralEntropyVal, ...
                  'VariableNames', {'RMS', 'Std', 'SNR', 'ZeroCrossRate', ...
                                    'SINAD', 'ShapeFactor', 'PeakFreq1', 'PeakFreq2', ...
                                    'Wn', 'Zeta', 'BandPower', 'SpectralEntropy'});
end
