/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{

	/**
	 * Interface used to communicate with the PatternMaker application.
	 * Load in PatternMaker SWF and cast it to this interface.
	 * @author Nils
	 */
	public interface IPatternMakerBridge
	{

		/**
		 * Returns an Array of IPatternNode instances describing the current pattern. 
		 * @return 
		 */
		function getPatternNodes():Array;
		
		/**
		 * Updates data displayed in the PatternMaker. 
		 * @param library List of IPatternLibraryItem instances defining the left-hand-side function library.
		 * @param nodes List of nodes currently defined (IPatternNode instances)
		 * @param allowNodeEditing [optional, default: false] Allow the user to edit node label and description?
		 */		 
		function updateData(library:Array, nodes:Array, allowNodeEditing:Boolean = false):void;

	}
}