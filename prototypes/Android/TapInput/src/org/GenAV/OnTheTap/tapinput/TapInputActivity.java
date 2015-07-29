package org.GenAV.OnTheTap.tapinput;

import java.lang.reflect.Field;

import netP5.NetAddress;
import netP5.NetAddressList;
import oscP5.OscMessage;
import oscP5.OscP5;
import processing.core.PApplet;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;

public class TapInputActivity extends PApplet implements OnAudioProcessed {
	
	private String TAG="OnTheTap";
	
	private int bgCol = color(28, 28, 28);
	
	private AudioInput audioIn;
	
	private float smoothedVol   = 0.0f;
	private float scaledVol		= 0.0f;
	private float currVol 		= 0.0f;
	private float lastAmp 		= 0.0f;
	
	private float hw,hh,qw,qh;
	
	public static OscP5 osc;
	private final int PORT_IN = 12000;
	private final int PORT_OUT = 12001;
	private String TAP = "/input/tap";
	private String AMP = "/input/amplitude";
	private OscMessage tapMessage = new OscMessage(TAP);
	private OscMessage ampMessage = new OscMessage(AMP);
//	private NetAddress broadcast = new NetAddress("255.255.255.255", PORT_OUT);
	private NetAddressList broadcast = new NetAddressList();
//	private NetAddress broadcast = new NetAddress("10.0.1.62", PORT_OUT);


	public void setup(){
		frameRate(60);
		background(bgCol);
		noStroke();
		
		hw = width * .5f;
		hh = height* .5f;
		qw = width * .25f;
		qh = height* .25f;
	}
	
	public void draw(){
		background(bgCol);
		ellipse(hw,hh,width*smoothedVol,width*smoothedVol);
	}
	
	@Override
	public void onAudioData(float[] data) {
//		Log.d("AudioInput", "data:"+data[0]);
		
		//RMS a-la OF
		int bufferSize = data.length;
		for (int i = 0; i < bufferSize; i++){
			currVol += data[i] * data[i];
		}
		//mean 
		currVol /= (float)bufferSize;
		//sqrt 
		currVol = sqrt( currVol ) * 2;
		
		smoothedVol *= 0.93;
		smoothedVol += 0.07 * currVol;
		
		ampMessage.clear();
		ampMessage.setAddrPattern(AMP);
		ampMessage.add(0);
		ampMessage.add(constrain(smoothedVol,0.0f,1.0f));
		ampMessage.add(1);
		sendMessage(ampMessage);
		
//		Log.d("AudioInput", "smoothedVol:"+smoothedVol);
	}
	private void toggleAudio(boolean isOn){
        if(audioIn != null) killAudioInput();
        if(isOn){
            audioIn = new AudioInput();
            audioIn.setRunning(true);
            audioIn.execute();
            audioIn.plugOutputTo(this);
        }
    }
    private void killAudioInput(){
        audioIn.setRunning(false);
        audioIn.cancel(true);
        audioIn = null;
    }
    
    private void sendMessage(final OscMessage m){
    	new AsyncTask<Void, Void, String>(){
					//
//    				tap reactive audio visual system.
//    				The system plays with the tactile, analog feel of tapping surfaces as a digital input device.
//    				This input and it's gestures in turn drive sound and visuals expressively;
    		//
					@Override
					protected String doInBackground(Void... params) {
//						Log.d("OSC","sending message to"+broadcast);
						osc.send(m,broadcast);
						return "doing in background";
					}
					
					@Override
					protected void onPostExecute(String result) {
//						System.out.println("done in background");
					}
					
				}.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
    }
    private void setTapMessage(float x,float y,float amp){
    	tapMessage.clear();
	  	tapMessage.setAddrPattern(TAP);
	  	tapMessage.add(constrain(x,0.0f,1.0f));
	  	tapMessage.add(constrain(y,0.0f,1.0f));
	  	tapMessage.add(constrain(amp,0.0f,1.0f));
    }
    
    void sendMidiArg(OscMessage m,String prefix,String suffix,float arg,int state){
	  m.clear();
	  m.setAddrPattern(prefix+suffix);
	  m.add(0);
	  m.add(arg);
	  m.add(state);
	  sendMessage(m);
	}


	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//setContentView(R.layout.activity_main);
		toggleAudio(true);
		broadcast.add(new NetAddress("10.0.1.50", PORT_OUT));
		broadcast.add(new NetAddress("10.0.1.56", PORT_OUT));
		broadcast.add(new NetAddress("10.0.1.91", PORT_OUT));
		broadcast.add(new NetAddress("10.0.1.21", PORT_OUT));
		osc = new OscP5(this, PORT_IN);
	}
	
	public void mousePressed(){
		  lastAmp = smoothedVol;
		  sendTap();
	}
	public	void mouseDragged(){
		  sendTap();
		}
		
		void sendTap(){
		  sendMidiArg(tapMessage,TAP,"/x",constrain((float)mouseX/width,0.0f,1.0f),1);
		  sendMidiArg(tapMessage,TAP,"/y",constrain((float)mouseY/height,0.0f,1.0f),1);
		  sendMidiArg(tapMessage,TAP,"/velocity",lastAmp,1);
		  println(lastAmp);
		}
		public void mouseReleased(){
		  sendMidiArg(tapMessage,TAP,"/x",constrain((float)mouseX/width,0.0f,1.0f),0);
		  sendMidiArg(tapMessage,TAP,"/y",constrain((float)mouseY/height,0.0f,1.0f),0);
		  sendMidiArg(tapMessage,TAP,"/velocity",lastAmp,0);
		}
	
	/*
	@Override
	public boolean dispatchTouchEvent(MotionEvent event) {

		width = displayWidth;
		height = displayHeight;
		
		//get and normalise the touch coordinates
		float x = (event.getX())/width;
		float y = (event.getY())/height;
		
		int action = event.getActionMasked();
		
		switch(action){
		case MotionEvent.ACTION_DOWN:
			bgCol=color(x*255,y*255,Math.abs(x-y)*currVol);
			lastAmp = smoothedVol;
			
			
//			setTapMessage(x, y, lastAmp);
//			sendMessage(tapMessage);
			
//			sendMidiArg(tapMessage,TAP,"/x",constrain(x,0.0f,1.0f),1);
//			sendMidiArg(tapMessage,TAP,"/y",constrain(y,0.0f,1.0f),1);
//			sendMidiArg(tapMessage,TAP,"/velocity",lastAmp,1);
			
		case MotionEvent.ACTION_UP:
			bgCol=color(28,28,28);
			lastAmp = 0;
//			setTapMessage(x, y, lastAmp);
//			sendMessage(tapMessage);
			
			
//			sendMidiArg(tapMessage,TAP,"/x",constrain(x,0.0f,1.0f),0);
//			sendMidiArg(tapMessage,TAP,"/y",constrain(y,0.0f,1.0f),0);
//			sendMidiArg(tapMessage,TAP,"/velocity",lastAmp,0);
			break;
		
		case MotionEvent.ACTION_MOVE:
			bgCol=color(x*255,y*255,Math.abs(x-y)*currVol);
//			setTapMessage(x, y, lastAmp);
//			sendMessage(tapMessage);
			
//			sendMidiArg(tapMessage,TAP,"/x",constrain(x,0.0f,1.0f),1);
//			sendMidiArg(tapMessage,TAP,"/y",constrain(y,0.0f,1.0f),1);
//			sendMidiArg(tapMessage,TAP,"/velocity",lastAmp,1);
			break;
			
		}
		return super.dispatchTouchEvent(event);
	}
	*/
	@Override
	public void onDestroy() {
		toggleAudio(false);
		ampMessage.clear();
		ampMessage.setAddrPattern(AMP);
		ampMessage.add(0);
		ampMessage.add(constrain(smoothedVol,0.0f,1.0f));
		ampMessage.add(1);
		sendMessage(ampMessage);
		super.onDestroy();
	}
	
}
