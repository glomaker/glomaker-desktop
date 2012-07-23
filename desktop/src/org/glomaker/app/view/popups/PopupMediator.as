/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups
{
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.ConfigAwareMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Generic base class for popup view mediators. 
	 * @author Nils
	 */
	public class PopupMediator extends ConfigAwareMediator
	{

		/**
		 * Constructor 
		 * @param mediatorName
		 * @param viewComponent
		 */
		public function PopupMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		

		override public function onRegister():void
		{
			PopUpManager.centerPopUp(viewComponent as IFlexDisplayObject);
		}


		/**
		 * @inheritDoc 
		 * @return 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			list.push( Notifications.APP_CLOSE_ALL_POPUPS );
			
			return list;
		}
		
		
		/**
		 * @inheritDoc 
		 * @param notification
		 */		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			
			switch(notification.getName())
			{
				case Notifications.APP_CLOSE_ALL_POPUPS:
					removePopup();
					break;
			}
		}
		
		/**
		 * Removes the popup and unregisters this mediator instance.
		 * Can be (optionally) called from an event listener. 
		 */		
		protected function removePopup( event:Object = null ):void
		{
			PopUpManager.removePopUp(getViewComponent() as IFlexDisplayObject);
			facade.removeMediator(getMediatorName());
			setViewComponent(null);
		}
		
	}
}