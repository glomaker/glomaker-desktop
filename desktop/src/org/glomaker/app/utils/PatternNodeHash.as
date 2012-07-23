/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import org.glomaker.interfaces.pattern.IPatternNode;
	
	public class PatternNodeHash
	{
		
		/**
		 * Calc unique hash map value for a node.
		 * The calculation is chosen to return a unique value for each node. 
		 * @param node
		 * @return 
		 */
		static public function calculate(node:IPatternNode):String
		{
			return node.id + "__" + node.func.id + "__" + node.func.heading.id;
		}		

	}
}