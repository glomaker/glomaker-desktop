/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import flash.utils.Dictionary;
	
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.utils.LinkedPatternNode;
	import org.glomaker.app.utils.PatternNodeHash;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.glomaker.common.vo.PageVO;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Creates GLOMaker pages to represent the current pedagogical pattern, as stored in the PatternMakerProxy instance.
	 * 
	 * You should run the UpdatePatternProxyCommand first to make sure data is up to date.
	 * Ideally, use UpdateAndCreatePagesCommand() instead, which chains these operations.
	 * 
	 * Can be run with any notification, name/body/type not relevant.
	 * The page creation process is a synchronous operation.
	 *  
	 * @author Nils
	 * @see org.glomaker.app.controller.UpdateAndCreatePagesCommand
	 */	
	public class CreatePatternPagesCommand extends BaseCommand
	{

		// a lot of PatternMakerProxy access is required
		// we save a reference to it to avoid repeated 'getter' lookups
		private var _projectProxy:ProjectSettingsProxy;


		/**
		 * Execute the command.
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{
			// efficient access to the ProjectSettingsProxy (avoids repeated lookups)
			// this is done here since the facade is not yet accessible in the constructor
			// stored as a class property so it's accessible to all methods
			_projectProxy = project;

			// data is known to be reliable
			// get the current pattern nodes
			// this is an array of IPatternNode instances
			var pedagogicals:Array = _projectProxy.currentPatternNodes;

			if(pedagogicals == null || pedagogicals.length == 0)
			{
				// no data is available
				project.removeAllPages();
				return;
			}

			// the aim is to preserve existing page content wherever possible
			// we create a lookup hash map from the existing pages
			// it will be used to match nodes from the pedagogical array to existing page instances
			var pageCache:Dictionary = new Dictionary();
			var pages:Array = project.settings.pages.toArray();
			var pageInstance:PageInstanceVO;
			
			for each (pageInstance in pages)
			{
				pageCache[PatternNodeHash.calculate(pageInstance.node)] = pageInstance;
			}
			
			// clear all pages from project
			// these will be refilled to match the new sequence
			project.removeAllPages();
			
			// the pedagogical sequence is stored as an array but is actually a linked list
			var linkedNode:LinkedPatternNode = LinkedPatternNode.createLinkedList(pedagogicals);
			
			while(linkedNode)
			{
				addPageForNode(linkedNode.node, pageCache);
				linkedNode = linkedNode.child;
			}
		}
		
		
		/**
		 * Adds a page instance to the project for a specific node.
		 * The page instance will be taken from the cache if possible - otherwise, a new one will be created.
		 * @param node
		 * @param pageCache
		 */		
		protected function addPageForNode(node:IPatternNode, pageCache:Dictionary):void
		{
			// first, check if there is an existing page for this node
			var hash:String = PatternNodeHash.calculate(node);
			var pageInstance:PageInstanceVO = pageCache[hash] as PageInstanceVO;
			
			if(pageInstance)
			{
				// update the node instance stored in the page
				pageInstance.node = node;
			}else{

				// no pageInstance was found in the cache
				// to create one, we have to pick the correct page layout first
				var page:PageVO;
	
				// the node can define the layout it would like to use
				if(node.layoutId)
				{
					page = pagePlugins.getPageByID(node.layoutId);
					
					if(!page)
						trace("CreatePatternPagesCommand::Error - Specified page layout not found (id: " + node.layoutId + ")");
				}
	
				// or we fall back to the defaul layout defined by the node's function
				if(!page && node.func.defaultLayoutId)
				{
					page = pagePlugins.getPageByID(node.func.defaultLayoutId);
					
					if(!page)
						trace("CreatePatternPagesCommand::Error - No default layout found (id: " + node.func.defaultLayoutId + ")");
				}
				
				// if both of these are undefined, we'll have to assign a layout ourselves
				if(!page)
				{
					page = pagePlugins.getLayouts()[0];
				}
				
	
				// final check
				if(!page)
				{
					trace("CreatePatternPages - Error, failed to allocate page layout for node.");
					return;
				}
	
				// have valid page - create an instance for it
				pageInstance = new PageInstanceVO(page, node, project.settings.stageWidth, project.settings.stageHeight);
			}
			
			// add it to the project
			if(pageInstance)
				project.addPageInstance(pageInstance);			
		}
		
	}
}