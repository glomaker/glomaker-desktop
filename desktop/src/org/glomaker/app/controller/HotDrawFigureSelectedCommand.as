/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.hotdraw.ComponentProxyFigure;
	import org.glomaker.app.model.HotDrawProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	public class HotDrawFigureSelectedCommand extends BaseCommand
	{
		public function HotDrawFigureSelectedCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// body contains selected figure
			var figure:ComponentProxyFigure = notification.getBody() as ComponentProxyFigure;
			
			if(figure)
			{
			 var hdProxy:HotDrawProxy = facade.retrieveProxy(HotDrawProxy.NAME) as HotDrawProxy;
			 hdProxy.currentFigure = figure;
			}
		}
		
		
	}
}