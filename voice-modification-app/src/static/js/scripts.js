document.addEventListener('DOMContentLoaded', function() {
    const recordButton = document.getElementById('recordButton');
    const stopButton = document.getElementById('stopButton');
    const audioPlayer = document.getElementById('audioPlayer');
    const form = document.querySelector('form');
    let mediaRecorder;
    let audioChunks = [];

    recordButton.addEventListener('click', async () => {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        mediaRecorder = new MediaRecorder(stream, { mimeType: 'audio/webm' });

        mediaRecorder.ondataavailable = event => {
            audioChunks.push(event.data);
        };

        mediaRecorder.onstop = async () => {
            const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
            const audioUrl = URL.createObjectURL(audioBlob);
            audioPlayer.src = audioUrl;

            // Send audioBlob to the server for processing
            const formData = new FormData(form);
            formData.append('audio', audioBlob, 'recording.webm');

            try {
                const response = await fetch('/record', {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    const resultBlob = await response.blob();
                    const resultUrl = URL.createObjectURL(resultBlob);
                    audioPlayer.src = resultUrl; // Update player with the processed audio
                } else {
                    console.error('Error uploading audio:', response.statusText);
                }
            } catch (error) {
                console.error('Error uploading audio:', error);
            }
        };

        mediaRecorder.start();
        recordButton.disabled = true;
        stopButton.disabled = false;
    });

    stopButton.addEventListener('click', () => {
        mediaRecorder.stop();
        recordButton.disabled = false;
        audioChunks = [];
    });
});