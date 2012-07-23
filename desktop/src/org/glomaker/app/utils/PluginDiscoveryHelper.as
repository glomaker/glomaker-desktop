/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import flash.filesystem.File;

	public class PluginDiscoveryHelper
	{
		
		// ----------------------------------
		// STATIC PROPERTIES
		// ----------------------------------
		
		/**
		 * Default plugin info XML filename. 
		 */		
		public static const DEFAULT_XML_FILE:String = "info.xml";

		

		// ----------------------------------
		// INSTANCE PROPERTIES
		// ----------------------------------

		private var _sourceDir:File;
		private var _infoXMLName:String;


		// ----------------------------------
		// CONSTRUCTOR
		// ----------------------------------


		/**
		 * Constructor 
		 * @param sourceDir
		 * @param infoXMLName (optional, default: DEFAULT_XML_FILE) Filename (without path) for plugin information XML file.
		 */		
		public function PluginDiscoveryHelper(sourceDir:File, infoXMLName:String = DEFAULT_XML_FILE)
		{
			if(!(sourceDir.isDirectory && sourceDir.exists))
				throw new Error("sourceDir must be a directory and must exist");
				
			// save
			_sourceDir = sourceDir;
			_infoXMLName = infoXMLName;
		}
		
		
		// ----------------------------------
		// PUBLIC METHODS
		// ----------------------------------
		
		
		/**
		 * Discovery plugin information files.
		 * @returns Array of File instances.
		 */		
		public function discoverPluginInfoFiles():Array
		{
			// storage
			var fileList:Array = [];
			
			// get listing and cycle through each sub-directory
			var dirList:Array = _sourceDir.getDirectoryListing();
			
			// grab all the directories that have a plugin information XML file
			var pendingFile:File;
			var checkFile:File;
			
			for each(checkFile in dirList)
			{
				if(checkFile.isDirectory)
				{
					pendingFile = checkFile.resolvePath(_infoXMLName);
					if(pendingFile.exists)
					{
						fileList.push(pendingFile);
					}
				}
			}
			
			// done
			return fileList;
		}
		
	}
}