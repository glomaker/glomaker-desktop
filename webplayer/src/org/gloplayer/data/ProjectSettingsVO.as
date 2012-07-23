package org.gloplayer.data
{
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	
	
	/**
	 * Stores project settings data. 
	 * @author Nils
	 */	
	public class ProjectSettingsVO implements IValueObject
	{
		public var savePath:String = null;
		public var stageWidth:uint = 640;
		public var stageHeight:uint = 480;
		public var stageColour:uint = 0xFFFFFF;
		public var selectedStage:StageVO;
		public var loadedPageIndex:uint;
		public var textControlsArea:HBox;
		//Pages
		
		/**
		 * Stores instances of view.pages.IBasePage.
		 */
		public var pages:ArrayCollection = new ArrayCollection();
		
		public var pageID:uint = 0;
		
		//Components
		
		/**
		 * Stores instances of view.components.Icomponent.
		 */
		public var components:ArrayCollection = new ArrayCollection();
		
		public var componentID:uint = 0;
	}
}