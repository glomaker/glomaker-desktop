/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.core.mediator
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class FileSelectorMediator extends Mediator
	{
		
		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * Name prefix used to create dynamic mediator names.
		 * Names will be appended by the INSTANCE_COUNT to create a unique mediator name. 
		 */
		protected static const NAME_PREFIX:String = "DirectorySelectorMediator_";
		
		/**
		 * Counter indicating how many instances of this class have been created. 
		 */		
		protected static var INSTANCE_COUNT:uint = 0;


		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		protected var _file:File;
		protected var _selectNotification:String;
		protected var _cancelNotification:String;
		protected var _notificationType:String;

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * Constructor
		 * @constructor 
		 * @param file
		 */		 
		public function FileSelectorMediator(file:File)
		{
			super(NAME_PREFIX + INSTANCE_COUNT);
			
			// update instance count so we obtain a unique name for each Mediator instance
			INSTANCE_COUNT++;
			
			// save
			_file = file;
		}


		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------

		
		/**
		 * Notification to be sent when the user has selected a file (or multiple files).
		 * The body will contain either a single File object (for single selections) or an Array of File objects (for multiple selections).
		 * If no value is specified, no notification will be sent.
  		 * @param value
		 */		
		public function set selectNotification(value:String):void
		{
			_selectNotification = value;
		}


		/**
		 * Notification to be sent when the user has cancelled the file selector.
		 * If no value is specified, no notification will be sent.
		 * @param value
		 */		
		public function set cancelNotification(value:String):void
		{
			_cancelNotification = value;
		}


		/**
		 * Optional type information to include in the select/cancel notification. 
		 * @param value
		 */		
		public function set notificationType(value:String):void
		{
			_notificationType = value;
		}


		// ------------------------------------------------------------------
		// PureMVC INTEGRATION OVERRIDES
		// ------------------------------------------------------------------
		
		override public function onRegister():void
		{
			_file.addEventListener(Event.SELECT, onSelect);
			_file.addEventListener(FileListEvent.SELECT_MULTIPLE, onSelectMultiple);
			_file.addEventListener(Event.CANCEL, onCancel);
		}
		
		override public function onRemove():void
		{
			_file.removeEventListener(Event.SELECT, onSelect);
			_file.removeEventListener(FileListEvent.SELECT_MULTIPLE, onSelectMultiple);
			_file.removeEventListener(Event.CANCEL, onCancel);			
		}
		
		
		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Removes the Mediator instance from the facade. 
		 */		
		protected function removeSelf():void
		{
			// we can't guarantee tha the Mediator instance was registered
			if(facade)
				facade.removeMediator(getMediatorName());
		}


		// ------------------------------------------------------------------
		// EVENT LISTENERS
		// ------------------------------------------------------------------

		/**
		 * User has selected a file. 
		 * @param evt
		 */		
		protected function onSelect(evt:Event):void
		{
			// we can't guarantee that the Mediator was ever registered with the facade
			if(facade)
			{
				sendNotification(_selectNotification, evt.target, _notificationType);
				removeSelf();
			}
		}
		
		/**
		 * User has selected multiple files. 
		 * @param evt
		 */		
		protected function onSelectMultiple(evt:FileListEvent):void
		{
			// we can't guarantee that the Mediator was ever registered with the facade
			if(facade)
			{
				sendNotification(_selectNotification, evt.files, _notificationType);
				removeSelf();
			}
		}
		
		
		/**
		 * User has cancelled / closed the file selector. 
		 * @param evt
		 */		
		protected function onCancel(evt:Event):void
		{
			// we can't guarantee that the Mediator was ever registered with the facade
			if(facade)
			{
				sendNotification(_cancelNotification, _notificationType);
				removeSelf();
			}
		}
		
	}
}