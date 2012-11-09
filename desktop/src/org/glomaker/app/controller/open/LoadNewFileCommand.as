/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.open
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.core.Repeater;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.StateProxy;
	import org.glomaker.app.utils.GLOProjectFileValidator;
	import org.glomaker.app.utils.PropertySerialiser;
	import org.glomaker.common.data.JourneySettingsVO;
	import org.glomaker.common.data.ProjectSettingsVO;
	import org.glomaker.common.data.StageVO;
	import org.glomaker.common.data.serialiser.JourneySettingsSerialiser;
	import org.glomaker.common.data.serialiser.NodeSerialiser;
	import org.glomaker.common.data.serialiser.PageSerialiser;
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.ComponentVO;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.glomaker.common.vo.PageVO;
	import org.glomaker.common.vo.PatternVO;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.shared.properties.FilePathArrayProperty;
	import org.glomaker.shared.properties.FilePathProperty;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Opens a new GLO project file. 
	 * @author Nils
	 */
	public class LoadNewFileCommand extends BaseCommand
	{

		protected static const SLASH_FIX_REGEXP:RegExp = /(\/)/g;
		
		
		/**
		 * @inheritDoc
		 * @param notification Body should contain the File object of the file to open.
		 */
		override public function execute(notification:INotification):void
		{
			// update state - no opening operation is pending anymore
			stateProxy.currentState = StateProxy.STATE_IDLE;
			
			// notification's body should contain the selected file
			var file:File = notification.getBody() as File;
			
			// quick sanity checks
			if(!file)
				throw new Error("Notification body should contain file to open.");

			if(file.extension != configProxy.projectFileExtension)
				throw new Error("File has incorrect extension (" + file.extension + ") - should be " + configProxy.projectFileExtension); 
			

			// remember this as the most recently used file open path (stores the directory)
			configProxy.lastOpenDirectoryURL = file.parent.url;
			
			// read in XML content
			var xml:XML;
			try{
				
				xml = readXML(file);
				
			}catch(e:Error){
				sendNotification(Notifications.OPENFILE_FAILED, "Unable to open file");
				return;
				
			}
			
			// success!
			// validate XML
			if(!xml || !validateProjectXML(xml))
			{
				sendNotification(Notifications.OPENFILE_FAILED, "Invalid project XML format.");
				return;				
			}
			
			
			// if project doesn't have full file paths, we need to convert them
			// the filepaths are the only difference between exported (published) and saved files 
			// @see AbstractSaveCommand and DoProjectExportCommand
			if( xml.attribute("hasFullFilePaths") == "false")
			{
				try{
					convertToFullPaths( xml, file );
				}catch(e:Error){
					sendNotification(Notifications.OPENFILE_FAILED, "Failed to convert file paths.\n" + e.message);

					return;
				}
			}
			
			// received valid project XML
			// apply to existing project
			project.setFilename(file.nativePath);
			
			// apply new data to the project
			try{
				applyData(xml);
			}catch(e:Error){
				
				// at this stage, the stored data is probably corrupt
				// so we clear all of it and revert to default settings
				project.removeAllPages();
				project.setCurrentPattern(null);
				project.setPatternNodes(null);
				
				project.settings.stageWidth = 800;
				project.settings.stageHeight = 600;
				project.settings.stageColour = 0xffffff;				
				
				project.settings.savePathURL = "";
				project.settings.selectedStage = stagePlugins.getSortedStageList()[0] as StageVO;
				
				// notify
				sendNotification(Notifications.OPENFILE_FAILED, "Unable to apply data to current project.");
				return;
			}
			
			// if coming from the startup wizard, the main application is still hidden
			sendNotification(Notifications.APP_SHOW_APPLICATION);
			
			// switch to patternmaker and refresh displayed data
			sendNotification(Notifications.APP_REQUEST_SHOW_PATTERNMAKER);
			sendNotification(Notifications.APP_REFRESH_DISPLAY);
		}
		
		
		/**
		 * Read XML content from file.
		 * @param file
		 * @return 
		 * @throws Error if failed to read.
		 * @throws Error if failed to convert file content to XML. 
		 */		
		protected function readXML(file:File):XML
		{
			// step 1: open the file to read in contents
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			
			// step 2: read in file contents
			var content:Object = stream.readUTFBytes(stream.bytesAvailable);			
			
			// convert to XML
			var asXML:XML = new XML(content);
			
			if(!asXML)
				throw new Error("Unable to convert file contents to XML");
				
			// done
			return asXML;
		}
		
		
		/**
		 * Validates project XML structure. 
		 * @param content
		 * @return 
		 */		
		protected function validateProjectXML(content:XML):Boolean
		{
			var validator:GLOProjectFileValidator = new GLOProjectFileValidator();
			return validator.validateProjectXML(content);
		}
		
		
		/**
		 * Converts filepaths in the XML to fully qualified filepaths.
		 * Assumes that the XML has truncated path information (as would be the case with exported files). 
		 * MARTIN: Problem with packaging and saving where file paths have not been set. Resolved here, issue 233.
		 * @param content
		 * @param file
		 */
		protected function convertToFullPaths( content:XML, file:File ):void
		{
			// see DoProjectExportCommand for naming conventions and logical structure
			// we are basically adding a full path to the filepaths
			var components:XMLList = content..component;
			var pathProperties:XMLList = components..*.(hasOwnProperty("@isPath") && @isPath == "true");
			
			var folderPath:String = file.parent.url + "/"; //File.separator;
			var decoded:*;
			
			for each(var prop:XML in pathProperties)
			{
				// FilePathArrayProperty stores an array of filepaths
				// other properties might store a filepath as a single string
				// we need to handle each case correctly 
				decoded = PropertySerialiser.deserialise( prop );
				
				if( decoded is String )
				{
					// Store changes
					delete prop.children()[0];
					PropertySerialiser.serialise( fixRelativePath( String(decoded), folderPath ), prop );
					
				}else if( decoded is Array ){
					
					var paths:Array = [];
					var path:String;
					for each(path in decoded)
					{
						paths.push( fixRelativePath( path, folderPath ) );
					}
					
					// Store changes
					delete prop.children()[0];
					PropertySerialiser.serialise( paths, prop );
				}
			}
		}
		
		/**
		 * Converts a relative path into an absolute path for the current GLO. 
		 * @param relPath
		 * @param absPathRoot
		 * @return 
		 */		
		protected function fixRelativePath( relPath:String, absPathRoot:String ):String
		{
			// slashes need fixing
			if( relPath && relPath != "" && relPath != FilePathProperty.NO_URL_VALUE )
			{
				// convert to absolute path and fix slashes
				relPath = absPathRoot + relPath;
				relPath = relPath.replace( SLASH_FIX_REGEXP , "/" );
			}
			
			return relPath;
		}
		
		
		
		protected function applyData(projectXML:XML):void
		{
			// quick access alias
			var settings:ProjectSettingsVO = project.settings;
			
			// overall settings
			settings.stageWidth = projectXML.props.w;
			settings.stageHeight = projectXML.props.h;
			settings.stageColour = projectXML.props.rgb;
			
			// journey
			var serialiser:ISerialiser = new JourneySettingsSerialiser();
			settings.journey = projectXML.hasOwnProperty("journey") ? (serialiser.deserialise(projectXML.child("journey")[0]) as JourneySettingsVO) : null;
			
			// project pages
			project.removeAllPages();
			
			var list:XMLList = projectXML.nodes.page;
			var pageXML:XML;
			var pageInstance:PageInstanceVO;
			var patternNodes:Array = [];
			
			for each(pageXML in list)
			{
				pageInstance = createPageInstance(pageXML);
				patternNodes.push(pageInstance.node);
				project.addPageInstance(pageInstance);
			}
			
			// patternmaker
			var pattern:PatternVO = patternPlugins.getPatternById(projectXML.props.pattern);
			project.setCurrentPattern(pattern);
			project.setPatternNodes(patternNodes);
			
			// current stage
			var stageID:String = projectXML.props.stageid;
			var stageVO:StageVO = stagePlugins.getStageByID(stageID);
		
			if(!stageVO)
				throw new Error("No stage plugin found with id " + stageID);
				
			project.settings.selectedStage = stageVO;
		}
		
		/**
		 * @param xmlData
		 * @return 
		 * @throws Error when failed to deserialise parts of the XML.
		 */		
		protected function createPageInstance(xmlData:XML):PageInstanceVO
		{
			// PattherMaker node
			var nodeXML:XML = xmlData.node[0];
			var node:IPatternNode = new NodeSerialiser().deserialise(xmlData.node[0]) as IPatternNode;
			
			if(!node)
				throw new Error("Failed to deserialise pattern node instance.");
				
			// assign the node function (this is left blank by the deserialiser)
			var funcID:String = nodeXML.funcid;
			
			try{
				node.func = patternPlugins.getFunctionById(nodeXML.funcid);
			}catch(e:Error){}
			
			if(!node.func)
				throw new Error("Failed to obtain function for node instance. [" + node.id + "]");
			
			// layout
			var layoutID:String = new PageSerialiser().deserialise(xmlData.layout[0]) as String;
			var layout:PageVO = pagePlugins.getPageByID(layoutID);

			if(!layout)
				throw new Error("Failed to deserialise page layout.");

			// create new instance
			var instance:PageInstanceVO = new PageInstanceVO(layout, node, project.settings.stageWidth, project.settings.stageHeight);
			
			// clear existing components - these will have been pre-created based on the page layout
			instance.removeAllComponents();
			
			// read in components from XML
			var compXML:XML;
			var compID:String;
			var compVO:ComponentVO;
			var compInstance:ComponentInstanceVO;
			for each(compXML in xmlData.component)
			{
				compID = String(compXML.@id);
				compVO = componentPlugins.getComponentById(compID);
				
				if(compVO)
				{
					compInstance = new ComponentInstanceVO(compVO, compXML.toXMLString());
					instance.addComponentInstance(compInstance);
				}else{
					throw new Error("Failed to deserialise component definition.");
				}
			}
			
			// done
			return instance;
		}
		
	}
}