/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data
{
	import mx.collections.ArrayCollection;
	
	import org.glomaker.common.interfaces.IValueObject;
	
	
	/**
	 * Stores project settings data. 
	 * @author Nils
	 */	
	public class ProjectSettingsVO implements IValueObject
	{
		public var savePathURL:String = null;
		
		public var stageWidth:Number = 800;
		public var stageHeight:Number = 600;
		
		public var stageColour:uint = 0xFFFFFF;
		public var selectedStage:StageVO;
		public var loadedPageIndex:int = 0;

		//Pages
		
		/**
		 * Stores instances of data.PageVO.
		 */
		public var pages:ArrayCollection = new ArrayCollection();
		
		public var xxpageID:uint = 0;
	}
}