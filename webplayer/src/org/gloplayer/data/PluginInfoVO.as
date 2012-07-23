package org.gloplayer.data
{
	
	/**
	 * Stores data about a particular plugin. 
	 * @author Nils
	 */	
	[Bindable]
	public class PluginInfoVO implements IValueObject, IClonable
	{
		
		public var id:String;
		public var type:uint; // see PluginType static identifiers
		public var author:String;
		public var version:String;
		public var glomakerVersion:String;
		public var name:String;
		public var description:String = "";
		
/* 		public var pluginDirectory:File;
		public var pluginIcon:File;
 */

		// -----------------------------------------
		// Accessors for dataProvider use
		// These avoid problem that File class not providing bindable properties
		// -----------------------------------------
		
		public function get iconPath():String
		{
			//return pluginIcon.nativePath;
			return "";
		}
		public function set iconPath(value:String):void
		{
			// not implemented - only present to avoid Binding warnings
		}
		
		/**
		 * Creates a copy of the value object.
		 * @abstract Implement in subclass. 
		 * @return 
		 */		
		public function clone():Object
		{
			throw new Error("Abstract method - must be implemented in subclass");
		}
	}
}