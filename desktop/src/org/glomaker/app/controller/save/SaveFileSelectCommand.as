/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.save
{
	
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	

	/**
	 * Stores a newly selected save file path and triggers a save to the application.
	 * @author Nils
	 */
	public class SaveFileSelectCommand extends MacroCommand
	{
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(StoreSaveFilePathCommand);
			addSubCommand(SaveCommand);
		}
		
	}
}