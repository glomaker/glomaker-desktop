/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.common.vo.PageInstanceVO;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Duplicates a page based on the reference and new nodes passed in the notification.
	 * 
	 * @author Haykel
	 */	
	public class DuplicatePageCommand extends BaseCommand
	{
		/**
		 * Execute the command.
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{
			var nodes:Array = notification.getBody() as Array;
			if (!nodes || nodes.length != 2)
				return;
			
			var refNode:IPatternNode = nodes[0] as IPatternNode;
			var newNode:IPatternNode = nodes[1] as IPatternNode;
			if (!refNode || !newNode)
				return;
			
			var pages:Array = project.settings.pages.toArray();
			var refPageInstance:PageInstanceVO;
			var newPageInstance:PageInstanceVO;
			
			for each (var pageInstance:PageInstanceVO in pages)
			{
				if (pageInstance.node == refNode)
					refPageInstance = pageInstance;
				else if (pageInstance.node == newNode)
					newPageInstance = pageInstance;
			}
			
			// Reference node has no page and will be created from layout: same will be done for new node.
			// New node has already a page: nothing to do.
			if (!refPageInstance || newPageInstance)
				return;
			
			project.addPageInstance(refPageInstance.clone(newNode));
		}
	}
}