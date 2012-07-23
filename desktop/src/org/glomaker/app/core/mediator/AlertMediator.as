/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.core.mediator
{
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;


	/**
	 * Handles display of an Alert dialogue box and integrates it into the application.
	 * The AlertMediator instance will chose its own mediator name dynamically when created.
	 * When the Alert dialogue is closed by the user, the Mediator automatically unregisters itself.
	 *
	 * Usage:
	 * 
	 * var am:AlertMediator = new AlertMediator();
	 * facade.registerMediator(am);
	 * 
	 * am.acceptNotification = "YES_NOTIFICATION";
	 * am.declineNotification = "NO_NOTIFICATION";
	 * am.notificationBody = {userID: 234};
	 * 
	 * am.show("Do you want to continue?", "Title", Alert.YES | Alert.NO);
	 * 
	 * @author Nils
	 */
	public class AlertMediator extends Mediator
	{

		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * Name prefix used to create dynamic mediator names.
		 * Names will be appended by the INSTANCE_COUNT to create a unique mediator name. 
		 */
		protected static const NAME_PREFIX:String = "AlertMediator_";
		
		/**
		 * Counter indicating how many instances of this class have been created. 
		 */		
		protected static var INSTANCE_COUNT:uint = 0;


		// ------------------------------------------------------------------
		// PRIVATE INSTANCE PROPERTIES
		// ------------------------------------------------------------------

		private var _yesNotification:String;
		private var _noNotification:String;
		private var _okNotification:String;
		private var _cancelNotification:String;
		
		private var _notificationBody:Object;
		private var _notificationType:String;

		private var _alertInstance:Alert;


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * Constructor
		 * @constructor 
		 */
		public function AlertMediator()
		{
			super(NAME_PREFIX + INSTANCE_COUNT);
			
			// update instance count so each Mediator instance can be registered with a unique name
			INSTANCE_COUNT++;
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		/**
		 * Notification name to send when the user selects 'yes'.
		 * If you are not interested in this user action, don't set a value for it.
  		 * @param value
		 */
		public function set yesNotification(value:String):void
		{
			_yesNotification = value;
		}


		/**
		 * Notification name to send when the user selects 'no'.
		 * If you are not interested in this user action, don't set a value for it.
		 * @param value
		 */
		public function set noNotification(value:String):void
		{
			_noNotification = value;
		}
		

		/**
		 * Notification name to send when the user selects 'ok'.
		 * If you are not interested in this user action, don't set a value for it.
		 * @param value
		 */
		public function set okNotification(value:String):void
		{
			_okNotification = value;
		}


		/**
		 * Notification name to send when the user selects 'cancel'.
		 * If you are not interested in this user action, don't set a value for it.
		 * @param value
		 */
		public function set cancelNotification(value:String):void
		{
			_cancelNotification = value;
		}

		
		/**
		 * Optional body to include in the accept/decline notification.
		 * @param value
		 */		
		public function set notificationBody(value:Object):void
		{
			_notificationBody = value;
		}
		

		/**
		 * Optional type value to include in the accept/decline notification. 
		 * @param value
		 */		
		public function set notificationType(value:String):void
		{
			_notificationType = value;
		}


		// ------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Show an alert.
		 * Mirrors the Alert.show() function, with the exception that no closeHandler can be specified. 
		 * @param text
		 * @param title
		 * @param flags
		 * @param parent
		 * @param iconClass
		 * @param defaultButtonFlag
		 * @return The Alert instance.
		 * @throws Error if an Alert is already being shown by the mediator instance.
		 */		
		public function show(text:String = "", title:String = "", flags:uint = 4, parent:Sprite = null, iconClass:Class = null, defaultButtonFlag:uint = 4):Alert
		{
			// only allow a single Alert instance to be shown
			if(_alertInstance)
				throw new Error("This Mediator was already used to show an Alert. Please create a new instance or wait for the previous alert to close.");
				
			// show new one			
			_alertInstance = Alert.show(text, title, flags, parent, onAlertClose, iconClass, defaultButtonFlag);
			
			// done
			return _alertInstance;
		}
		


		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Unregisters the instance itself from the PureMVC Facade.
		 * Called internally when the user has closed the Alert dialogue box.  
		 */		
		protected function removeSelf():void
		{
			// we can't guarantee that the Mediator was registered with the facade
			if(facade)
				facade.removeMediator(getMediatorName());
		}
		

		// ------------------------------------------------------------------
		// EVENT LISTENERS
		// ------------------------------------------------------------------

		/**
		 * Event listener - user has closed the Alert dialogue. 
		 * @param evt
		 */		
		protected function onAlertClose(evt:CloseEvent):void
		{
			var noteName:String;
			
			switch(evt.detail)
			{
				case Alert.OK:
					noteName = _okNotification;
					break;
					
				case Alert.YES:
					noteName = _yesNotification;
					break;
				
				case Alert.CANCEL:
					noteName = _cancelNotification;
					break;
					
				case Alert.NO:
					noteName = _noNotification;
					break;
			}
			
			
			// we can't guarantee that the Mediator has been registered with the facade
			if(facade)
			{
				if(noteName)
					sendNotification(noteName, _notificationBody, _notificationType);

				removeSelf();
			}
			
			// Alert no longer shown
			_alertInstance = null;
		}
		
	}
}