/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.common.vo.PatternVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Updates selected pattern. 
	 * @author Nils
	 */	
	public class SelectPatternCommand extends BaseCommand
	{
		/**
		 * @param notification Body should contain currently selected PatternVO.
		 */
		override public function execute(notification:INotification):void
		{
			var vo:PatternVO = notification.getBody() as PatternVO;
			
			if(!vo)
				throw new Error("Notification body should contain PatternVO instance.");
				
			// store it
			project.setCurrentPattern(vo);
			project.setPatternNodes(vo.defaultNodes);
		}		
	}
}