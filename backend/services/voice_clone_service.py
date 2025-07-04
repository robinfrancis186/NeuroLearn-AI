import os
import torch
import base64
import tempfile
import soundfile as sf
import numpy as np
from typing import Optional, Tuple
import librosa

# Add the OpenVoice directory to the path
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'OpenVoice'))

from OpenVoice.openvoice.api import BaseSpeakerTTS, ToneColorConverter


class VoiceCloneService:
    def __init__(self):
        self.device = "cuda:0" if torch.cuda.is_available() else "cpu"
        self.base_path = os.path.join(os.path.dirname(__file__), '..', 'OpenVoice')
        self.output_dir = os.path.join(os.path.dirname(__file__), '..', 'outputs')
        
        # Ensure output directory exists
        os.makedirs(self.output_dir, exist_ok=True)
        
        # Initialize models
        self._initialize_models()
    
    def _initialize_models(self):
        """Initialize the OpenVoice models"""
        ckpt_base = os.path.join(self.base_path, 'checkpoints', 'base_speakers', 'EN')
        ckpt_converter = os.path.join(self.base_path, 'checkpoints', 'converter')
        
        # Initialize base speaker TTS
        self.base_speaker_tts = BaseSpeakerTTS(
            os.path.join(ckpt_base, 'config.json'), 
            device=self.device
        )
        self.base_speaker_tts.load_ckpt(os.path.join(ckpt_base, 'checkpoint.pth'))
        
        # Initialize tone color converter
        self.tone_color_converter = ToneColorConverter(
            os.path.join(ckpt_converter, 'config.json'), 
            device=self.device
        )
        self.tone_color_converter.load_ckpt(os.path.join(ckpt_converter, 'checkpoint.pth'))
    
    def decode_audio_from_base64(self, audio_base64: str) -> str:
        """Decode base64 audio and save to temporary file"""
        try:
            # Remove any data URL prefix if present
            if ',' in audio_base64:
                audio_base64 = audio_base64.split(',')[1]
            
            # Decode base64
            audio_data = base64.b64decode(audio_base64)
            
            # Create temporary file
            temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.wav')
            temp_file.write(audio_data)
            temp_file.close()
            
            return temp_file.name
        except Exception as e:
            raise ValueError(f"Failed to decode audio: {str(e)}")
    
    def encode_audio_to_base64(self, audio_path: str) -> str:
        """Encode audio file to base64"""
        try:
            with open(audio_path, 'rb') as audio_file:
                audio_data = audio_file.read()
                return base64.b64encode(audio_data).decode('utf-8')
        except Exception as e:
            raise ValueError(f"Failed to encode audio: {str(e)}")
    
    def get_audio_duration(self, audio_path: str) -> float:
        """Get audio duration in seconds"""
        try:
            audio, sr = librosa.load(audio_path)
            return len(audio) / sr
        except Exception as e:
            print(f"Warning: Could not get audio duration: {str(e)}")
            return 0.0
    
    def clone_voice(
        self, 
        text: str, 
        reference_audio_base64: str, 
        speed: float = 1.0,
        language: str = "English",
        output_filename: Optional[str] = None
    ) -> Tuple[str, str, float]:
        """
        Clone voice using OpenVoice
        
        Returns:
            Tuple of (output_path, audio_base64, duration)
        """
        temp_ref_audio = None
        temp_base_audio = None
        
        try:
            # Decode reference audio
            temp_ref_audio = self.decode_audio_from_base64(reference_audio_base64)
            
            # Generate base audio with default speaker
            if output_filename is None:
                import time
                timestamp = int(time.time())
                output_filename = f"cloned_voice_{timestamp}.wav"
            
            # Ensure output filename has .wav extension
            if not output_filename.endswith('.wav'):
                output_filename += '.wav'
            
            base_audio_path = os.path.join(self.output_dir, f"base_{output_filename}")
            final_output_path = os.path.join(self.output_dir, output_filename)
            
            # Step 1: Generate base audio using default speaker
            self.base_speaker_tts.tts(
                text=text,
                output_path=base_audio_path,
                speaker='default',
                language=language,
                speed=speed
            )
            
            # Step 2: Extract speaker embedding from reference audio
            reference_se = self.tone_color_converter.extract_se(
                ref_wav_list=[temp_ref_audio],
                se_save_path=None
            )
            
            # Step 3: Load default source speaker embedding
            ckpt_base = os.path.join(self.base_path, 'checkpoints', 'base_speakers', 'EN')
            source_se = torch.load(
                os.path.join(ckpt_base, 'en_default_se.pth'), 
                map_location=self.device
            )
            
            # Step 4: Convert tone color
            self.tone_color_converter.convert(
                audio_src_path=base_audio_path,
                src_se=source_se,
                tgt_se=reference_se,
                output_path=final_output_path,
                message="NeuroLearn AI Clone"
            )
            
            # Encode final audio to base64
            audio_base64 = self.encode_audio_to_base64(final_output_path)
            
            # Get audio duration
            duration = self.get_audio_duration(final_output_path)
            
            # Clean up base audio file
            if os.path.exists(base_audio_path):
                os.remove(base_audio_path)
            
            return final_output_path, audio_base64, duration
            
        except Exception as e:
            raise Exception(f"Voice cloning failed: {str(e)}")
        
        finally:
            # Clean up temporary files
            if temp_ref_audio and os.path.exists(temp_ref_audio):
                os.remove(temp_ref_audio)
