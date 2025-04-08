function [faultLabel, score] = classifyCompressorFault(audioFile, trainedModel)
    if ~isfile(audioFile)
        error('File does not exist: %s', audioFile);
    end

    % Read audio
    [signal, Fs] = audioread(audioFile);

    % Extract features from the function 
    feats = extractAudioFeatures(signal, Fs);

    try
        % Convert feature table to numeric array
        X = feats{:,:};

        % Use raw model inside trainedModel (if available)
        if isfield(trainedModel, 'ClassificationSVM')
            [faultLabel, score] = predict(trainedModel.ClassificationSVM, X);
        elseif isfield(trainedModel, 'ClassificationEnsemble')
            [faultLabel, score] = predict(trainedModel.ClassificationEnsemble, X);
        elseif isfield(trainedModel, 'ClassificationTree')
            [faultLabel, score] = predict(trainedModel.ClassificationTree, X);
        else
            % Fallback: use predictFcn if raw model not found
            faultLabel = trainedModel.predictFcn(feats);
            score = NaN;
            warning('Confidence score not available – fallback used.');
        end

    catch ME
        % Catch-all fallback (fixed: no format error)
        warning(['Prediction failed: ' ME.message]);
        faultLabel = trainedModel.predictFcn(feats);
        score = NaN;
    end
end

