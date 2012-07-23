/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import flash.filesystem.File;
	
	import org.glomaker.common.data.PluginType;
	import org.glomaker.common.vo.PageVO;
	import org.glomaker.common.vo.PluginInfoVO;
	
	public class PagePluginProxy extends PluginProxy
	{
		
		/**
		 * PureMVC identifier. 
		 */		
		public static const NAME:String = "PagePluginProxy";
		
		
		// sorted list cache
		protected var _sortedListCache:Array;
		
		
		/**
		 * Constructor 
		 */		
		public function PagePluginProxy()
		{
			super(NAME, []);
		}
		
		
		// ***** public methods
		
		public function getPageByID(id:String):PageVO
		{
			return getById(id) as PageVO;
		}
		
		public function getLayouts():Array
		{
			return getData() as Array;
		}
		
		public function getSortedLayouts():Array
		{
			// fill cache if not already available
			if(!_sortedListCache)
				_sortedListCache = getLayouts().concat().sortOn("name", Array.CASEINSENSITIVE);
				
			return _sortedListCache;
		}
		
		/**
		 * Retrieves a list of PageVO instances matching a list of IDs. 
		 * @param idList
		 * @return 
		 */		
		public function getMatchingLayouts(idList:Array):Array
		{
			var layouts:Array = [];
			var all:Array = getData() as Array;
			var id:String;
			var page:PageVO;
			
			for each(id in idList)
			{
				page = getPageByID(id);
				if(page)
					layouts.push(page);
			}
			
			return layouts;
		}

		
		// ***********************
		// PluginProxy overridden methods
		// ***********************
		
		override protected function getPluginPath():File
		{
			//var f:File = File.applicationStorageDirectory;
			var f:File = File.applicationDirectory;
			return f.resolvePath("plugins/pages/");
			//return f.resolvePath(rootPath+"/pages/");
		}
		
		override protected function getPluginType():uint
		{
			return PluginType.PAGE;
		}
		
		override protected function getPluginVO():PluginInfoVO
		{
			return new PageVO();
		}
		
		override protected function doCustomProcessing(vo:PluginInfoVO, infoFile:File, rawXML:XML):PluginInfoVO
		{
			vo = super.doCustomProcessing(vo, infoFile, rawXML);
			
			// extract additional parameters
			var pageVO:PageVO = vo as PageVO;
			
			if(pageVO)
			{
				// extract additional page information
				var component:XML;
				var o:Object;
				for each(component in rawXML.component)
				{
					pageVO.addComponent(componentProxy.getComponentById(component.@id), component.toXMLString());
				}
			}
			
			return vo;
		}
		
		protected function get componentProxy():ComponentPluginProxy
		{
			return facade.retrieveProxy(ComponentPluginProxy.NAME) as ComponentPluginProxy;
		}
		
	}
}