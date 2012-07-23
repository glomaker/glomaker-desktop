/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class SharedMemoryProxy extends Proxy
	{
		/**
		 * PureMVC identifier. 
		 */		
		 
		public static const NAME:String = "SharedMemoryProxy";
		
		public function SharedMemoryProxy()
		{
			super(NAME, /* Shared Memory Object*/ {});
		}
		
		// Return the shared memory object
		public function getSharedMemory():Object{
			return getData();
		}
		
	}
}