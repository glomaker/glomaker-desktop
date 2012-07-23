/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.nav
{
	import flash.events.Event;
	
	import mx.containers.ViewStack;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ApplicationStateProxy;
	import org.glomaker.app.view.editor.EditorMediator;
	import org.glomaker.app.view.editor.EditorView;
	import org.glomaker.app.view.patternmaker.PatternMakerMediator;
	import org.glomaker.app.view.patternmaker.PatternMakerView;
	import org.glomaker.app.view.player.PlayerView;
	import org.glomaker.app.view.player.PlayerViewMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class AppSectionMediator extends Mediator
	{
		
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "AppSectionMediator";
		
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * View helper 
		 */
		protected var _viewRef:ViewStack;
		
		/**
		 * Keep track of the last dynamically created mediator so it can be removed. 
		 */		
		protected var _lastMediator:Mediator = null;
		
		/**
		 * Keep track of the viewStack's most recently selected child index.
		 * Used to prevent repeated mediator creation for the same tab. 
		 */		
		protected var _lastSelectedIndex:int = -1;


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * @constructor 
		 * @param viewComponent
		 */		
		public function AppSectionMediator(viewComponent:ViewStack)
		{
			super(NAME, viewComponent);
			_viewRef = viewComponent;
		}
		

		// ------------------------------------------------------------------
		// PUREMVC INTEGRATION
		// ------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			_viewRef.addEventListener(Event.CHANGE, onTabChange);
			createTabMediator();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			_viewRef.removeEventListener(Event.CHANGE, onTabChange);
			removeTabMediator(); 
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			// listen for 'change to different tab' notifications
			list.push(ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION);
			
			// done
			return list;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			
			switch(notification.getName())
			{
				case ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION:
				
					switch(notification.getBody())
					{
						case ApplicationStateProxy.SECTION_PATTERNMAKER:
							_viewRef.selectedIndex = 0;
							break;
							
						case ApplicationStateProxy.SECTION_EDITOR:
							_viewRef.selectedIndex = 1;
							break;
							
						case ApplicationStateProxy.SECTION_PLAYER:
							_viewRef.selectedIndex = 2;
							break;
					}
			}
		}
		

		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Creates a new Mediator for the TabNav current child.
		 */		
		protected function createTabMediator():void
		{
			
			var tab:Object = _viewRef.selectedChild;
			
			// store the most recent index so we can avoid repeat execution
			_lastSelectedIndex = _viewRef.selectedIndex;
			
			// make sure current tab data is saved back to the model layer
			// sendNotification(Notifications.APP_SAVE_DATA, null, "AppSectionMediator");	
			
			// Remove the mediator of the previously selected tab
			removeTabMediator(); 
			
			// Create the correct Mediator for the selected tab
			if(tab is PatternMakerView)			{
				_lastMediator = new PatternMakerMediator(tab as PatternMakerView);
			}else if(tab is EditorView){
				_lastMediator = new EditorMediator(tab as EditorView);
			}else if(tab is PlayerView){
				_lastMediator = new PlayerViewMediator(PlayerViewMediator.NAME, tab as PlayerView);
			}
	 
			// Add more here as needed!
			// .......................
			
			// Register the current mediator with the facade!
			if(_lastMediator)
			 facade.registerMediator(_lastMediator);
			
		}
		
		/**
		 * Removes the current dynamically registered mediator. 
		 */		
		protected function removeTabMediator():void
		{
			if(facade && _lastMediator)
				facade.removeMediator(_lastMediator.getMediatorName());
				
			_lastMediator = null;
		}
	
	
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		/**
		 * Loads and unloads appropriate tab mediator.
		 * @param evt
		 */
		protected function onTabChange(evt:Event):void
		{
			// the handler is sometimes called repeatedly without the selected index changing
			// we catch these events to avoid duplicate mediators being created
			if(_viewRef.selectedIndex == _lastSelectedIndex)
				return;
				
			createTabMediator();
		}
		
	}
}