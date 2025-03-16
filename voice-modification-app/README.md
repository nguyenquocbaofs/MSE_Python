# Voice Modification App

This project is a Flask-based web application that allows users to record their voice and apply modifications to the audio using the `librossa` library. The application provides a user-friendly interface for recording audio and playing back the modified audio.

## Features

- Record voice directly from the web interface.
- Modify recorded audio using various parameters.
- Play back the modified audio.

## Project Structure

```
voice-modification-app
├── src
│   ├── voice_modification
│   │   ├── __init__.py
│   │   ├── modifier.py
│   ├── templates
│   │   └── index.html
│   ├── static
│   │   ├── css
│   │   │   └── styles.css
│   │   ├── js
│   │   │   └── scripts.js
│   └── app.py
├── requirements.txt
└── README.md
```

## Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   cd voice-modification-app
   ```

2. Install the required dependencies:
   ```
   pip install -r requirements.txt
   ```

## Usage

1. Run the Flask application:
   ```
   python src/app.py
   ```

2. Open your web browser and navigate to `http://127.0.0.1:5000`.

3. Use the interface to record your voice and apply modifications.

## Dependencies

- Flask
- librossa

## Contributing

Feel free to submit issues or pull requests for improvements or bug fixes.