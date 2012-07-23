/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{
	/**
	 * Defines a single page of pattern function guidance content. 
	 * @author Nils
	 */
	[Bindable]
	public class PatternGuidancePage implements IPatternGuidancePage
	{

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------

		private var _title:String;
		private var _htmlContent:String;

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * Constructor 
		 * @param title
		 * @param htmlContent
		 */
		public function PatternGuidancePage(title:String = null, htmlContent:String = null)
		{
			this.title = title;
			this.htmlContent = htmlContent;
		}


		// ------------------------------------------------------------------
		// GETTER / SETTERS (implement IPatternGuidancePage)
		// ------------------------------------------------------------------

		/**
		 * The guidance page's title. 
		 */
		public function set title(value:String):void
		{
			_title = value;
		}
		public function get title():String
		{
			return _title;
		}
		
		
		/**
		 * The guidance page's htmlContent. 
		 */		
		public function set htmlContent(value:String):void
		{
			_htmlContent = value;
		}
		public function get htmlContent():String
		{
			return _htmlContent;
		}
		
	}
}