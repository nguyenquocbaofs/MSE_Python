import soundfile as sf
import numpy as np
import os
import librosa

class VoiceModifier:
    def __init__(self):
        pass

    def modify_voice(self, input_audio_path, output_audio_path, modification_parameters):
        print("Modifying voice with the following parameters:")
        print(modification_parameters)
        print("Input audio path:", input_audio_path)
        
        if not os.path.isfile(input_audio_path):
            print(f"Error: File '{input_audio_path}' does not exist.")
            return
        audio, sr = librosa.load(input_audio_path, sr=None)

       # Apply pitch shift
        if 'pitch_shift' in modification_parameters and modification_parameters['pitch_shift'] is not None:
            audio = librosa.effects.pitch_shift(audio, sr=sr, n_steps=modification_parameters['pitch_shift'])

        # Apply speed change
        if 'speed_change' in modification_parameters and modification_parameters['speed_change'] is not None:
            audio = librosa.effects.time_stretch(audio, rate=modification_parameters['speed_change'])

        # Apply volume gain
        if 'volume_gain' in modification_parameters and modification_parameters['volume_gain'] is not None:
            audio = audio * modification_parameters['volume_gain']

        # Save the modified audio
        sf.write(output_audio_path, audio, sr)