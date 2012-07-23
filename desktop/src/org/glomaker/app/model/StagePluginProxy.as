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
	import org.glomaker.common.data.StageVO;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.ComponentVO;
	import org.glomaker.common.vo.PluginInfoVO;
	
	public class StagePluginProxy extends PluginProxy
	{
		
		/**
		 * PureMVC identifier. 
		 */		
		public static const NAME:String = "StagePluginProxy";
		
		
		/**
		 * Cache storage for alphabetically sorted list of plugins. 
		 */		
		protected var _sortedListCache:Array;
		

		/**
		 * Constructor 
		 */		
		public function StagePluginProxy()
		{
			super(NAME, []);
		}
		

		// ------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------


		/**
		 * Get a list of all available stages. 
		 * @return An Array of StageVO instance.
		 */
		public function getStageList():Array
		{
			return getData() as Array;
		}
		
		
		/**
		 * Get a list of all available stages, sorted alphabetically by their names. 
		 * @return 
		 */		
		public function getSortedStageList():Array
		{

			// retrieve from cache (recreate cache if required)			
			if(!_sortedListCache)
			{
				_sortedListCache = getStageList().concat();
				_sortedListCache.sortOn("name", Array.CASEINSENSITIVE);
			}
			
			return _sortedListCache;
		}
		
		/**
		 * Retrieve the stage with a given ID. 
		 * @param id
		 * @return 
		 */		
		public function getStageByID(id:String):StageVO
		{
			var vo:StageVO;
			var list:Array = getStageList();
			for each(vo in list)
			{
				if(vo.id == id)
					return vo;
			}
			
			// none found
			return null;
		}


		// ------------------------------------------------------------------
		// PluginProxy IMPLEMENTATION
		// ------------------------------------------------------------------

		override protected function getPluginPath():File
		{
			//var f:File = File.applicationStorageDirectory;
			var f:File = File.applicationDirectory;
			return f.resolvePath("plugins/stages/");
			//return f.resolvePath(rootPath+"/stages/");
		}
		
		
		override protected function getPluginType():uint
		{
			return PluginType.STAGE;
		}
		
		override protected function getPluginVO():PluginInfoVO
		{
			return new StageVO();
		}
		
		override protected function doCustomProcessing(vo:PluginInfoVO, infoFile:File, rawXML:XML):PluginInfoVO
		{
			vo = super.doCustomProcessing(vo, infoFile, rawXML);
			
			// extract additional parameters
			var stageVO:StageVO = vo as StageVO;
			var compVO:ComponentVO;
			var swfFile:File;
			
			if(stageVO)
			{
				// extract additional information
				
				// navigation component
				if(rawXML.swf.length() == 1)
				{
					swfFile = infoFile.parent.resolvePath(String(rawXML.swf));
					if(swfFile.exists)
					{
						compVO = new ComponentVO();

						// auto-generated ID						
						compVO.id = vo.id + "_comp"; // auto-created id value
						
						// copy from stage values
						compVO.author = stageVO.author;
						compVO.description = stageVO.description;
						compVO.glomakerVersion = stageVO.glomakerVersion;
						compVO.iconURL = stageVO.iconURL;
						compVO.name = stageVO.name;
						compVO.type = stageVO.type;											
						
						// component-specific values
						compVO.swfNativePath = swfFile.nativePath;
						compVO.swfAIRUrl = swfFile.url;
						compVO.isEditable = false;
						compVO.showInLibrary = false;

						// store it					
						stageVO.componentInstance = new ComponentInstanceVO(compVO, XML(rawXML.swf[0]).toXMLString());
					}
				}
				
				// @todo - add error handling
				// if(!stageVO.componentInstance)
			}
			
			return vo;
		}
		
		
	}
}