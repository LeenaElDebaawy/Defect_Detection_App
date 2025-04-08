# Defect_Detection_App
MATLAB-based AI fault detection app for washing machines
Defect Detection App

This MATLAB-based application provides an intuitive user interface for classifying faults in compressor systems using machine learning models. Users can load audio data, view waveform and spectral representations, and classify the signal using one of the pre-trained models.

Features

Load Audio: Import .wav files for analysis.

Visualization Options: Switch between waveform, power spectrum, and spectrogram visualizations.

Slider: Interactive zoom functionality on graphs.

Model Selection: Choose between Tree, SVM, and Ensemble models for classification.

Classification Output:

Real-time label display.

Confidence score saved to CSV.

Optional bar chart for confidence comparison.

Playback: Listen to the loaded audio.

Reset: Clears the interface and resets the app state.

Files Included

app.mlapp - The main MATLAB app.

TreeModel.mat, bestModel.mat, EnsembleModel.mat - Pre-trained machine learning models.

classifyCompressorFault.m - Unified classification function.

extractAudioFeatures.m - Audio feature extraction script.

testClassification.m - Optional test script.

preprocess_Reading4.wav - Sample audio.

MyAppInstaller_web.exe - Standalone desktop installer.

Installation & Usage

Option 1: MATLAB App

Open MATLAB.

Launch app.mlapp using App Designer.

Click "Run" to start the application.

Option 2: Standalone App (Windows only)

Run MyAppInstaller_web.exe.

Follow the installation instructions.

Launch the app from the desktop or Start Menu.

Author

Leena ElDebaawy

License

This project is intended for personal or academic showcase purposes only.

