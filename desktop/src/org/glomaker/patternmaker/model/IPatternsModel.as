﻿///////////////////////////////////////////////////////////
//  IBaseModel.as
//  Macromedia ActionScript Implementation of the Interface IBaseModel
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

package org.glomaker.patternmaker.model
{
	import flash.events.*;
	
	import org.glomaker.interfaces.pattern.IPatternFunction;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.patternmaker.data.GlobalPoint;

	/**
	 * @author USER
	 * @version 1.0
	 * @created 06-Nov-2007 13:48:24
	 */
	public interface IPatternsModel extends IBaseModel {
		/**
		     * 
		     * @param value    value
		     */
		     
		function setMenuAndNodes(menu:Array, nodes:Array):void;
		
		function createNode(menuBtnID:String, loc:GlobalPoint, gloPage:XML = null):void;
		
		function getMenuBtnFunc(functionID:String):IPatternFunction;
		
		function getNodeArray():Array;
		
		function getNode(nodeID:String):IPatternNode;
		
		function getNodeHeight():uint;
		
		function setLoc(nodeID:String, loc:GlobalPoint):void;
		
		function getLoc(nodeID:String):GlobalPoint;
		
		function setActive(nodeID:String, active:Boolean):void;
		
		function getActive(nodeID:String):Boolean;
		
		function setReceiver(nodeID:String, active:Boolean):void;
		
		function getReceiver(nodeID:String):Boolean;
		
		function deactivateNodes():void;
		
		function removeNode(nodeID:String):void;

		function extractNode(nodeID:String):void;
		
		function removeAllNodes():void;
		
		function duplicateNode(nodeID:String, loc:GlobalPoint):void;

		function setConnection():void;
		
		function drawLine():void;
		
		function setChild(nodeID:String, childID:String = null):void;

		function getChild(nodeID:String):IPatternNode;

		function setParent(nodeID:String, parentID:String = null):void;

		function getParent(nodeID:String):IPatternNode;
		
		function setActiveSequence(nodeID:String):void;
		
		function getActiveSequence():String;
		
		function getXML():XML;
		
		function setTitleText(nodeID:String, input:String):void;
		
		function setExplainText(nodeID:String, input:String):void;
		
		function set nodeTitleEditing(allowNodeEditing:Boolean):void;
		
		function get nodeTitleEditing():Boolean;
		
		function set nodeExplainEditing(allowNodeEditing:Boolean):void;
		
		function get nodeExplainEditing():Boolean;
		
/*
		function setColour(c:uint):void;

		function getColour():uint;*/

	}//end IPatternsModel

}