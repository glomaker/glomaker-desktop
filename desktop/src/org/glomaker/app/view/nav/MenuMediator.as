/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.nav
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenuItem;
	
	import mx.controls.FlexNativeMenu;
	import mx.core.Application;
	import mx.events.FlexNativeMenuEvent;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ApplicationStateProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	/**
	 * View Mediator that looks after the main application menu. 
	 * @author Nils
	 */	
	public class MenuMediator extends Mediator
	{
		
		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------
				
		/**
		 * PureMVC identifier 
		 */		
		public static const NAME:String = "MenuMediator";


		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * Constructor 
		 * @param menu Reference to the application's menu.
		 * @constructor
		 */
		public function MenuMediator(menu:FlexNativeMenu)
		{
			super(NAME, menu);
		}


		// ------------------------------------------------------------------
		// PUREMVC INTEGRATION
		// ------------------------------------------------------------------

		/**
		 * @inheritDoc 
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			// intialisation
			if(!appMenu.dataProvider)
				createMenu();
			
			// event listeners
			appMenu.addEventListener(FlexNativeMenuEvent.ITEM_CLICK, onMenuItemClick, false, 0, true);
			appMenu.addEventListener(FlexNativeMenuEvent.MENU_SHOW, onMenuShow, false, 0, true);
		}	
		
		/**
		 * @inheritDoc
		 */		
		override public function onRemove():void
		{
			super.onRemove();
			
			// cleanup
			appMenu.removeEventListener(FlexNativeMenuEvent.ITEM_CLICK, onMenuItemClick);
			appMenu.removeEventListener(FlexNativeMenuEvent.MENU_SHOW, onMenuShow);
		}
		
	
		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------


		/**
		 * Return a typed reference to the view component. 
		 * @return 
		 */		
		protected function get appMenu():FlexNativeMenu
		{
			return viewComponent as FlexNativeMenu;
		}
		
		/**
		 * Retrieves an instance of the ApplicationStateProxy currently registered with the application. 
		 * @return 
		 */		
		protected function get appStateProxy():ApplicationStateProxy
		{
			return facade.retrieveProxy(ApplicationStateProxy.NAME) as ApplicationStateProxy;
		}


		/**
		 * Retrieves an instance of the ProjectSettingsProxy currently registered with the application. 
		 * @return 
		 */		
		protected function get projectProxy():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}
		

		/**
		 * Returns the currently selected application section (patternmaker, designer, player). 
		 * @return 
		 */
		protected function get section():int
		{
			return appStateProxy.selectedSection;
		}
		

		/**
		 * Checks whether or not the application has valid data. 
		 * @return 
		 */
		protected function get hasData():Boolean
		{
			return (projectProxy.currentPatternNodes && projectProxy.currentPatternNodes.length > 0);
		}
		
		/**
		 * Checks whether or not the application is displaying modal windows. 
		 * @return 
		 */		
		protected function get hasModalWindows():Boolean
		{
			// a little bit of a hack
			// allows us to disable the menu when a modal window is being displayed
			try{
				return (Application.application.systemManager.numModalWindows > 0);
			}catch(e:Error){}
			
			// safe default - assume there are no modal windows
			return false;
		}

		
		/**
		 * Create application menu entries and their event listeners
		 * Requires access to the facade - call in or after onRegister() 
		 */		
		protected function createMenu():void
		{
			// define menu structure
			var menuData:XML = <menu/>;

			// file menu
			var child:XML = createItem("File");
			menuData.appendChild(child);
			
			child.appendChild(createItem("New...", Notifications.CONTROLS_NEW));
			child.appendChild(createItem("Open File...", Notifications.CONTROLS_OPEN));
			
			child.appendChild(createSeparator());
			child.appendChild(createItem("Save", Notifications.CONTROLS_SAVE));
			child.appendChild(createItem("Save As...", Notifications.CONTROLS_SAVEAS));
			
			child.appendChild(createSeparator());
			child.appendChild(createItem("Package...", Notifications.CONTROLS_EXPORT));

			child.appendChild(createSeparator());
			child.appendChild(createItem("Exit", Notifications.CONTROLS_EXIT));
				
			// edit menu
			child = createItem("Edit");
			menuData.appendChild(child);
			
			child.appendChild(createEditItem("Cut","x", Notifications.EDIT_CUT));
			child.appendChild(createEditItem("Copy","c", Notifications.EDIT_COPY));
			child.appendChild(createEditItem("Paste","v", Notifications.EDIT_PASTE));

			// view menu
			child = createItem("View");
			menuData.appendChild(child);
			
			child.appendChild(createItem("Planner", Notifications.APP_REQUEST_SHOW_PATTERNMAKER));
			child.appendChild(createItem("Designer", Notifications.APP_REQUEST_SHOW_EDITOR));
			child.appendChild(createItem("Preview", Notifications.APP_REQUEST_SHOW_PLAYER));
			
			/* TAKEN OUT - but keep for debug purposes / future advanced use/
			child.appendChild(createSeparator());
			child.appendChild(createItem("Trace layout", Notifications.CONTROLS_TRACE_LAYOUT));
			child.appendChild(createItem("Trace pattern", Notifications.CONTROLS_TRACE_PATTERN));
			*/

			// settings menu
			child = createItem("Settings");
			menuData.appendChild(child);
			
			child.appendChild(createItem("Edit Stage Settings...", Notifications.CONTROLS_SETTINGS_STAGE));

			// about menu
			child = createItem("About");
			menuData.appendChild(child);
			
			child.appendChild(createItem("About GLOMaker 2", Notifications.CONTROLS_ABOUT_GLOMAKER));
			child.appendChild(createItem("License, Copyright and Credits", Notifications.CONTROLS_ABOUT_LICENSE));
			child.appendChild(createSeparator());
			child.appendChild(createItem("Visit GLOMaker website", Notifications.CONTROLS_ABOUT_WEB));
			

			// apply
			appMenu.dataProvider = menuData;			
		}
		
		
		private function createEditItem(label:String, keyEquivalent:String = null,data:String = null, enabled:String = "true"):XML
		{
			var item:XML = <menuitem/>;
			item.@label = label;
			item.@keyEquivalent = keyEquivalent;
			item.@controlKey = true;
			
			if(data)
				item.@data = data;
				
			if(enabled)
				item.@enabled = enabled;
				
			return item;
		}
		
		private function createItem(label:String, data:String = null, enabled:String = "true"):XML
		{
			var item:XML = <menuitem/>;
			item.@label = label;
			
			if(data)
				item.@data = data;
				
			if(enabled)
				item.@enabled = enabled;
				
			return item;
		}
		
		private function createSeparator():XML
		{
			return <menuitem type="separator"/>
		}
		

		protected function updateMenuItemState( item:NativeMenuItem ):void
		{
			// enable by default
			item.enabled = true;
			
			// item.data is the entire XML instance
			// we extract the 'data' attribute to get the notification name related to the item
			var dataAtribute:String;
			
			if(item.data)
				dataAtribute = String(item.data.@data);
			
			// always disable if there are modal windows
			// exceptions: exit and about menu
			if(hasModalWindows)
			{
				// by default
				item.enabled = false;
				
				// handle exceptions
				switch(dataAtribute)
				{
					case Notifications.CONTROLS_EXIT:
						// allow exit on modal windows only if no file is open
						item.enabled = (projectProxy.currentPattern == null);
			 			return;
					
					case Notifications.CONTROLS_ABOUT_GLOMAKER:
					case Notifications.CONTROLS_ABOUT_WEB:
					case Notifications.CONTROLS_ABOUT_LICENSE:
						item.enabled = true;
						break;
				}

				// done				
				return;
			}
			
			// check which item we are dealing with
			// (there doesn't seem to be an easier way of doing this)			
			switch(dataAtribute)
			{
				// file menu
				case Notifications.CONTROLS_EXPORT:
					// only allow export if valid data is available
					item.enabled = hasData;
					break;

				// view menu				
				// only allow section change if data is available and we're not currently on that section
				case Notifications.APP_REQUEST_SHOW_PATTERNMAKER:
					item.enabled = hasData && (section != ApplicationStateProxy.SECTION_PATTERNMAKER);
					break;
					
				case Notifications.APP_REQUEST_SHOW_EDITOR:
					item.enabled = hasData && (section != ApplicationStateProxy.SECTION_EDITOR);
					break;
					
				case Notifications.APP_REQUEST_SHOW_PLAYER:
					item.enabled = hasData && (section != ApplicationStateProxy.SECTION_PLAYER);
					break;
			}
			
		}
		
		
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		/**
		 * Event handler - user clicked an item in the menu.
		 * These events bubble up from the individual NativeMenuItem instances. 
		 * @param evt
		 */		
		protected function onMenuItemClick(evt:FlexNativeMenuEvent):void
		{
			// the menu item's dataProvider entry has a 'data' attribute
			// that should store the notification name to send when the item is clicked
			var data:String = String(evt.item.@data);
			
			if(data && data != "")
			{
				sendNotification(data);
			}
		}
		
		
		protected function onMenuShow(evt:FlexNativeMenuEvent):void
		{
			// make sure pattern data is up to date
			// (because patternmaker data isn't updated automatically)
			if(section == ApplicationStateProxy.SECTION_PATTERNMAKER)
				sendNotification( Notifications.APP_SAVE_DATA );
				
			// update the actual items about to be shown
			for each(var item:NativeMenuItem in evt.nativeMenu.items)
			{
				updateMenuItemState(item);
			}
			
		}
		
	}
}