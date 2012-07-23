/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.export
{
	import com.adobe.serialization.json.JSON;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import org.glomaker.app.controller.save.AbstractSaveCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.StateProxy;
	import org.glomaker.app.utils.PropertySerialiser;
	import org.glomaker.common.data.StageVO;
	import org.glomaker.common.vo.ComponentVO;
	import org.glomaker.shared.properties.FilePathProperty;
	import org.puremvc.as3.multicore.interfaces.INotification;
	


	/**
	 * Exports the current project to a specified directory.
	 * 
	 * @todo File contains lots of hard-coded path information.
	 *  
	 * @author Nils
	 */
	public class DoProjectExportCommand extends AbstractSaveCommand
	{	
		private static var _count:int = 0;

		override public function execute(notification:INotification):void
		{
			// reset state - no operations pending anymore
			stateProxy.currentState = StateProxy.STATE_IDLE;
			
			// body should contain the export directory (:File)
			var exportDir:File = notification.getBody() as File;
			
			if(!exportDir)
				throw new Error("Notification body must contain export directory (:File)");
			
			// make sure export directory exists
			if(!exportDir.exists)
			{
				sendNotification( Notifications.EXPORT_FAILED, "Specified export directory doesn't exist. (" + exportDir.nativePath + ")");
				return;
			}

			// try to run the export
			// various things go wrong - we intercept these as exceptions and send an EXPORT_FAILED notification as a result			
			
			var tmpDir:File;
			
			try{
				
				tmpDir = doExportToTemp( notification.getBody() as File );
				
				// copy the contents to the export directory
				// files will be copied one-by-one, so that the rest of the folder contents remain unchanged
				// it's too risky to just overwrite the entire contents - imaging if it's the C: drive!
				copyTempFiles( tmpDir, exportDir );
				
				// done
				sendNotification( Notifications.EXPORT_COMPLETE );
				
			}catch(e:Error){
				
				sendNotification( Notifications.EXPORT_FAILED, e.message );
				
			}finally{

				// delete the temporary directory
				if(tmpDir)				
					tmpDir.deleteDirectory(true);

			}
		}
		
		
		/**
		 * Export the project. 
		 * @param exportDir
		 * @throws Exception if anything went wrong.
		 * @return Returns a reference to the temporary directory created to store the exported project.
		 */		
		protected function doExportToTemp( exportDir:File ):File
		{
			
			// process:
			// - create a temporary directory
			// - export the project to that directory
			// - copy everything across to the output directory
			
			var tmpDir:File = File.createTempDirectory();

			if(!tmpDir || !tmpDir.exists)
				throw new Error("Unable to create temporary directory for export.");
			
			// copy skeleton directory structure
			copyExportSkeleton(tmpDir);

			// do the export
			var xmlData:XML = createProjectXML();
			
			// we are going to truncate filepaths
			xmlData.@hasFullFilePaths = "false";
			
			// collect all components
			var comps:XMLList = xmlData..component;
			
			// copy all file assets
			copyAssetFiles(comps, tmpDir);

			// save amended XML to project file
			addValidationTag( xmlData ); // must revalidate after making changes
			saveProject(tmpDir.resolvePath("project.glo").url, xmlData);
			
			// copy all plugins used
			// the SWF files will be named using the component ID values
			var pluginDir:File = tmpDir.resolvePath("plugins");
			pluginDir.createDirectory();
			
			var comp:XML;
			var compID:String;
			var compVO:ComponentVO;
			var compFile:File;
			var done:Dictionary = new Dictionary();
			
			for each(comp in comps)
			{
				compID = comp.@id;
				if(done[compID] == null)
				{
					done[compID] = 1;
					compVO = componentPlugins.getComponentById(compID);
					compFile = new File(compVO.swfNativePath);
					
					if(compFile && compFile.exists)
					{
						compFile.copyTo(pluginDir.resolvePath(compID + "_plugin.swf"));
					}else{
						// @todo - implement correct error checking
						throw( new Error("Unable to copy component file for export. [" + compVO.id + "]") );
					}
				}
			}
			
			// copy the stage swf
			copyStageSWF(pluginDir);
			
			// copy the player
			copyPlayerSWF(tmpDir);
			
			// done
			return tmpDir;
		}
		
		/**
		 * Issue 226 fixed.  
		 * @param comps
		 * @param exportDir
		 * 
		 */		
		protected function copyAssetFiles(comps:XMLList, exportDir:File):void
		{
			var assetList:XMLList = comps..*.(attribute("isPath")=="true");
			var assetListCopy:XMLList = assetList.copy();
			// 
			var assetXML:XML;

			var assetDir:File = exportDir.resolvePath("content");
			assetDir.createDirectory();

			var deserialised:Object;
			var newFileName:String;
			var i:uint;
			
			
			for each(assetXML in assetList)
			{
				try{
					// convert assetXML to an actual object
					deserialised = PropertySerialiser.deserialise(assetXML);
					// this should be either a string or an array
					if(deserialised is String && deserialised !="")
					{
						newFileName = copyAsset(deserialised as String, assetDir);

						if(newFileName)
						{
							deserialised = "content/" + newFileName;
						}
						
					}else if(deserialised is Array){
						
						for(i=0;i<deserialised.length;i++)
						{
							newFileName = copyAsset(deserialised[i], assetDir);
							
							if(newFileName)
							{
								deserialised[i] = "content/" + newFileName;
							}
						}
					}
					
					// serialise it again and add to xml
					delete assetXML.children()[0];
					// PropertySerialiser.serialise( deserialised, assetXML );  Add unneccessary code (i.e &lt;![CDATA["content/origin_female_voice.mp3"]]&gt;)
					// It's done manulay here by Musbah, 03-July 2009
					assetXML.appendChild(JSON.encode(deserialised));
					
				}catch(e:Error){
					trace("Failed to encode XML");
				}
			}
		}
		
		/**
		 * Copies a single asset 
		 * @param path
		 * @param assetDir
		 * @return null if copy failed, asset filename otherwise
		 */		
		protected function copyAsset(path:String, assetDir:File):String
		{
			var assetFile:File = new File( path );
			var assetName:String = assetFile.name;
			var assetXML:XML;
			
			
			if(assetFile && assetFile.exists)
			{
				if(!assetDir.resolvePath(assetName).exists)
				{
					assetFile.copyTo(assetDir.resolvePath(assetName));
						
				}	
				return assetName;
			}
			
			return null;
		}
		
		protected function copyExportSkeleton(destinationDir:File):void
		{
			// copy skeleton directory
			var skeletonDir:File = File.applicationDirectory.resolvePath("appdata" + File.separator + "export");
			
			if(!skeletonDir.exists)
				throw new Error("Skeleton application directory not found");
				
			// copy each element inside the directory
			for each(var f:File in skeletonDir.getDirectoryListing())
				f.copyTo(destinationDir.resolvePath(f.name), true);
		}
		
		
		protected function copyStageSWF(destinationDir:File):void
		{
			var stageVO:StageVO = project.settings.selectedStage;
			var stageFile:File = new File(stageVO.componentInstance.component.swfNativePath);
			
			if(stageFile && stageFile.exists)
			{
				stageFile.copyTo(destinationDir.resolvePath(stageVO.id + "_stage.swf"));
			}else{

				throw Error("Unable to copy stage SWF.");
			}

		}
		
		protected function copyPlayerSWF(destinationDir:File):void
		{
			var playerFile:File = File.applicationDirectory.resolvePath("org" + File.separator + "glomaker" + File.separator + "webplayer" + File.separator + "GloWebPlayer.swf");
			playerFile.copyTo(destinationDir.resolvePath("GloWebPlayer.swf"), true);
		}
		
		protected function copyTempFiles( tmpDir:File, exportDir:File):void
		{
			// copy each element inside the directory
			// that way, only existing files will be overwritten but the rest of the directory remains unchanged
			for each(var f:File in tmpDir.getDirectoryListing())
				f.copyTo(exportDir.resolvePath(f.name), true);			
		}
		
	}
}