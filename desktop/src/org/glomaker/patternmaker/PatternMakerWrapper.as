/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker
{
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import org.glomaker.interfaces.pattern.IPatternMakerBridge;

	
	/**
	 * Provides a Flex container / wrapper for the AS3-based PatternMaker application. 
	 * @author Nils
	 */	
	public class PatternMakerWrapper extends UIComponent
	{

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		private var _pm:PatternMaker;


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 */
		public function PatternMakerWrapper()
		{
			super();
		}


		// ------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------

		/**
		 * Provides a reference to the PatternMaker application. 
		 * @return 
		 */		
		public function getContent():IPatternMakerBridge
		{
			return _pm;
		}
		
		
		// ------------------------------------------------------------------
		// UICOMPONENT OVERRIDES
		// ------------------------------------------------------------------

		override protected function createChildren():void
		{
			_pm = new PatternMaker();
			addChild(_pm);
		}
		
		override protected function measure():void
		{
			super.measure();

			var bounds:Rectangle = _pm.getBounds(this);
			
			measuredMinWidth = measuredWidth = bounds.width;
			measuredMinHeight = measuredHeight = bounds.height; 
		}
		
	}
}