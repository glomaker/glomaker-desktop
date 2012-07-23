/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.patternmaker
{
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.PatternPluginProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.common.vo.PatternVO;
	import org.glomaker.interfaces.pattern.IPatternMakerBridge;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * Integrates the Pattern Editor module into the main application.
	 * Provides a bridge to the module SWF itself via the shared IPatternMakerBridge interface.
	 * @author Nils
	 */	
	public class PatternMakerMediator extends Mediator
	{
		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		 /**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "PatternMakerMediator";


		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * View instance.
		 * Provides easy typed access to the viewComponent managed by this mediator instance. 
		 */	   
		protected var _viewRef:PatternMakerView;
		

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * Constructor 
		 * @param viewComponent
		 */
		public function PatternMakerMediator( viewComponent:PatternMakerView)
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
			populatePatternMaker();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function onRemove():void
		{
		}		
		

		/**
		 * @inheritDoc 
		 * @return 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			// PatternMaker data -> application save request
			list.push(Notifications.APP_SAVE_DATA);
			
			// Application -> PatternMaker data update request
			list.push(Notifications.APP_REFRESH_DISPLAY);
			
			// done
			return list;
		}
		
		
		/**
		 * @inheritDoc 
		 * @param notification
		 */		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.APP_SAVE_DATA:
					// application requests a data update from pattern maker
					// we comply by sending new data
					updateApplicationData();
					break;
					
				case Notifications.APP_REFRESH_DISPLAY:
					// application has new data - view needs to be updated
					populatePatternMaker();
					break;
			}			
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		
		protected function populatePatternMaker():void
		{
			// populate PatternMaker itself
			// only possible if the associated module has loaded
			var provider:IPatternMakerBridge = _viewRef.getPatternMaker(); 
			
			if(provider)
			{
				// data comes from the PatternMakerProxy
				var pattern:PatternVO = projectProxy.currentPattern;
				
				if(pattern == null)
				{
					return;
				}
				
				var library:Array = pattern.headings;
				var nodes:Array = projectProxy.currentPatternNodes;

				// send to PatternMaker			
				provider.updateData(library, nodes, pattern.allowNodeEditing);
				
				viewRef.setLongDescription(pattern.htmlLongDescription);
				
			}
		}
		
		protected function updateApplicationData():void
		{
			// only possible if the associated module has loaded
			var provider:IPatternMakerBridge = _viewRef.getPatternMaker(); 
			
			if(provider)
			{
				var nodes:Array = provider.getPatternNodes();
				
				// notify application
				sendNotification(Notifications.APP_PATTERN_STOREDATA, nodes);
			}
		}


		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		protected function get viewRef():PatternMakerView
		{
			return viewComponent as PatternMakerView;
		}
		
		protected function get patternProxy():PatternPluginProxy
		{
			return facade.retrieveProxy(PatternPluginProxy.NAME) as PatternPluginProxy;
		}
		
		protected function get projectProxy():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}				

		
	}
}