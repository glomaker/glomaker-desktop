/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.player
{
	public interface IPlayerBridge
	{

		function setStartPageIndex(value:int):void;
		function setPageList(value:Array):void;
		function setGLOStage(value:Object):void;
		function setBackgroundColour(value:uint):void;
		function init():void;
		function destroy():void;

	}
}