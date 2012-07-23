/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import com.hotdraw.CH.ifa.draw.standard.StandardDrawingView;
	
	import org.glomaker.app.view.stage.HotdrawAwareComponentDisplayView;
	import org.glomaker.app.view.stage.PageDisplayMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	public class HotdrawViewCanvasCreated extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			var drawingView:StandardDrawingView = notification.getBody() as StandardDrawingView;
			
			if(!drawingView)
				throw new Error("Expecting a com.hotdraw.CH.ifa.draw.framework.DrawingView instance in the notification body");

			// check if another mediator already exists
			if(facade.hasMediator(PageDisplayMediator.NAME))
				throw new Error("Mediator already registered for a DrawingView instance.");
				
			// register a mediator for it			
			facade.registerMediator(new PageDisplayMediator(drawingView));
		}
		
	}
}