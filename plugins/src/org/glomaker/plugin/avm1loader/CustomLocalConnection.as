/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.avm1loader
{
	import flash.events.Event;
	import flash.net.LocalConnection;

	/**
	 * Extends LocalConnection so that call back functions can be added. 
	 * @author USER
	 * 
	 */
	public class CustomLocalConnection extends LocalConnection
	{
		private var _id:String;
		/**
		 * Custom event name. 
		 */
		public static const PING:String = "ping";
		
		/**
		 * Constructor. 
		 * @param connectionName
		 * 
		 */
		public function CustomLocalConnection(connectionName:String)
        {
            try
            {
                connect(connectionName);
            }
            catch (error:ArgumentError)
            {
                trace("Server already created/connected");
            }
        }
        
        /* public function setupComplete(id:int):void
        {
        	     	
        	dispatchEvent(new Event(Event.COMPLETE));
        	
        } */
        
        /**
         * Called by localConnection.swf, which handles AVM1 movies. 
         * 
         */
        public function loaded(id:String):void
        {
           _id = id;
            dispatchEvent(new Event(Event.INIT));
        }
        
        /**
         * Called by localConnection.swf, which handles AVM1 movies. 
         * 
         */
        public function ping():void
        {
            dispatchEvent(new Event(PING));
        }
        
        public function get id():String
        {
        	return _id;
        }
		
	}
}