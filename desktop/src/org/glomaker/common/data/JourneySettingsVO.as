/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data
{
	import org.glomaker.common.interfaces.IValueObject;
	
	/**
	 * Stores journey settings. 
	 * 
	 * @author Haykel
	 */	
	public class JourneySettingsVO implements IValueObject
	{
		public var name:String;
		public var location:String;
		public var index:uint = 0;
		
		public var gpsLat:Number;
		public var gpsLong:Number;
		public var gpsEnabled:Boolean = false;
		
		public var qrCode:String;
		public var qrEnabled:Boolean = false;
	}
}