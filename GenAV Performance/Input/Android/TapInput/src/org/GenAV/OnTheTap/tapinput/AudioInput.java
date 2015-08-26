package org.GenAV.OnTheTap.tapinput;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.AsyncTask;
import android.util.Log;

public class AudioInput extends AsyncTask<Void, float[], Void> {
    private final static String TAG = "AudioInput";
    private boolean running;
    
    private int frequency = 44100;     
    private int channelConfiguration = AudioFormat.CHANNEL_IN_MONO;     
    private int audioEncoding = AudioFormat.ENCODING_PCM_16BIT;
    private int blockSize = 512;
    private float[] audio;
    private short[] buffer;
    
    private OnAudioProcessed callback;

    
    public AudioInput(){
        android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_URGENT_AUDIO);  
        setup();
    }
    private void setup() {
        audio = new float[blockSize];
        buffer = new short[blockSize];
    }

    @Override
    protected Void doInBackground(Void... params) {             
        try {
            int bufferSize = AudioRecord.getMinBufferSize(frequency,channelConfiguration, audioEncoding);  
            AudioRecord audioRecord = new AudioRecord(MediaRecorder.AudioSource.MIC, frequency,channelConfiguration, audioEncoding, bufferSize); 
            audioRecord.startRecording(); 
            while (running) {                   
                int bufferReadResult = audioRecord.read(buffer, 0, blockSize); 
                for (int i = 0; i < blockSize && i < bufferReadResult; i++) {                         
                    audio[i] = (float)(buffer[i] / 32768.0);// signed 16 bit
                }
                publishProgress(audio);
            }
            audioRecord.stop();
            audioRecord.release();//!must release otherwise reboot device to regain access 
        } catch (Throwable t) {                 
            Log.e("AudioProcessor", "Recording Failed");             
        }
        return null;
    }
   protected void onProgressUpdate(float[]... data) {
       if(callback != null) callback.onAudioData(audio);
   }

    public boolean isRunning() {
        return running;
    }
    
    public void setRunning(boolean running) {
        this.running = running;
        Log.d(TAG, "running: " + running);
    }
    public void plugOutputTo(OnAudioProcessed listener){
        callback = listener;
    }
   
}