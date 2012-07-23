/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import mx.collections.ArrayCollection;
	
	import org.glomaker.common.data.ProjectSettingsVO;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.glomaker.common.vo.PatternVO;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	/**
	 * Stores project settings.
	 * 
	 * Use 'settings' property instead of getData() for a typed reference to the data stored by the proxy.
	 * 
	 * @author Nils
	 * 
	 */	
	public class ProjectSettingsProxy extends Proxy
	{
		
		// -------------------------------------------------------------------
		// STATIC PROPERTIES
		// -------------------------------------------------------------------

		/**
		 * PureMVC identifier 
		 */		
		public static const NAME:String = "ProjectSettingsProxy";
		
		
		/**
		 * Notification broadcast when the filename has changed.
		 * Body: New filename. 
		 */	
		public static const FILENAME_UPDATE:String = "ProjectSettingsProxy.FILENAME_UPDATE";
		

		// -------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// -------------------------------------------------------------------

		/**
		 * Stores the name of the currently selected pattern (EASE, EMI, freestyle).
		 * Initially null.
		 * Use getter to obtain value.
		 * @see setCurrentPattern()
		 */		
		protected var _currentPattern:PatternVO;

		/**
		 * Stores the linked IPatternNode instances used in the current pattern.
		 * Initially null.
		 * Use getter to obtain value.
		 * @see setCurrentPattern()
 		 */		
		protected var _currentPatternNodes:Array;
		

		// -------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------
		
		/**
		 * Constructor 
		 * @param proxyName
		 * @param data
		 */		
		public function ProjectSettingsProxy()
		{
			super(NAME, new ProjectSettingsVO());
		}
		

		// -------------------------------------------------------------------
		// GETTER / SETTERS
		// -------------------------------------------------------------------

		/**
		 * Currently selected pattern (EAMA, EMI, etc)
		 * @return 
		 */		
		public function get currentPattern():PatternVO
		{
			return _currentPattern;
		}
		
		/**
		 * Array of linked IPatternNode instances that form the current pattern's pedagogical sequence. 
		 * @return 
		 */		
		public function get currentPatternNodes():Array
		{
			return _currentPatternNodes;
		}
		
		// -------------------------------------------------------------------
		// PUBLIC METHODS
		// -------------------------------------------------------------------


		/**
		 * Stores current pattern and nodes information.
		 * @param pattern
		 */		 
		public function setCurrentPattern(pattern:PatternVO):void
		{
			_currentPattern = pattern;
		}
		
		/**
		 * Stores current pattern. 
		 * @param nodes
		 */
		public function setPatternNodes(nodes:Array):void
		{
			_currentPatternNodes = nodes;
		}
		
		
		/**
		 * Adds a PageInstanceVO to the current project. 
		 * @param instance
		 * @param index [optional]
		 */		
		public function addPageInstance(instance:PageInstanceVO, index:int = -1):void
		{
			if(index > -1)
			{
				pages.addItemAt(instance, index);
			}else{
				pages.addItem(instance);
			}
		}
		
		/**
		 * Removes page stored within Pages ArrayCollection according to its index. 
		 * @param index
		 * 
		 */
		public function removePageAt(index:int):void
		{		
			// remove page from collection
			pages.removeItemAt(index);
		}
		
		/**
		 * Get page stored within Pages ArrayCollection according to its index. 
		 * @param index
		 * 
		 */
		public function getPageAt(index:int):PageInstanceVO
		{		
			// return page from collection
			return pages.getItemAt(index) as PageInstanceVO;
		}
		
		/**
		 * Removes all pages stored within Pages ArrayCollection 
		 * 
		 */
		public function removeAllPages():void
		{		
			// remove all pages from collection
			pages.removeAll();
						
		}
		
		/**
		 * Typed reference to the data stored in the proxy. 
		 * @return
		 */		
		public function get settings():ProjectSettingsVO
		{
			return (getData() as ProjectSettingsVO);
		}
		
		/**
		 * Returns the pages ArrayCollection 
		 * @return 
		 * 
		 */
		protected function get pages():ArrayCollection
		{
			return settings.pages;
		}
		
		/**
		 * Set New Stage Dimensions 
	     * @author Musbah
		 * 
		 */
		public function setStageDimensions(stageWidth:Number,stageHeight:Number):void
		{
			var pages:ArrayCollection = settings.pages;
			var page:PageInstanceVO;
			var i:int;

			for each (page in pages)
			{
			  var componentList:Array = page.components;
			  
               for(i=0;i<componentList.length;i++){
               	var instance:ComponentInstanceVO = componentList[i];
               	// convert to xml
			    var xml:XML = new XML(instance.rawPropXML);
			    // calculate size rations
			    var wRatio:Number = stageWidth/settings.stageWidth;
			    var hRatio:Number = stageHeight/settings.stageHeight;
			    // calculate new location and size
			    xml.@x = String(wRatio * Number(xml.@x));
			    xml.@y = String(hRatio * Number(xml.@y));
			    xml.@width = String(wRatio * Number(xml.@width));
			    xml.@height = String(hRatio * Number(xml.@height));
			    instance.rawPropXML = xml.toXMLString();
               }

			}
			// Set to the new stageWidth * stageHeight
			settings.stageWidth = stageWidth;
			settings.stageHeight = stageHeight;

		}
		
		
		/**
		 * Updates the filename for the current project and sends a FILENAME_UPDATE notification.
		 * Use this method rather than setting settings.savePath directly so that update notifications can be sent. 
		 * @param value
		 */		
		public function setFilename(value:String):void
		{
			if(value != settings.savePathURL)
			{
				settings.savePathURL = value;
				sendNotification(FILENAME_UPDATE, value);
			}
		}
		
	}
}