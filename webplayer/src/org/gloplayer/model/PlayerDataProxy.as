package org.gloplayer.model
{
	import flash.utils.Dictionary;
	
	import org.gloplayer.core.Notifications;
	import org.gloplayer.data.ComponentInstanceVO;
	import org.gloplayer.data.ComponentVO;
	import org.gloplayer.data.PageInstanceVO;
	import org.gloplayer.data.ProjectSettingsVO;
	import org.gloplayer.data.StageVO;
	

	public class PlayerDataProxy extends RemoteXMLProxy
	{
		public static const NAME:String = "PlayerDataProxy";
		
		// Instance for the stage plugin
		public var stageVO:StageVO;
		
		public function PlayerDataProxy()
		{
			super(NAME, new ProjectSettingsVO());
		}
		
		/**
		 * Typed reference to the data stored in the proxy. 
		 * @return
		 */		
		public function get settings():ProjectSettingsVO
		{
			return (getData() as ProjectSettingsVO);
		}
		
		override protected function triggerLoadComplete():void{
			applyData(raw);
			sendNotification(Notifications.DATA_LOADED);
		}
		
		
		protected function applyData(projectXML:XML):void
		{
			
			// overall settings
			settings.stageWidth = projectXML.props.w;
			settings.stageHeight = projectXML.props.h;
			settings.stageColour = projectXML.props.rgb;
						
			var list:XMLList = projectXML.nodes.page;
			var pageXML:XML;
			var pageInstance:PageInstanceVO;
			var patternNodes:Array = [];
			// Create pages
		 	for each(pageXML in list)
			{
				pageInstance = createPageInstance(pageXML);
				settings.pages.addItem(pageInstance);
			} 
			
			// Create the stage
			var stageID:String = projectXML.props.stageid;

			stageVO = new StageVO();
			stageVO.id= stageID;
			
			var compVO:ComponentVO = new ComponentVO();
			compVO.id = stageID+"_ComponentVO";
			compVO.swfNativePath = configProxy.getStagePath(stageID);
			
			var compInstVO:ComponentInstanceVO = new ComponentInstanceVO(compVO);
			
			stageVO.navComponent = compInstVO;
			
		}
		
	   /**
		 * Retrieve a reference of the ConfigProxy instance currently registered with the framework. 
		 * @return 
		 */
		protected function get configProxy():ConfigProxy
		{
			return facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
		}
		
		
		/**
		 * @param xmlData
		 * @return 
		 * @throws Error when failed to deserialise parts of the XML.
		 */		
		 
		 
	 	protected function createPageInstance(xmlData:XML):PageInstanceVO
		{
			// create new instance
			var instance:PageInstanceVO = new PageInstanceVO(settings.stageWidth, settings.stageHeight);
						
			// read in components from XML
			var compXML:XML;
			var compID:String;
			var compVO:ComponentVO;
			var compInstance:ComponentInstanceVO;
			var comps:Dictionary = new Dictionary();

			for each(compXML in xmlData.component)
			{
				compID = String(compXML.@id);
				
			 	if(comps[compID]!=null){
					compVO = comps[compID];
				} else { 
					compVO = new ComponentVO();
					compVO.id = compID;
					compVO.swfNativePath = configProxy.getPluginPath(compID);
					comps[compID] = compVO;					
			 	} 
								
                    compInstance = new ComponentInstanceVO(compVO, compXML.toXMLString());
					instance.addComponentInstance(compInstance);
			} 
			// done
			return instance; 
		}
		
		
	}
}