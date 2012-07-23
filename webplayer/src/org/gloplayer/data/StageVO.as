package org.gloplayer.data
{
	import flash.utils.Dictionary;
	
	public class StageVO extends PluginInfoVO
	{

		public var navComponent:ComponentInstanceVO;
		public var backgroundComponent:ComponentInstanceVO;

		/**
		 * Override for abstract clone() method.
		**/
		override public function clone():Object
		{
			var vo:StageVO = new StageVO();
			
			// PluginInfoVO properties
			vo.author = author;
			vo.description = description;
			vo.glomakerVersion = glomakerVersion;
			vo.id = id;
			vo.name = name;
			//vo.pluginDirectory = pluginDirectory;
			//vo.pluginIcon = pluginIcon;
			vo.type = type;
			vo.version = version;
			
			// components
			// we copy these by reference since their properties won't change or be saved
			vo.navComponent = navComponent;
			vo.backgroundComponent = backgroundComponent;
			
			// done
			return vo;
		}
		
	}
}