"""
Test script for the voice cloning endpoint
"""
import requests
import base64
import json
import os

def test_clone_endpoint():
    # Use a real reference audio file from OpenVoice resources
    reference_audio_path = os.path.join(os.path.dirname(__file__), 'OpenVoice', 'resources', 'demo_speaker0.mp3')
    
    if not os.path.exists(reference_audio_path):
        print(f"❌ Reference audio file not found: {reference_audio_path}")
        return
    
    # Read and encode the reference audio
    with open(reference_audio_path, 'rb') as f:
        reference_audio_data = f.read()
    
    reference_audio_base64 = base64.b64encode(reference_audio_data).decode('utf-8')
    
    test_text = "Hello, this is a test of the voice cloning feature using OpenVoice technology."
    
    payload = {
        "text": test_text,
        "reference_audio": reference_audio_base64,
        "speed": 1.0,
        "language": "English",
        "output_filename": "test_clone"
    }
    
    try:
        print("🔄 Sending voice cloning request...")
        response = requests.post("http://localhost:8000/clone", json=payload)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            if result.get('success'):
                print("✅ Voice cloning endpoint is working!")
                print(f"Output saved to: {result.get('output_path')}")
                print(f"Duration: {result.get('duration_seconds')} seconds")
                print(f"Audio data length: {len(result.get('audio_base64', ''))} characters")
            else:
                print("❌ Voice cloning failed:")
                print(result.get('message'))
        else:
            print(f"❌ HTTP Error: {response.status_code}")
            print(f"Response: {response.text}")
            
    except requests.exceptions.ConnectionError:
        print("❌ Could not connect to server. Make sure it's running on http://localhost:8000")
    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    test_clone_endpoint()
