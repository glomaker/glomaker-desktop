/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.journey
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.validators.RegExpValidator;
	
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.view.popups.PopupMediator;
	import org.glomaker.common.data.JourneySettingsVO;

	
	/**
	 * Integrates the JourneySettingsPopup view component into the application.
	 * 
	 * @author Haykel
	 */	
	public class JourneySettingsPopupMediator extends PopupMediator
	{
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
	
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "JourneySettingsPopupMediator";
		
		/**
		 * Format of the input for lat/long.
		 */
		protected static const LAT_LONG_PATTERN:RegExp = /(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)/;
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * Journey settings to work on.
		 */
		protected var settings:JourneySettingsVO;
		
		/**
		 * Validator for the lat/long input field.
		 */
		protected var gpsLatLongValidator:RegExpValidator;

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
				
		public function JourneySettingsPopupMediator(viewComponent:JourneySettingsPopup)
		{
			super(NAME, viewComponent);
			
			gpsLatLongValidator = new RegExpValidator();
			gpsLatLongValidator.required = false;
			gpsLatLongValidator.expression = LAT_LONG_PATTERN.source;
			gpsLatLongValidator.noMatchError = "Please enter the coordinates in the format: latitude,longitude. Example: 36.800145,10.186165";
		}

		// ------------------------------------------------------------------
		// PUREMVC INTEGRATION
		// ------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			populateFromProxy();
			
			// Configure validators
			gpsLatLongValidator.source = viewRef.gpsLatLongInput;
			gpsLatLongValidator.property = "text";
			
			// Add event listeners
			viewRef.gpsMapButton.addEventListener(MouseEvent.CLICK, gpsMapButton_clickHandler);
			viewRef.okButton.addEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			// Release validators
			gpsLatLongValidator.source = null;
			
			// Remove events listeners
			viewRef.okButton.removeEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
		}

		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------

		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():JourneySettingsPopup
		{
			return viewComponent as JourneySettingsPopup;
		}

		/**
		 * Parses the content of the gps lat/long field.
		 * 
		 * @return a point with the latitude in "x" and longitude in "y" if valid, null otherwise.
		 * 
		 */
		protected function parseGpsLatLong():Point
		{
			var result:Object = LAT_LONG_PATTERN.exec(viewRef.gpsLatLongInput.text);
			
			return result ? new Point(parseFloat(result[1]), parseFloat(result[3])) : null;
		}
		
		/**
		 * Populate the view component from data stored in the model layer. 
		 */
		protected function populateFromProxy():void
		{
			var projectProxy:ProjectSettingsProxy = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy);
			settings = projectProxy.settings.journey ? projectProxy.settings.journey : new JourneySettingsVO();
			
			viewRef.nameInput.text = settings.name;
			viewRef.locationInput.text = settings.location;
			viewRef.indexInput.value = settings.index;
			
			viewRef.gpsEnabledCheck.selected = settings.gpsEnabled;
			viewRef.gpsLatLongInput.text = !isNaN(settings.gpsLat) && !isNaN(settings.gpsLong) ? (settings.gpsLat + "," + settings.gpsLong) : "";
		}
		
		/**
		 * Update settings data from view component.
		 */
		protected function updateSettingsFromView():void
		{
			settings.name = viewRef.nameInput.text;
			settings.location = viewRef.locationInput.text;
			settings.index = viewRef.indexInput.value;
			
			settings.gpsEnabled = viewRef.gpsEnabledCheck.selected;
			
			var latLong:Point = parseGpsLatLong();
			settings.gpsLat = latLong ? latLong.x : NaN;
			settings.gpsLong = latLong ? latLong.y : NaN;
		}
		
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		protected function gpsMapButton_clickHandler(event:MouseEvent):void
		{
			var latLong:Point = parseGpsLatLong();
			if (!latLong)
				return;
			
			navigateToURL(new URLRequest("http://maps.google.com?q=" + latLong.x + "," + latLong.y));
		}

		protected function onOKClick(evt:MouseEvent):void
		{
			var projectProxy:ProjectSettingsProxy = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy);
			projectProxy.settings.journey = settings;
			updateSettingsFromView();
			removePopup();
		}
		
		protected function onCancelClick(evt:MouseEvent):void
		{
			removePopup();
		}
		
	}
}