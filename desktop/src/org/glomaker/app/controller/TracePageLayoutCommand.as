/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.app.core.Notifications;
	import org.glomaker.common.data.serialiser.ComponentInstanceSerialiser;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	/**
	 * Traces layout for current page. 
	 * @author Nils
	 */
	public class TracePageLayoutCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// save current page
			sendNotification(Notifications.APP_SAVE_DATA, null, "TracePageLayoutCommand");			
			// get project dimensions
			var sw:Number = project.settings.stageWidth;
			var sh:Number = project.settings.stageHeight;
			
			// get current page reference
			try{
				var page:PageInstanceVO = project.getPageAt(selections.pageIndex);
			}catch(e:Error){
				trace("Trace Page Layout: No page currently defined.");
				return;
			}

			// output title
			trace("<id>" + page.layout.id + "</id>");

			// produce component output
			var compSerialiser:ComponentInstanceSerialiser = new ComponentInstanceSerialiser();
			var compXML:XML;
			
			for each(var comp:ComponentInstanceVO in page.components)
			{
				compXML = compSerialiser.serialise(comp);
				
				// convert to percentages
				compXML.@x = roundString(Number(compXML.@x / sw));
				compXML.@y = roundString(Number(compXML.@y / sh));
				compXML.@width = roundString(Number(compXML.@width / sw));
				compXML.@height = roundString(Number(compXML.@height / sh));
				
				// output
				trace(compXML);
			}
			
		}
		
		protected function roundString(value:Number):String
		{
			return String(Math.round(value * 1000)/1000);
		}
		
	}
}