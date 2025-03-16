from flask import Flask, render_template, request, send_file
import os
from voice_modification.modifier import VoiceModifier

app = Flask(__name__)
voice_modifier = VoiceModifier()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/record', methods=['POST'])
def record():
    audio_file = request.files['audio']
    input_audio_path = os.path.join('static', 'uploads', audio_file.filename)
    audio_file.save(input_audio_path)

    modification_parameters = {
        # Add your modification parameters here
    }
    output_audio_path = os.path.join('static', 'modified', 'modified_' + audio_file.filename)
    voice_modifier.modify_voice(input_audio_path, output_audio_path, modification_parameters)

    return send_file(output_audio_path, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True)