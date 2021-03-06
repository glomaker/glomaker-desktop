﻿//  IController.as
//  Macromedia ActionScript Implementation of the Interface IController
//  Generated by Enterprise Architect
//  Created on:      06-Nov-2007 13:48:24
//  Original author: USER
///////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.controller
{
	import org.glomaker.patternmaker.data.GlobalPoint;
	
	import flash.events.*;
	import flash.geom.Point;
	/**
	 * @author USER
	 * @version 1.0
	 * @created 06-Nov-2007 13:48:24
	 */
	public interface IController
	{
		/**
		 * 
		 * @param e
		 * @param loc
		 * 
		 */
		function menuBtnHandler(e:MouseEvent, loc:GlobalPoint):void;

	}//end IController

}