package org.gloplayer.model
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
		
		public var basePath:String = "project/";
		public var pluginsPath:String = basePath+"content/plugins/";
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