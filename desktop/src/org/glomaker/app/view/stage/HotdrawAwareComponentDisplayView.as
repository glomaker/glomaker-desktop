/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.stage
{
	import com.hotdraw.CH.ifa.draw.standard.StandardDrawingView;
	
	import mx.core.UIComponent;
	
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.hotdraw.ComponentProxyFigure;
	
	
	public class HotdrawAwareComponentDisplayView extends ComponentDisplayView
	{
		
		// ***************
		// INSTANCE PROPERTIES
		// ***************
		
		/**
		 * Constructor 
		 */		
		public function HotdrawAwareComponentDisplayView(drawingView:StandardDrawingView)
		{
			super(drawingView);
		}
		
		protected function get drawingView():StandardDrawingView
		{
			return _surface as StandardDrawingView;
		}
		

		// ***************
		// PUBLIC METHODS
		// ***************
		
		/**
		 * Removes all components from page. 
		 */		
		override public function clear():void
		{
			super.clear();
			
			// clear the drawing view
			drawingView.clearHandles();
			drawingView.drawing().removeAll();
		}		
		
		
		/**
		 * Add a component directly to the current page. 
		 * @param component
		 * @param settings
		 */
		override public function addComponent(def:ComponentInstanceVO):ComponentProxyFigure
		{
			var fig:ComponentProxyFigure = super.addComponent(def);
			
			// add to hotdraw
			drawingView.drawing().add(fig);
			
			// done
			return fig;
		}
		
		
		/**
		 * MouseEnabled / mouseChildren settings for newly added figures.
		 * Overrides default behaviour by setting all properties to false.
		 * @param fig
		 * @inheritDoc
		 */		
		override protected function initialiseMouseInteraction(fig:ComponentProxyFigure):void
		{
			// no 'super' call - we complete override behaviour
			// mouse enabled properties need to be different to allow for HotDraw interaction
			fig.mouseEnabled = false;
			fig.mouseChildren = false;

			var child:UIComponent = fig.getContent();
						
			if(child)
			{
				child.mouseEnabled = false;
				child.mouseChildren = false;
			}
		}
		
	}
}