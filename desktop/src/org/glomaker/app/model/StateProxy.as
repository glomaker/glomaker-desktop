/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;


	/**
	 * Stores current application state. 
	 * @author Nils
	 */
	public class StateProxy extends Proxy
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * PureMVC Identifier 
		 */
		public static const NAME:String = "StateProxy";
		
		
		/**
		 * State definition - no state. 
		 */		
		public static const STATE_NONE:uint = 0;
		
		/**
		 * State definition - startup sequence in progress. 
		 */		
		public static const STATE_STARTUP:uint = 1;
		
		
		/**
		 * State definition - startup complete, application running normally. 
		 */		
		public static const STATE_IDLE:uint = 2;
		
		
		/**
		 * State definition - exit operation is pending. 
		 * Set by application while final save is in progress.
		 */		
		public static const STATE_EXIT_PENDING:uint = 3;
		
		
		/**
		 * State definition - new file open operation is pending. 
		 * Set by application while pre-open save is in progress.
		 */		
		public static const STATE_OPEN_PENDING:uint = 4;
		
		
		/**
		 * State definition - new file creation operation is pending. 
		 * Set by application while pre-create-new save is in progress.
		 */		
		public static const STATE_CREATE_PENDING:uint = 5;
		
		
		/**
		 * State definition - project export operation is pending. 
		 * Set by application while pre-export save is in progress.
		 */		
		public static const STATE_EXPORT_PENDING:uint = 6;
		
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 */		
		public function StateProxy()
		{
			super(NAME, STATE_NONE);
		}


		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------

		/**
		 * Change current state 
		 * @param value
		 */
		public function set currentState(value:uint):void
		{
			setData(value);
		}
		
		/**
		 * Read current state 
		 * @return 
		 */
		public function get currentState():uint
		{
			return getData() as uint;
		}
		
		/**
		 * Is an exit operation pending? 
		 * @return 
		 */
		public function get isExitPending():Boolean
		{
			return (currentState == STATE_EXIT_PENDING);
		}
		
		/**
		 * Is a new file open pending? 
		 * @return 
		 */
		public function get isOpenPending():Boolean
		{
			return (currentState == STATE_OPEN_PENDING);
		}
		
		/**
		 * Is a create new project pending? 
		 * @return 
		 */
		public function get isCreatePending():Boolean
		{
			return (currentState == STATE_CREATE_PENDING);
		}
		
		/**
		 * Is a project export pending? 
		 * @return 
		 */
		public function get isExportPending():Boolean
		{
			return (currentState == STATE_EXPORT_PENDING);
		}
		
	}
}