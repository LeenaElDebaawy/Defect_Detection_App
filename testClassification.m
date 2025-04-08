% testClassification.m
% Tests the trained model on an unknown audio file.
% Run this script from the Scripts folder.

clear; clc;

% full path to find data folders
addpath('C:\Users\Admin\OneDrive - Anglia Ruskin University\Desktop\CMS_Tutorial\Group_2\Demo\Functions');
addpath('C:\Users\Admin\OneDrive - Anglia Ruskin University\Desktop\CMS_Tutorial\Group_2\Demo\Data\UnknownRecordings');

% Load the trained model
load('bestModel.mat', 'trainedModel');

% Get path to unknown files
folderPath = 'C:\Users\Admin\OneDrive - Anglia Ruskin University\Desktop\CMS_Tutorial\Group_2\Demo\Data\UnknownRecordings';

% Get all .wav files in that folder
files = dir(fullfile(folderPath, 'Unknown_*.wav'));

% Prepare table
fileNames = {};
predictedLabels = {};

% Create waitbar
h = waitbar(0, 'Classifying unknown files...');

% Loop through each file, check its existence,  and classify
for i = 1:length(files)
    audioPath = fullfile(files(i).folder, files(i).name);
     % Check if the file exists (just in case)
    if ~isfile(audioPath)
        fprintf('File not found: %s — Skipping\n', files(i).name);
        continue;
    end

    % classify and print result
    predLabel = classifyCompressorFault(audioPath, trainedModel);
    fprintf('File %s → Predicted fault: %s\n', files(i).name, string(predLabel));
     % Add to table data
    fileNames{end+1,1} = files(i).name;
    predictedLabels{end+1,1} = string(predLabel);

    % Update waitbar
    waitbar(i / length(files), h, sprintf('Classifying unknown files %d of %d...', i, length(files)));
end
  
    close(h);

   % Create table
resultsTable = table(fileNames, predictedLabels, ...
    'VariableNames', {'FileName', 'PredictedFault'});

% Display final table
disp(resultsTable);
