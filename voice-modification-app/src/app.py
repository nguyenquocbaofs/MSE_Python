from flask import Flask, render_template, request, send_file
import os
from pydub import AudioSegment
from voice_modification.modifier import VoiceModifier
import shutil

app = Flask(__name__)
voice_modifier = VoiceModifier()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/record', methods=['POST'])
def record():
    print(request.files)
    audio_file = request.files['audio']
    if (audio_file.filename == ''):
        return "No selected file", 400

    input_audio_path = os.path.join('static', 'uploads', 'recording.webm')
    audio_file.save(input_audio_path)

    # Check if ffmpeg or avprobe is available
    if not shutil.which("ffmpeg") and not shutil.which("avprobe"):
        return "Error: ffmpeg or avprobe is not installed.", 500

    # Convert webm to wav
    webm_audio = AudioSegment.from_file(input_audio_path)
    wav_audio_path = os.path.join('static', 'uploads', 'recording.wav')
    webm_audio.export(wav_audio_path, format="wav")

    # Remove the webm file after conversion
    os.remove(input_audio_path)

    modification_parameters = {
        'pitch_shift': request.form.get('pitch_shift', type=float),
        'speed_change': request.form.get('speed_change', type=float),
        'volume_gain': request.form.get('volume_gain', type=float)
    }
    output_audio_path = os.path.join('static', 'modified', 'modified_recording.wav')
    voice_modifier.modify_voice(wav_audio_path, output_audio_path, modification_parameters)

    return send_file(output_audio_path, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True)