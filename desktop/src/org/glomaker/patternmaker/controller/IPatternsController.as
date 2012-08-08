﻿///////////////////////////////////////////////////////////
//  IController.as
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
	import flash.events.*;
	import flash.geom.Point;
	
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.patternmaker.data.GlobalPoint;

	/**
	 * @author USER
	 * @version 1.0
	 * @created 06-Nov-2007 13:48:24
	 */
	public interface IPatternsController extends IController
	{
	    /**
	     * 
	     * @param e    e
	     */

		
		function setActiveNode(active:Boolean = false, nodeID:String = null):void;
		
		function setConnection():void;
		
		// function setDrag(draggable:Boolean, nodeID:String = null):void;
		
		function setReceiver(receiving:Boolean = false, nodeID:String = null):void;
		
		function drawLine():void;
		
		function setLoc(nodeID:String, loc:GlobalPoint):void;
		
		function removeNode(nodeID:String):void;
		
		function extractNode(nodeID:String):void;
		
		function removeAllNodes():void;
		
		function duplicateNode(nodeID:String):IPatternNode;
		
		function fileHandler(action:String, filePath:String = null):void;
		
		// function buildInstance():void;
		
		function makeActiveSequence(nodeID:String):void;
		
		function setTitleText(nodeID:String, input:String):void;
		
		function setExplainText(nodeID:String, input:String):void;
		
		function setImportType(type:String):void;
		
		function setGLO_manifest(manifest:XML):void;
		

	}//end IPatternsController

}