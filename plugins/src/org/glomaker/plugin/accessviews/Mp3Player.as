/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.accessviews
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class Mp3Player
	{
	
	    private var sound:Sound;
        
        private var chan:SoundChannel;
            
        private var pausePos:int = 0;
            
        private var playMode:Boolean = false;
        
        private var filename:String = null;
            
           
		public function Mp3Player(fn:String = null){
			filename = fn;			
		}
		
		public function loadSound(fn:String = null):void {
                
                if(chan != null) {
                    //make sure we stop the sound; otherwise, they'll overlap
                    chan.stop();
                }
                
               	filename = fn;
                
                if(fn){
                	//re-create sound object, flushing the buffer, and readd the event listener
                	sound = new Sound();
                
                	var req:URLRequest = new URLRequest(filename);
                	sound.load(req);
                	pausePos = 0;
                }
                
                playMode = false;
            }
            
            public function isPlaying():Boolean   {
            	return playMode;
            }
            
            public function stop():void   {
            	if(filename && playMode){
            		playMode = false;
            		chan.stop();
            		pausePos = 0;
            	}
            }
            
            public function playPause():void
            {
            	if(!filename) 
            	  return;
            	  
            	playMode = !playMode;
            	
                if(playMode){
                	chan = sound.play(pausePos);
                    
                } else {
                    pausePos = chan.position;
                    chan.stop();
                }
            }

	}
}