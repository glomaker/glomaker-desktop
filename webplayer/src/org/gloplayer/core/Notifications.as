package org.gloplayer.core
{
	
	/**
	 * Stores GLO-Player PureMVC notification names. 
	 * @author Musbah
	 */	
	 
	public class Notifications
	{
		
		/**
		 * Application startup notification.
		 * Body: GloWebPlayer. 
		 */		
		public static const APP_START:String = "App.Start";
		
		/**
		 * App controls - player has loaded.
		 * Body: none
		 */		
		public static const PLAYER_LOADED:String = "Player.Loaded";
		
		/**
		 * Project data has been loaded.
		 * Body: none.
		 */		
		 
		public static const DATA_LOADED:String = "Data.Loaded";
		
		

	}
}