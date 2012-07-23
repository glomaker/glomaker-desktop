/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.view.stage
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.component.interfaces.ISlideshowNavigationController;
	import org.glomaker.shared.component.interfaces.ISlideshowNavigator;
	import org.glomaker.shared.component.interfaces.ISlideshowStatusObject;
	import org.glomaker.shared.component.interfaces.ISlideshowStatusReceiver;
	import org.glomaker.webplayer.data.ComponentInstanceVO;
	import org.glomaker.webplayer.events.NavigationEvent;
	import org.glomaker.webplayer.events.PageComponentEvent;
	import org.glomaker.webplayer.hotdraw.PlayerComponentFigure;
	import org.glomaker.webplayer.utils.FigureSerialiser;

	
	public class ComponentDisplayView extends EventDispatcher implements ISlideshowNavigationController
	{
		
		// -----------------------------------------------------
		// Instance Properties
		// -----------------------------------------------------


		/**
		 * Container instance used to display the components.
		 */
		protected var _surface:Container;
		
		
		/**
		 * Figures currently in the display list which are still waiting for their component modules to load. 
		 * These have event listeners attached to them, so we need to keep a record for clean-up purposes.
		 * (:ComponentProxyFigure)
		 */		
		protected var _pendingFigures:Array;
		
		
		/**
		 * List of figures currently being displayed that should receive slideshow status updates.
		 * (:ComponentProxyFigure)
		 */		
		private var _statusReceivers:Array;


		/**
		 * Most recently received status update object.
		 * Stored here so it can be applied to newly loaded components.
		**/
		private var _latestStatusObject:ISlideshowStatusObject;

		
		/**
		 * The shared memory object used by all components
		 */		
		private var  _sharedMemory:Object;
		


		// -----------------------------------------------------
		// Constructor
		// -----------------------------------------------------
		
		/**
		 * Constructor 
		 * @param surface
		 */		
		public function ComponentDisplayView(surface:Container)
		{
			// initialise class
			_pendingFigures = [];
			_statusReceivers = [];
			
			// initialise display surface
			_surface = surface;
			_surface.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, onSurfaceChildAdd);
			_surface.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onSurfaceChildRemove);
		}


		// -----------------------------------------------------
		// Public Methods
		// -----------------------------------------------------
		
		/**
		 * Sets the shared memory object that will be passed to newly added components.
		 * Components already being displayed won't be updated - so call this method before adding the first component. 
		 * @param memoryObject
		 */
		public function setSharedMemory(memoryObject:Object):void
		{
			_sharedMemory = memoryObject;
		}
	
		/**
		 * Sets the size of the canvas
		 * @param width, height
		 */
		public function setSize(width:int,height:int):void
		{
			_surface.setActualSize(width,height);
		}
		

		/**
		 * Add a list of components to the view. 
		 * @param list
		 */		
		public function addComponentList(list:Array):void
		{
		 	for each(var instance:ComponentInstanceVO in list)
				addComponent(instance); 
		}
		
		
		
		/**
		 * Add a single component to the view. 
		 * @param instance
		 * @return The ComponentProxyFigure instance that was created to wrap the instance in.
		 */		
		public function addComponent(instance:ComponentInstanceVO):PlayerComponentFigure
		{
			// create a figure wrapper for it
			var fig:PlayerComponentFigure = new PlayerComponentFigure(instance);
			
			// add it to the Canvas
			// the CHILD_ADD event handler will pick it up and process it further
			_surface.addChild(fig);
			
			return fig;
		}
		
		
		/**
		 * Clear the entire display.
		 * Warning:
		 * Calling this method will remove all the children from the display surface.
		 * Don't call it if you have added other non-component elements that you don't want to be removed.
		 */		
		public function clear():void
		{
			// remove all child elements
			// the CHILD_REMOVE event handler will pick these up and process them further
			_surface.removeAllChildren();
			
			// no more status receivers
			// no event listeners are attached to these, so can simply discared the reference
			_statusReceivers = [];
		}
		
		
		
		
		/**
		 * Handle slideshow status update. 
		 * @param info
		 */
		public function handleSlideshowStatus(info:ISlideshowStatusObject):void
		{
			// save a reference
			_latestStatusObject = info;
			
			// pass it on to all registered receivers
			var receiver:ISlideshowStatusReceiver;
			for each(receiver in _statusReceivers)
			{
				receiver.receiveUpdate(info);
			}
		}
		
		
		/**
		 * Cleanup method
		 * Call before removing references to instances of this class.  
		 */		
		public function destroy():void
		{
			clear();
			
			// clear references
			_latestStatusObject = null;
			setSharedMemory(null);
			
			// remove event listeners
			_surface.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, onSurfaceChildAdd);
			_surface.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onSurfaceChildRemove);			
		}
		
		
		// -----------------------------------------------------
		// ISlideshowNavigationController INTERFACE IMPLEMENTATION
		// -----------------------------------------------------
		
		public function previous():void
		{
			// notify
			dispatchEvent(new NavigationEvent(NavigationEvent.PREVIOUS));
		}
		
		public function next():void
		{
			// notify
			dispatchEvent(new NavigationEvent(NavigationEvent.NEXT));
		}
		
		public function goto(pageIndex:uint):void
		{
			// notify
			var navEvent:NavigationEvent = new NavigationEvent(NavigationEvent.GOTO);
			navEvent.pageIndex = pageIndex;
			
			dispatchEvent(navEvent);
		}
		
		
		// -----------------------------------------------------
		// Protected methods
		// -----------------------------------------------------		
		

		/**
		 * Process a new ComponentProxyFigure instance that was added to the display surface.  
		 * @param fig
		 * @see processRemovedChild()
		 */		
		protected function processNewChild(fig:PlayerComponentFigure):void
		{
			// the figure can be positioned immediately
			var helper:FigureSerialiser = new FigureSerialiser(fig);
			helper.positionFigure();
			
			// hide the figure for now to avoid unsightly jumps while loading
			fig.visible = false;
			
			// components are modules and need to be loaded
			// that might not have happened at this stage
			// any Figures with not-yet-loaded content will become 'pending' figures
			// an event listener will initialise the figure once its content has loaded
			if(fig.hasLoadedContent())
			{
				// already loaded - so we can initialise it
				initialiseNewFigure(fig);
			}else{
				// not yet loaded - this becomes a pending figure
				makePendingFigure(fig);
			}
		}


		/**
		 * Process a figure recently removed from the display list. 
		 * @param fig
		 * @see processNewChild()
		 */		
		protected function processRemovedChild(fig:PlayerComponentFigure):void
		{
			// if the figure was still loading content, it just needs to be removed from the 'pending' list
			// otherwise, further work needs to be done
			
			var index:int = _pendingFigures.indexOf(fig);
			if(index > -1)
			{
				// it's a pending figure
				removePendingFigure(fig, index);
			}else{
				// it's not a pending figure
				cleanupRemovedFigure(fig);
			}
		}


		/**
		 * Initialise a newly added figure. 
		 * @param fig
		 * @see cleanupRemovedFigure()
		 */
		protected function initialiseNewFigure(fig:PlayerComponentFigure):void
		{
			// figure is now ready to be shown
			fig.visible = true;

			// apply component properties
			var helper:FigureSerialiser = new FigureSerialiser(fig);
			helper.applyComponentSettings();
			
			// mouse interaction
			initialiseMouseInteraction(fig);
			
			// get component child
			var child:UIComponent = fig.getContent();

			// initialise component plugin settings and behaviour
			if(child is IComponentPlugin)
			{
				IComponentPlugin(child).setSharedMemory(_sharedMemory);
			}
			
			if(child is ISlideshowNavigator)
			{
				ISlideshowNavigator(child).attachSlideshowController(this);
			}
			
			if(child is ISlideshowStatusReceiver)
			{
				_statusReceivers.push(child);
				
				// send most recent update, if available
				if(_latestStatusObject)
					ISlideshowStatusReceiver(child).receiveUpdate(_latestStatusObject);
			}
		}
		

		/**
		 * Initialises mouseEnabled and mouseChildren settings for a figure and its component child.
		 * Should only be called when the figure's child has loaded.
		 * Default behaviour: mouseEnabled false for figure + child, mouseChildren true for figure + child.
		 * Override in your subclass for different settings. 
		 * @param fig
		 */		
		protected function initialiseMouseInteraction(fig:PlayerComponentFigure):void
		{
			fig.mouseEnabled = false;
			fig.mouseChildren = true;

			var child:UIComponent = fig.getContent();
						
			if(child)
			{
				child.mouseEnabled = false;
				child.mouseChildren = true;
			}
		}


		/**
		 * Cleanup a recently removed, non-pending figure. 
		 * @param fig
		 * @see initialiseNewFigure()
		 */		
		protected function cleanupRemovedFigure(fig:PlayerComponentFigure):void
		{
			// remove component interface functionality
			var child:UIComponent = fig.getContent();
			
			// remove shared memory
			if(child is IComponentPlugin)
			{
				IComponentPlugin(child).setSharedMemory(null);
			}
			
			if(child is ISlideshowNavigator)
			{
				ISlideshowNavigator(child).detachSlideshowController();
			}
			
			if(child is ISlideshowStatusReceiver)
			{
				var index:int = _statusReceivers.indexOf(child);
				if(index > -1)
					_statusReceivers.splice(index, 1);
			}			
		}
		
		
		/**
		 * Add a Figure to the list of those still loading their content module.
		 * @param fig
		 * @see removePendingFigure()
		 */		
		protected function makePendingFigure(fig:PlayerComponentFigure):void
		{
			_pendingFigures.push(fig);
			fig.addEventListener(PlayerComponentFigure.COMPONENT_COMPLETE, onPendingFigureComplete);
			fig.addEventListener(PlayerComponentFigure.COMPONENT_FAILED, onPendingFigureFailed);
		}
		
		
		/**
		 * Remove a Figure from the list of those still loading their content module.
		 * @param fig
		 * @param index [optional] If you already know the index of the figure in the _pending Array, specify it here to save processor time.
		 * @see makePendingFigure()
		 */		
		protected function removePendingFigure(fig:PlayerComponentFigure, index:int = -999):void
		{
			// only recalculate index if not previously supplied
			if(index == -999)
				index = _pendingFigures.indexOf(fig);

			// remove from the Array				
			if(index > -1)
				_pendingFigures.splice(index, 1);
			
			// remove event listeners
			fig.removeEventListener(PlayerComponentFigure.COMPONENT_COMPLETE, onPendingFigureComplete);
			fig.removeEventListener(PlayerComponentFigure.COMPONENT_FAILED, onPendingFigureFailed);
		}
		

		// -----------------------------------------------------
		// Event Listeners
		// -----------------------------------------------------
		
		/**
		 * A new child was added to the display surface.
		 * The child may have been added by this instance or by another process altogether.
		 * @param evt
		 */		
		protected function onSurfaceChildAdd(evt:ChildExistenceChangedEvent):void
		{
			// we only process ComponentProxyFigure instances
			var fig:PlayerComponentFigure = evt.relatedObject as PlayerComponentFigure;
			
			if(fig)
			{
				processNewChild(fig);
				
				// notify
				dispatchEvent(new PageComponentEvent(PageComponentEvent.ADDED, fig.getComponentInstance()));
			}
		}
		
		
		/**
		 * A child was removed from the display surface.
		 * The child may have been removed by this instance or by another process altogether. 
		 * @param evt
		 */		
		protected function onSurfaceChildRemove(evt:ChildExistenceChangedEvent):void
		{
			// we only process ComponentProxyFigure instances
			var fig:PlayerComponentFigure = evt.relatedObject as PlayerComponentFigure;
			
			if(fig)
			{
				processRemovedChild(fig);
				
				// notify
				dispatchEvent(new PageComponentEvent(PageComponentEvent.REMOVED, fig.getComponentInstance()));
			}
		}
		

		/**
		 * Event handler - A figure completed loading module content for its component. 
		 * @param evt
		 */
		protected function onPendingFigureComplete(evt:Event):void
		{
			var fig:PlayerComponentFigure = evt.target as PlayerComponentFigure;
	
			if(fig)
			{
				removePendingFigure(fig);
				initialiseNewFigure(fig);  // <=== [Ref:3X5ZY, Musbah, 02-04-2009]
				
				// notify
				dispatchEvent(new PageComponentEvent(PageComponentEvent.LOADED, fig.getComponentInstance()));
			}
		}
		

		/**
		 * Event handler - A figure failed to load module content for its component. 
		 * @param evt
		 */
		protected function onPendingFigureFailed(evt:Event):void
		{
			var fig:PlayerComponentFigure = evt.target as PlayerComponentFigure;
			
			if(fig)
			{
				removePendingFigure(fig);
				trace("CanvasComponentDisplayView::ERROR - Figure failed to load content. Component id: ", fig.getComponentInstance().component.id);
				
				// notify
				dispatchEvent(new PageComponentEvent(PageComponentEvent.FAILED, fig.getComponentInstance()));
			}
		}

	}
}