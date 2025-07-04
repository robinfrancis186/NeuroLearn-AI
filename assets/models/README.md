# TensorFlow Lite Emotion Detection Models

This directory contains TensorFlow Lite models for emotion detection.

## Model Requirements

The emotion detection system expects a TensorFlow Lite model with the following specifications:

- **Input**: 64x64x3 RGB image tensor
- **Output**: 6-class emotion probabilities [happy, sad, fear, surprised, anger, neutral]
- **Format**: `.tflite` file

## Adding Your Model

1. Place your trained emotion detection model as `emotion_model.tflite` in this directory
2. Ensure the model outputs 6 emotion classes in the correct order:
   - Index 0: happy
   - Index 1: sad  
   - Index 2: fear
   - Index 3: surprised
   - Index 4: anger
   - Index 5: neutral

## Training Your Own Model

You can train your own emotion detection model using:

- **FER-2013 Dataset**: Common facial emotion recognition dataset
- **TensorFlow/Keras**: Train a CNN model
- **TensorFlow Lite Converter**: Convert to .tflite format

Example training repositories:
- https://github.com/neta000/emotion_detection_model
- https://github.com/gauravsingh55/Emotion-Detection-model

## Current Implementation

The app currently runs in **simulation mode** when no model file is present, generating realistic emotion detection results for testing and development purposes.

To enable real emotion detection:
1. Add your `emotion_model.tflite` file to this directory
2. Restart the app
3. Grant camera permissions for real-time detection

## Model Performance

For best results, ensure your model:
- Achieves >70% accuracy on validation data
- Handles varying lighting conditions
- Works with front-facing camera input
- Processes 64x64 images efficiently 