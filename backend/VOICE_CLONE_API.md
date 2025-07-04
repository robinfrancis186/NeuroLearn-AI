# Voice Cloning API Endpoint

## Overview
The `/clone` endpoint allows you to clone a voice using OpenVoice technology. It takes reference audio and text input to generate speech in the style of the reference voice.

## Endpoint
```
POST /clone
```

## Request Body
```json
{
  "text": "Text to be converted to speech",
  "reference_audio": "base64_encoded_audio_data",
  "speed": 1.0,
  "language": "English",
  "output_filename": "optional_custom_filename"
}
```

### Parameters
- `text` (required): The text to be converted to speech with the cloned voice
- `reference_audio` (required): Base64 encoded reference audio file that contains the voice to be cloned
- `speed` (optional): Speech speed multiplier (default: 1.0)
- `language` (optional): Language for text-to-speech (default: "English")
- `output_filename` (optional): Custom filename for the output audio file

## Response
```json
{
  "success": true,
  "audio_base64": "base64_encoded_generated_audio",
  "output_path": "/path/to/saved/output.wav",
  "duration_seconds": 5.027,
  "message": "Voice cloning completed successfully"
}
```

### Response Fields
- `success`: Boolean indicating if the operation was successful
- `audio_base64`: Base64 encoded generated audio data
- `output_path`: Full path where the audio file was saved in the outputs directory
- `duration_seconds`: Duration of the generated audio in seconds
- `message`: Status message

## Usage Example

### Python
```python
import requests
import base64

# Read reference audio file
with open('reference_voice.wav', 'rb') as f:
    audio_data = f.read()

reference_audio_base64 = base64.b64encode(audio_data).decode('utf-8')

payload = {
    "text": "Hello, this is a test of voice cloning.",
    "reference_audio": reference_audio_base64,
    "speed": 1.0,
    "language": "English"
}

response = requests.post("http://localhost:8000/clone", json=payload)
result = response.json()

if result['success']:
    # Save the generated audio
    generated_audio = base64.b64decode(result['audio_base64'])
    with open('generated_speech.wav', 'wb') as f:
        f.write(generated_audio)
    print(f"Audio generated successfully: {result['output_path']}")
else:
    print(f"Error: {result['message']}")
```

### JavaScript/Node.js
```javascript
const fs = require('fs');

// Read reference audio file
const audioData = fs.readFileSync('reference_voice.wav');
const referenceAudioBase64 = audioData.toString('base64');

const payload = {
    text: "Hello, this is a test of voice cloning.",
    reference_audio: referenceAudioBase64,
    speed: 1.0,
    language: "English"
};

fetch('http://localhost:8000/clone', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload)
})
.then(response => response.json())
.then(result => {
    if (result.success) {
        // Save the generated audio
        const audioBuffer = Buffer.from(result.audio_base64, 'base64');
        fs.writeFileSync('generated_speech.wav', audioBuffer);
        console.log(`Audio generated successfully: ${result.output_path}`);
    } else {
        console.log(`Error: ${result.message}`);
    }
});
```

## Notes
- The reference audio should be in a common format (WAV, MP3, etc.)
- Generated audio files are saved in the `outputs` directory
- The endpoint returns both the file path and base64 encoded audio data
- Processing time depends on the length of the text and the complexity of the voice cloning
- For best results, use high-quality reference audio with clear speech
- The system supports English by default, but can be extended for other languages

## Error Handling
If the request fails, the response will have `success: false` and include an error message:

```json
{
  "success": false,
  "audio_base64": null,
  "output_path": null,
  "duration_seconds": null,
  "message": "Error description here"
}
```

Common errors:
- Invalid base64 audio data
- Unsupported audio format
- Text too long
- Server processing error
