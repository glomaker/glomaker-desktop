/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;


	/**
	 * Stores application config settings, path names, etc.
	 * The built-in 'data' object is not used by this class.
	 * All properties stored are available as public properties. 
	 * @author Nils
	 */
	public class ConfigProxy extends Proxy
	{

		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "ConfigProxy";


		// ------------------------------------------------
		// APPLICATION SETTINGS
		// ------------------------------------------------
		 
		public var appVersion:String = "Version 2.0";
		public var licenseHTMLFile:String = "appdata" + File.separator + "license" + File.separator + "license.html";
		 
		// ------------------------------------------------
		// CONFIG VALUES
		// ------------------------------------------------

		 
		public var playerModuleURL:String = "PlayerModule.swf";

		public var defaultProjectFilename:String = "untitled";
		public var projectFileExtension:String = "glo";
		
		// A folder that holds the plugin of the GloMaker on the client's machine once the software is installed
		public var localFolder:String = "GloMaker";
		public var pluginsFolder:String = localFolder+"/plugins";
		
		// empty by default - will be picked up from the application's initial title bar value
		public var defaultAppTitle:String = "";
		
		// width for Alert buttons
		// the Alert component doesn't size its buttons automatically, so we specify a width here to work for all Alerts
		public var alertButtonWidth:Number = 80;
		
		/**
		 * Most recently used directory for the 'save as' command. 
		 */		
		public var lastSaveAsDirectoryURL:String;
		
		/**
		 * Most recently used directory for the 'open' command.  
		 */		
		public var lastOpenDirectoryURL:String;
		
		
		/**
		 * Most recently used directory for the 'export' command. 
		 */		
		public var lastExportDirectory:String;
		
		
		/**
		 * URL for the glomaker website. 
		 */		
		public var glomakerWebsiteURL:String = "http://www.glomaker.org";
		
		/**
		 * URL for the glomaker help website. 
		 */		
		public var helpSiteURL:String = "http://www.glomaker.org/guides.html";
		
		
		/**
		 * URL for the file that should be launched after application startup.
		 * Received via the AIR invoke event.
		 */		
		public var pendingStartupFileURL:String; 
		
		
		

		// ------------------------------------------------
		// Constructor
		// ------------------------------------------------

		/**
		 * Constructor 
		 * @param proxyName
		 * @param data
		 */
		public function ConfigProxy()
		{
			super(NAME);
		}
		
	}
}