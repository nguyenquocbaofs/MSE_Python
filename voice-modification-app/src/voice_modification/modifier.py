import soundfile as sf
import numpy as np
import os
import librosa
import matplotlib.pyplot as plt

plt.switch_backend('Agg')
IMAGE_DIR = 'images'

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

        # gender = self.detect_gender(audio, sr)
        # print("Gender: ", gender)

        # Remove all existing images in the directory
        os.makedirs(IMAGE_DIR, exist_ok=True)
        for file in os.listdir(IMAGE_DIR):
            file_path = os.path.join(IMAGE_DIR, file)
            if os.path.isfile(file_path):
                os.remove(file_path)

        # Draw the original audio waveform and spectrogram
        self.draw_waveform(audio, sr, title="Original Audio Waveform", filename="original_waveform.png")
        self.draw_spectrogram(audio, sr, title="Original Audio Spectrogram", filename="original_spectrogram.png")

        # Apply pitch shift
        if 'pitch_shift' in modification_parameters and modification_parameters['pitch_shift'] is not None:
            audio = librosa.effects.pitch_shift(audio, sr=sr, n_steps=modification_parameters['pitch_shift'])
            self.draw_waveform(audio, sr, title="Pitch Shifted Audio Waveform", filename="pitch_shifted_waveform.png")
            self.draw_spectrogram(audio, sr, title="Pitch Shifted Audio Spectrogram", filename="pitch_shifted_spectrogram.png")

        # Apply speed change
        if 'speed_change' in modification_parameters and modification_parameters['speed_change'] is not None:
            audio = librosa.effects.time_stretch(audio, rate=modification_parameters['speed_change'])
            self.draw_waveform(audio, sr, title="Speed Changed Audio Waveform", filename="speed_changed_waveform.png")
            self.draw_spectrogram(audio, sr, title="Speed Changed Audio Spectrogram", filename="speed_changed_spectrogram.png")

        # Apply volume gain
        if 'volume_gain' in modification_parameters and modification_parameters['volume_gain'] is not None:
            audio = audio * modification_parameters['volume_gain']
            self.draw_waveform(audio, sr, title="Volume Gained Audio Waveform", filename="volume_gained_waveform.png")
            self.draw_spectrogram(audio, sr, title="Volume Gained Audio Spectrogram", filename="volume_gained_spectrogram.png")

        # Save the modified audio
        sf.write(output_audio_path, audio, sr)

    def draw_waveform(self, audio, sr, title="Audio Waveform", filename="waveform.png"):
        filepath = os.path.join(IMAGE_DIR, filename)

        plt.figure(figsize=(10, 4))
        librosa.display.waveshow(audio, sr=sr)
        plt.title(title)
        plt.xlabel("Time (s)")
        plt.ylabel("Amplitude")
        plt.savefig(filepath)
        plt.close()
        

    def draw_spectrogram(self, audio, sr, title="Spectrogram", filename="spectrogram.png"):
        filepath = os.path.join(IMAGE_DIR, filename)

        plt.figure(figsize=(10, 4))
        S = librosa.feature.melspectrogram(y=audio, sr=sr, n_mels=128)
        S_dB = librosa.power_to_db(S, ref=np.max)
        librosa.display.specshow(S_dB, sr=sr, x_axis='time', y_axis='mel')
        plt.colorbar(format='%+2.0f dB')
        plt.title(title)
        plt.xlabel("Time (s)")
        plt.ylabel("Frequency (Hz)")
        plt.savefig(filepath)
        plt.close()
    
    def plot_spectrogram(self, y, sr, title="Spectrogram", filename="spectrogram.png"):
        filepath = os.path.join(IMAGE_DIR, filename)

        D = librosa.amplitude_to_db(np.abs(librosa.stft(y)), ref=np.max)
        plt.figure(figsize=(10, 4))
        librosa.display.specshow(D, sr=sr, x_axis="time", y_axis="log")
        plt.colorbar(format="%+2.0f dB")
        plt.title(title)
        plt.savefig(filepath)
        plt.close()