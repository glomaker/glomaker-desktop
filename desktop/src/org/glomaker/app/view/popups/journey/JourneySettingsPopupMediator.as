/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.journey
{
	import com.google.zxing.BarcodeFormat;
	import com.google.zxing.MultiFormatWriter;
	import com.google.zxing.common.BitMatrix;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.events.NumericStepperEvent;
	import mx.graphics.codec.PNGEncoder;
	import mx.validators.NumberValidator;
	import mx.validators.RegExpValidator;
	import mx.validators.Validator;
	
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
		
		/**
		 * Size of an edge of the QR code image displayed in the popup.
		 */
		protected static const QR_IMAGE_SIZE:uint = 78;
		
		/**
		 * Size of an edge of the QR code image for printing.
		 */
		protected static const QR_PRINT_SIZE:uint = 900;
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * Journey settings to work on.
		 */
		protected var settings:JourneySettingsVO;
		
		/**
		 * Validator for the name field (required field).
		 */
		protected var nameValidator:Validator;
		
		/**
		 * Validator for the index field.
		 */
		protected var indexValidator:NumberValidator;
		
		/**
		 * Validator for the lat/long input field.
		 */
		protected var gpsLatLongValidator:RegExpValidator;
		
		/**
		 * Holds the last displayed QR code.
		 */
		protected var lastQrCode:String;
		
		/**
		 * Directory for saving QR code images. Updated on every save operation to hold
		 * the last used directory.
		 */
		protected var qrSaveDirectory:File = File.userDirectory;
		
		
		protected var qrWarningWasShown:Boolean = false;

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
				
		public function JourneySettingsPopupMediator(viewComponent:JourneySettingsPopup)
		{
			super(NAME, viewComponent);
			
			nameValidator = new Validator();
			
			indexValidator = new NumberValidator();
			indexValidator.domain = "int";
			indexValidator.minValue = 1;
			
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
			
			// Configure validators
			nameValidator.source = viewRef.nameInput;
			nameValidator.property = "text";
			
			indexValidator.source = viewRef.indexInput;
			indexValidator.property = "value";
			
			gpsLatLongValidator.source = viewRef.gpsLatLongInput;
			gpsLatLongValidator.property = "text";
			
			// Fill form
			populateFromProxy();
			
			// Configure components
			viewRef.qrImage.width = QR_IMAGE_SIZE;
			viewRef.qrImage.height = QR_IMAGE_SIZE;
			
			// Add event listeners
			viewRef.nameInput.addEventListener(FocusEvent.FOCUS_OUT, nameInput_focusOutHandler);
			viewRef.indexInput.addEventListener(NumericStepperEvent.CHANGE, indexInput_changeHandler);
			viewRef.gpsMapButton.addEventListener(MouseEvent.CLICK, gpsMapButton_clickHandler);
			viewRef.qrSaveButton.addEventListener(MouseEvent.CLICK, qrSaveButton_clickHandler);
			viewRef.okButton.addEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
			viewRef.qrEnabledCheck.addEventListener(Event.CHANGE, onQREnabledChange);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			// Release validators
			nameValidator.source = null;
			indexValidator.source = null;
			gpsLatLongValidator.source = null;
			
			// Remove events listeners
			viewRef.nameInput.removeEventListener(FocusEvent.FOCUS_OUT, nameInput_focusOutHandler);
			viewRef.indexInput.removeEventListener(NumericStepperEvent.CHANGE, indexInput_changeHandler);
			viewRef.gpsMapButton.removeEventListener(MouseEvent.CLICK, gpsMapButton_clickHandler);
			viewRef.qrSaveButton.removeEventListener(MouseEvent.CLICK, qrSaveButton_clickHandler);
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
			
			viewRef.qrEnabledCheck.selected = settings.qrEnabled;
			viewRef.qrWarning.visible = false;
			
			updateQrImage(false);
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
			
			settings.qrEnabled = viewRef.qrEnabledCheck.selected;
			settings.qrCode = qrCode;
		}
		
		/**
		 * Returns the QR code based on the current content of the name and index input fields.
		 */
		protected function get qrCode():String
		{
			return viewRef.nameInput.text + " " + viewRef.indexInput.value.toString();
		}
		
		/**
		 * Creates a BitmapData with the image of the current QR code.
		 */
		protected function createQrImage(size:uint):BitmapData
		{
			var bmpd:BitmapData = new BitmapData(size, size, false, 0xFFFFFF);
			var content:String = qrCode;
			
			if (content)
			{
				var writer:MultiFormatWriter = new MultiFormatWriter();
				var result:BitMatrix = writer.encode(content, BarcodeFormat.QR_CODE, size, size) as BitMatrix;
				
				for (var x:uint=0; x < size; x++)
				{
					for (var y:uint=0; y < size; y++)
					{
						if (result._get(x ,y))
							bmpd.setPixel(x, y, 0x000000);
					}
				}
			}
			
			return bmpd;
		}
		
		/**
		 * Updates the displayed QR code image.
		 */
		protected function updateQrImage(warn:Boolean=true):void
		{
			if (lastQrCode != qrCode)
			{
				viewRef.qrImage.source = new Bitmap(createQrImage(QR_IMAGE_SIZE));
				lastQrCode = qrCode;
				qrWarningWasShown = warn;
				if (warn && viewRef.qrEnabledCheck.selected)
					viewRef.qrWarning.visible = true;
			}
		}
		
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		protected function nameInput_focusOutHandler(event:FocusEvent):void
		{
			updateQrImage();
		}
		
		protected function indexInput_changeHandler(event:NumericStepperEvent):void
		{
			updateQrImage();
		}
		
		protected function gpsMapButton_clickHandler(event:MouseEvent):void
		{
			var query:String = viewRef.gpsLatLongInput.text ? ("?q=" + viewRef.gpsLatLongInput.text) : "";
			
			navigateToURL(new URLRequest("http://maps.google.com" + query));
		}
		
		protected function qrSaveButton_clickHandler(event:MouseEvent):void
		{
			var fileName:String = "qr-code_" + qrCode + ".png";
			var qrSave:File = qrSaveDirectory.resolvePath(fileName.replace(/\s/g, "-").toLowerCase());
			qrSave.browseForSave("Save QR Code Image...");
			qrSave.addEventListener(Event.SELECT, qrSave_selectHandler);
		}
		
		protected function qrSave_selectHandler(event:Event):void
		{
			var file:File = event.target as File;
			qrSaveDirectory = new File(file.parent.url);
			
			var encoder:PNGEncoder = new PNGEncoder();
			var data:ByteArray = encoder.encode(createQrImage(QR_PRINT_SIZE));
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(data);
			stream.close();
			
			viewRef.qrWarning.visible = false;
		}
		
		protected function onOKClick(evt:MouseEvent):void
		{
			if (Validator.validateAll([nameValidator, indexValidator, gpsLatLongValidator]).length > 0)
			{
				Alert.show("Please fix the errors.", "Error", 4, viewRef);
				return;
			}
			
			var projectProxy:ProjectSettingsProxy = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy);
			projectProxy.settings.journey = settings;
			updateSettingsFromView();
			
			settings = null;
			removePopup();
		}
		
		protected function onCancelClick(evt:MouseEvent):void
		{
			settings = null;
			removePopup();
		}
		
		protected function onQREnabledChange(e:Event):void
		{
			viewRef.qrWarning.visible = (viewRef.qrEnabledCheck.selected && qrWarningWasShown );
		}
		
	}
}