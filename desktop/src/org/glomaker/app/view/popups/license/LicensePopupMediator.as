/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.license
{
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.glomaker.app.view.popups.PopupMediator;

	public class LicensePopupMediator extends PopupMediator
	{
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
	
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "LicensePopupMediator";
		
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
				
		public function LicensePopupMediator(viewComponent:LicensePopup)
		{
			super(NAME, viewComponent);
		}


		// ------------------------------------------------------------------
		// PUREMVC INTEGRATION
		// ------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			populateFromProxy();
			
			// Add event listeners
			viewRef.popupCloseButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			// Remove events listeners
			viewRef.popupCloseButton.removeEventListener(MouseEvent.CLICK, onCloseClick);
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------

		
		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():LicensePopup
		{
			return viewComponent as LicensePopup;
		}


		/**
		 * Populate the view component from data stored in the model layer. 
		 */
		protected function populateFromProxy():void
		{
			// get HTML file
			var f:File = File.applicationDirectory.resolvePath( configProxy.licenseHTMLFile );
			
			// read it in
			var stream:FileStream = new FileStream();
  			stream.open(f, FileMode.READ);
  			
  			var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
  			
  			// display it
  			viewRef.licenseText.htmlText = fileData;
		}
		


		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------

		protected function onCloseClick(evt:MouseEvent):void
		{
			removePopup();
		}
	}
}