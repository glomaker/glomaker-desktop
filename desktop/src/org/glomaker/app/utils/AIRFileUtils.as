/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	

	/**
	 * Provides helper functions for writing to the file system.
	 * @author Nils
	 */
	public class AIRFileUtils
	{
		
		/**
		 * Writes text content to a particular file. 
		 * @param filePath
		 * @param content
		 */		
		public function writeToFile(filePath:String, content:String):void
		{
			var file:File = new File(filePath);
			
			if(!file)
				throw new Error("Unable to create file for ", filePath);
				
			//
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(content);
			stream.close();
		}
		
		
	}
}