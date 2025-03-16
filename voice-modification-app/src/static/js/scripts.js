document.addEventListener('DOMContentLoaded', function() {
    const recordButton = document.getElementById('recordButton');
    const playButton = document.getElementById('playButton');
    const audioPlayer = document.getElementById('audioPlayer');
    let mediaRecorder;
    let audioChunks = [];

    recordButton.addEventListener('click', async () => {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        mediaRecorder = new MediaRecorder(stream);

        mediaRecorder.ondataavailable = event => {
            audioChunks.push(event.data);
        };

        mediaRecorder.onstop = async () => {
            const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
            const audioUrl = URL.createObjectURL(audioBlob);
            audioPlayer.src = audioUrl;

            // Send audioBlob to the server for processing
            const formData = new FormData();
            formData.append('audio', audioBlob, 'recording.wav');

            const response = await fetch('/process_audio', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                const resultUrl = await response.text();
                audioPlayer.src = resultUrl; // Update player with the processed audio
            }
        };

        mediaRecorder.start();
        recordButton.disabled = true;
        playButton.disabled = false;
    });

    playButton.addEventListener('click', () => {
        audioPlayer.play();
    });

    document.getElementById('stopButton').addEventListener('click', () => {
        mediaRecorder.stop();
        recordButton.disabled = false;
        playButton.disabled = true;
        audioChunks = [];
    });
});