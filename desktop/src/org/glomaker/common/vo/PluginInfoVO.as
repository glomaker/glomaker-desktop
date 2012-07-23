/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.vo
{
	import org.glomaker.common.interfaces.IClonable;
	import org.glomaker.common.interfaces.IValueObject;
	
	/**
	 * Stores data about a particular plugin. 
	 * @author Nils
	 */	
	[Bindable]
	public class PluginInfoVO implements IValueObject, IClonable
	{
		
		public var id:String;
		public var type:uint; // see PluginType static identifiers
		public var author:String;
		public var version:String;
		public var glomakerVersion:String;
		public var name:String;
		public var description:String = "";
		
		public var pluginURL:String;
		public var iconURL:String;


		// -----------------------------------------
		// Accessors for dataProvider use
		// These avoid problem that File class not providing bindable properties
		// -----------------------------------------
		
		/**
		 * Creates a copy of the value object.
		 * @abstract Implement in subclass. 
		 * @return 
		 */		
		public function clone():Object
		{
			throw new Error("Abstract method - must be implemented in subclass");
		}
	}
}