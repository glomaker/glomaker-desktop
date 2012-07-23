/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data
{
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.PluginInfoVO;
	
	public class StageVO extends PluginInfoVO
	{
		public var componentInstance:ComponentInstanceVO;

		/**
		 * Override for abstract clone() method.
		**/
		override public function clone():Object
		{
			var vo:StageVO = new StageVO();
			
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
			
			// components
			// we copy these by reference since their properties won't change or be saved
			vo.componentInstance = componentInstance;
			
			// done
			return vo;
		}
		
	}
}