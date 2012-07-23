/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Cleans up proxy settings after the Editor section has been removed / left.
	 * Triggered via a Notification sent by the EditorMediator's 'onRemove()' method. 
	 * @author Nils
	 */	
	public class CleanupAfterEditorRemovalCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// reset the current page
			selections.reset();
		}
		
	}
}