package org.gloplayer.data
{

	public class ComponentVO extends PluginInfoVO
	{

		// flex module swf file path		
		public var swfNativePath:String;
		
		// AIR module swf url - only set when used within AIR glomaker
		public var swfAIRUrl:String;

		// show in library?
		// created to allow components to be used as fixed stage navigation elements
		public var showInLibrary:Boolean = true;
		
		// allow user editing?
		// created to allow components to be used as fixed stage navigation elements
		public var isEditable:Boolean = true;
		
		
		/**
		 * Override for abstract clone() method.
		**/
		override public function clone():Object
		{
			var vo:ComponentVO = new ComponentVO();
			
			// PluginInfoVO properties
			vo.author = author;
			vo.description = description;
			vo.glomakerVersion = glomakerVersion;
			vo.id = id;
			vo.name = name;
			//vo.pluginPath = pluginPath;
			vo.iconPath = iconPath;
			vo.type = type;
			vo.version = version;
			
			// custom properties
			vo.swfNativePath = swfNativePath;
			vo.swfAIRUrl = swfAIRUrl;
			vo.showInLibrary = showInLibrary;
			vo.isEditable = isEditable;

			// done
			return vo;
		}		
	}
}