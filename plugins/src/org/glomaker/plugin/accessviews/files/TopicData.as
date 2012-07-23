/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.accessviews.files
{
	public class TopicData
	{
		
		public var id:String;
		
		public var data:String;
		
		public function TopicData(data:String,id:String)
		{
			this.id=id;
			this.data = data;
		}

	}
}