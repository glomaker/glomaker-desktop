/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.vo
{
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.interfaces.pattern.PatternNode;
	import org.glomaker.patternmaker.data.GlobalPoint;
	
	public class PatternVO extends PluginInfoVO
	{
		
		/**
		 * Allow users to edit nodes in PatternMaker?
		 * If set to true, users will be able to edit a node's title/description text. 
		 */		
		public var allowNodeEditing:Boolean = false;
		
		
		/**
		 * Long description / help text for this pattern.
		 * Empty ("") by default.
		 * Will store html text. 
		 */
		public var htmlLongDescription:String = "";


		/**
		 * Library definition.
		 * Stores IPatternHeading instances. 
		 */		
		public var headings:Array = [];

		
		/**
		 * Storage for the defaultNodes array. 
		 */		
		private var _defaultNodes:Array = [];
		
		
		/**
		 * Returns a COPY of the default nodes array.
		 * The array stores IPatternNode instances.
		 * @return 
		 */		
		public function get defaultNodes():Array
		{
			// create a copy
			var list:Array = [];
			var node:IPatternNode;
			for each(node in _defaultNodes)
			{
				list.push(copyNode(node));
			}
			
			// done
			return list;
		}
		
		/**
		 * Sets the default nodes that should be created for this pattern.
		 * The array stores IPatternNode instances. 
		 * @param value
		 */		
		public function set defaultNodes(value:Array):void
		{
			_defaultNodes = value;
		}
		
		
		/**
		 * Override for abstract clone() method.
		**/
		override public function clone():Object
		{
			var vo:PatternVO = new PatternVO();
			
			// PluginInfoVO properties
			vo.author = author;
			vo.description = description;
			vo.glomakerVersion = glomakerVersion;
			vo.id = id;
			vo.name = name;
			vo.pluginURL = pluginURL;
			vo.iconURL = iconURL;
			vo.type = type;
			vo.version = version;
			
			// custom properties
			vo.headings = headings.concat();
			vo.defaultNodes = defaultNodes;
			
			// done
			return vo;
		}
		
		
		/**
		 * Creates a copy of an IPatternNode. 
		 * @param source
		 * @return 
		 */		
		protected function copyNode(source:IPatternNode):IPatternNode
		{
			var copy:IPatternNode = new PatternNode(source.id, source.func, source.title, source.description);
			
			//
			copy.loc = new GlobalPoint(source.loc.x, source.loc.y);
			copy.parentId = source.parentId;
			copy.childId = source.childId;
			copy.isRoot = source.isRoot;
			copy.layoutId = source.layoutId;
					
			// done
			return copy;
		}	

	}
}