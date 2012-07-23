/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.model
{
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
		// Config values
		// ------------------------------------------------
		 
		public var playerModuleURL:String = "PlayerModule.swf";
		
		public var basePath:String = "";
		public var pluginsPath:String = basePath+"plugins/";
		public var projectPath:String = basePath+"project.glo";
		public var pluginSuffix:String = "_plugin.swf";
		public var stageSuffix:String = "_stage.swf";
		
		

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
		
		
		public function getPluginPath(id:String):String{
			return pluginsPath+id+pluginSuffix;
		}

		public function getStagePath(id:String):String{
			return pluginsPath+id+stageSuffix;
		}
		
	}
}