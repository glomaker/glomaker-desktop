/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;


	/**
	 * Generic PureMVC proxy class to access a remote XML file.
	 * <p>The RemoteXMLProxy class provides a wrapper for an XML object and a URLLoader instance. It should be treated as an abstract class and subclassed, rather than used directly.</p>
	 * <p>In particular, a subclass should be created to implement data access / parsing methods and send notifications corresponding to the XML load/complete/error events.</p>
	 * <p>See in particular the <code>triggerLoadProgress(), triggerLoadComplete(), triggerError()</code> messages.</p>
	 *
	 * <p>Note that the RemoteXMLProxy doesn't use the built-in PureMVC 'data' property or the setData()/getData() methods - so you are free to implement that as you wish in specific subclasses.</p>
	 * 
	 * <p>This class does not send any notifications.</p>
	**/
	public class RemoteXMLProxy extends Proxy
	{

		// identifier
		public static const NAME:String = "RemoteXMLProxy";
		
		// URLLoader instance used to load in XML data
		protected var loader:URLLoader;
		
		// XML object
		private var rawXML:XML;
		
		// has the raw XML data loaded in?
		private var rawHasLoaded:Boolean;
		
		// has the raw XML data been parsed successfully?
		// (rawHasLoaded && !rawHasParsed) == parsing error
		private var rawHasParsed:Boolean;
		
		
		/**
		 * Creates a new RemoteXMLProxy instance.
		 * @param proxyName Name by which to identify this proxy.
		 * <p>Unless you can guarantee that only a single instance of this class will be used in your application, your subclass should provide an appropriate proxyName argument value.</p>
		 * @param data Standard PureMVC proxy data object. Can be left null if not used by your subclass.
		 */
		public function RemoteXMLProxy(proxyName:String = null, data:Object = null):void
		{
			super(proxyName == null ? NAME : proxyName, data);
			
			// init
			loader = new URLLoader();
			attachListeners();
		}
	
		/**
		 * The URL of the remote XML file.
		 * The data is automatically loaded in once the URL has been set.
		**/
		public function set url(value:String):void
		{
			// if the loader is currently loading, we interrupt the process
			try{
				loader.close();
			}catch(e:Error){
				// ignore
			}
			
			// cleanup
			clearData();
			
			// load in new file
			loader.load(new URLRequest(value));
		}
		
		/**
		 * Get the raw XML representation.
		**/
		public function get raw():XML
		{
			return rawXML;
		}
		
		/**
		 * Check whether the XML has loaded.
		**/
		public function get loaded():Boolean
		{
			return rawHasLoaded;
		}
		
		/**
		 * Check whether the raw data was successfully parsed into an XML object.
		**/
		public function get parsed():Boolean
		{
			return rawHasParsed;
		}
		
		/**
		 * Create a new loader instance and attach relevant event listeners to it.
		**/
		protected function attachListeners():void
		{
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
		
		/**
		 * Remove loader listeners.
		**/
		protected function removeListeners():void
		{
			loader.removeEventListener(Event.COMPLETE, handleLoadComplete);
			loader.removeEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
		
		/**
		 * Trigger method - override to provide your own event processing code
		 * The remote XML file has finished loading.
		**/
		protected function triggerLoadComplete():void
		{
			// abstract - implement in subclass
		}
		
		/**
		 * Trigger method - override to provide your own event processing code
		 * The remote XML file has finished loading.
		**/
		protected function triggerLoadProgress(bytesLoaded:uint, bytesTotal:uint):void
		{
			// abstract - implement in subclass
		}
		
		/**
		 * Trigger method - override to provide your own event processing code
		 * The remote XML file has finished loading.
		**/
		protected function triggerError(msg:String):void
		{
			// abstract - implement in subclass
		}

		/**
		 * Clear the loaded XML data and reset flags.
		 * Doesn't stop any ongoing load processes.
		**/
		protected function clearData():void
		{
			rawXML = null;
			rawHasLoaded = false;
			rawHasParsed = false;
		}
		
		/**
		 * URLLoader event - loading has finished.
		**/
		private function handleLoadComplete(evt:Event):void
		{
			// data loaded in
			rawHasLoaded = true;
			
			// the proxy's data property becomes the raw XML object
			try {
				
				// parse the data into an XML instance
				rawXML = new XML(loader.data);
				
			}catch (e:Error) {
				
				// XML couldn't be parsed
				rawHasParsed = false;
				triggerError("ERROR" + "\n\n" + this + "\n" + "handleLoadComplete" + "\n" + e.toString());
				return;
			}
			
			// success
			rawHasParsed = true;
			triggerLoadComplete();
		}
		
		private function handleLoadProgress(evt:ProgressEvent):void
		{
			triggerLoadProgress(evt.bytesLoaded, evt.bytesTotal);
		}
		
		private function handleIOError(evt:IOErrorEvent):void
		{
			triggerError(evt.text);
		}
			
	}
	
}