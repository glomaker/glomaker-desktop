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
	import org.glomaker.common.vo.ComponentVO;
	import org.glomaker.common.vo.PluginInfoVO;
	
	public class ComponentPluginProxy extends PluginProxy
	{
		
		/**
		 * PureMVC identifier 
		 */		
		public static const NAME:String = "ComponentPluginProxy";
		
		
		/**
		 * Cached, alphabetically sorted list of components to show in the library. 
		 */		
		protected var _sortedListCache:Array;
		
		
		/**
		 * Constructor 
		 */		
		public function ComponentPluginProxy()
		{
			super(NAME, []);
		}
		
		
		// ***** public methods
		
		public function getComponentById(id:String):ComponentVO
		{
			return getById(id) as ComponentVO;
		}
		
		public function getLibraryList():Array
		{
			var filtered:Array = [];
			var list:Array = getData() as Array;
			
			for each(var compVO:ComponentVO in list)
			{
				if(compVO.showInLibrary)
					filtered.push(compVO);
			}
			
			return filtered; 
		}
		
		public function getSortedList():Array
		{
			if(!_sortedListCache)
			{
				_sortedListCache = getLibraryList().concat();
				_sortedListCache.sortOn("name", Array.CASEINSENSITIVE);
			}
			
			return _sortedListCache;
		}
		

		// ***********************
		// PluginProxy overridden methods
		// ***********************
		
		override protected function getPluginPath():File
		{
			//var f:File = File.applicationStorageDirectory;
			var f:File = File.applicationDirectory;
			//return f.resolvePath(rootPath+"plugins/components/");
			return f.resolvePath("plugins/components/");
		}
		
		override protected function getPluginType():uint
		{
			return PluginType.COMPONENT;
		}
		
		override protected function getPluginVO():PluginInfoVO
		{
			return new ComponentVO();
		}
		
		override protected function doCustomProcessing(vo:PluginInfoVO, infoFile:File, rawXML:XML):PluginInfoVO
		{
			// note: incoming vo parameters is of type returned by getPluginVO(),
			// which in this class is the class ComponentPluginVO
			
			vo = super.doCustomProcessing(vo, infoFile, rawXML);
			
			// custom processing
			var compVO:ComponentVO = vo as ComponentVO;
			
			if(compVO)
			{
				// by default all components are selectable and creatable
				compVO.showInLibrary = true;
				compVO.isEditable = true;
				
				// add component swf path
				var swfFile:File = infoFile.parent.resolvePath(rawXML.swf);
				if(swfFile.exists)
				{
					compVO.swfNativePath = swfFile.nativePath;
					compVO.swfAIRUrl = swfFile.url;
				}else{
					// swf file wasn't found - component definition incomplete
					throw new Error("Failed to find swf file - filename in XML: " + rawXML.swf);
				}
			}
			
			// done
			return vo;
		}
		
		
		// ***********************
		// EVENT LISTENERS
		// ***********************
		
		
	}
}