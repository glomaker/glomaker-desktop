/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	
	import org.glomaker.hotdraw.ComponentProxyFigure;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;


	/**
	 * Stores hotdraw state
	 * 
	 * @author Nils
	 * 
	 */	
	 
	public class HotDrawProxy extends Proxy
	{
		

		/**
		 * PureMVC identifier 
		 */		
		public static const NAME:String = "HotDrawStateProxy";
		
		private var cFigure:ComponentProxyFigure = null; 
		/**
		 * Constructor 
		 * @param proxyName
		 * 
		 */		
		
		public function HotDrawProxy()
		{
			super(NAME, null);
		}
		
		public function get currentFigure():ComponentProxyFigure{
			return cFigure;
		}
		
		public function set currentFigure(fig:ComponentProxyFigure):void{
			cFigure = fig;
		}
		
	}
}