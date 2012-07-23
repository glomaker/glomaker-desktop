/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.save
{
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.utils.AIRFileUtils;
	import org.glomaker.app.utils.GLOProjectFileValidator;
	import org.glomaker.common.data.ProjectSettingsVO;
	import org.glomaker.common.data.serialiser.PageInstanceSerialiser;
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Abstract command that provides methods to save the current project.
	 * Your command should extend this class if it needs to save the current project.
	 *  
	 * @author Nils
	 * 
	 */
	public class AbstractSaveCommand extends BaseCommand
	{

		/**
		 * Abstract version of the execute method.
		 * Throws an Error when called - extend the class instead and create a new execute() method. 
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			throw new Error("This command can not be executed - extend the class and implement a new execute() method.");
		}


		/**
		 * Writes the current project to an XML file.
		 * Assumes that 'project.settings.savePath' already contains the correct path to save to.
		 */		
		protected function saveProject(nativePath:String, contentXML:XML):void
		{
			// write to file
			var helper:AIRFileUtils = new AIRFileUtils();
			helper.writeToFile(nativePath, contentXML);
		}
		
		
		/**
		 * Creates an XML object representing the current project. 
		 * @return 
		 */
		protected function createProjectXML():XML
		{
			// make sure current changes have been saved
			sendNotification(Notifications.APP_SAVE_DATA, null, "AbstractSaveCommand::createProjectXML");
			
			// alias to project settings (shorter and avoids 
			var settings:ProjectSettingsVO = project.settings;
			
			// tag for general properties
			var props:XML = <props>
								<w>{settings.stageWidth}</w>
								<h>{settings.stageHeight}</h>
								<rgb>{settings.stageColour}</rgb>
								<pattern>{project.currentPattern.id}</pattern>
								<stageid>{settings.selectedStage.id}</stageid>
							</props>;
			
			// pages
			var nodes:XML = <nodes></nodes>;
			
			var page:PageInstanceVO;
			var pageXML:XML;
			var i:uint;
			
			var serialiser:ISerialiser = new PageInstanceSerialiser();
			
			for(i=0; i < settings.pages.length ; i++)
			{
				page = settings.pages.getItemAt(i) as PageInstanceVO;
				nodes.appendChild(serialiser.serialise(page));
			}

			// piece everything together
			var out:XML = <glo version={configProxy.appVersion} hasFullFilePaths="true"></glo>;
			
			out.appendChild(props);
			out.appendChild(nodes);
			
			// add validation tag so document can be checked
			addValidationTag(out);

			// done			
			return out;			
		}
		
		protected function addValidationTag( content:XML ):void
		{
			var validator:GLOProjectFileValidator = new GLOProjectFileValidator();
			validator.addValidationTag(content);
		}
	}
}