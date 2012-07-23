/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.app.core.Notifications;
	import org.glomaker.common.data.serialiser.NodeSerialiser;
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.interfaces.pattern.IPatternFunction;
	import org.glomaker.interfaces.pattern.IPatternHeading;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	/**
	 * Traces sequence for current pattern. 
	 * @author Nils
	 */
	public class TracePatternSequenceCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// make sure pattern data is up-to-date
			sendNotification(Notifications.APP_SAVE_DATA, null, "TracePatternSequenceCommand");		

			// header
			trace("PatternTrace: <id>" + project.currentPattern.id + "</id>");
			
			// get current sequence list
			var sequence:Array = project.currentPatternNodes;
			
			var n:IPatternNode;
			var h:IPatternHeading;
			var f:IPatternFunction;
			
			var nodeSerialiser:ISerialiser = new NodeSerialiser();
			
			for each(n in sequence)
			{
				trace(nodeSerialiser.serialise(n).toXMLString());
			}
		}
		
	}
}