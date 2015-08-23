/*
* Karplus Strong Processing implementation by
* Dan Ellis, dpwe@ee.columbia.edu, 2010-01-22
* part of the Music Signal Processing course at Columbia University
*/
class KSNote implements AudioSignal
{
     private float freq;
     private float level;
     private float alph;
     private float[] buffer;
     private int length;
     private int pointer;
     private float elapsed;
     private int average_halfwin = 2;  // half the window over which moving average is taken
     private float max_duration = 0.25;  // notes are cutoff after this many seconds
     private boolean isAlive;
     
     KSNote(float pitch, float amplitude)
     {
         freq = pitch;
         level = amplitude;

         // Create a new buffer of exactly one pitch period in length
         length = Math.round(out.sampleRate()/pitch);
         // .. and fill it with random noise
         buffer = new float[length];
         float sum = 0;
         for (int i=0; i<length; ++i) {
           buffer[i] = level*((float)Math.random()-0.5);
           sum += buffer[i];
         }
         // Remove DC to avoid click when note terminates
         sum = sum/length;
         for (int i=0; i<length; ++i) {
           buffer[i] -= sum;
         }

         // initialize where next sample comes from
         pointer = 0;

         // Start the elapsed duration clock
         elapsed = 0;

         out.addSignal(this);
         isAlive = true;
     }
     
     void generate(float [] samp)
     {
         // Run the Karplus-Strong plucked string algorithm
         for (int i = 0; i < samp.length; ++i) {
           float newval = 0;
           samp[i] = buffer[pointer];
           // Run the smoothing filter to replace the point we just read out
           for (int j = -average_halfwin; j <= average_halfwin; ++j) {
             newval = newval + buffer[(pointer+j+length) % length];  // make sure it wraps at the ends
           }
           newval = newval/(2*average_halfwin+1);  // K-point moving average
           buffer[pointer] = newval;
           // advance the pointer
           pointer = (pointer + 1)%length;
         }
         // check for end of note
         elapsed += samp.length/out.sampleRate();
         if (elapsed > max_duration) {  // hard time limit
            out.removeSignal(this);
            isAlive = false;
         }
     }
     
    // AudioSignal requires both mono and stereo generate functions
    void generate(float [] sampL, float [] sampR)
    {
        generate(sampL);
        // copy left to right
        System.arraycopy(sampL, 0, sampR, 0, sampR.length);
    }
}
