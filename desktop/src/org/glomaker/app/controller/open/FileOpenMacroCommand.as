/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.open
{
	import org.glomaker.app.controller.state.SetOpenPendingCommand;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;


	/**
	 * Handles a 'File Open' from the user.  
	 * @author Nils
	 */
	public class FileOpenMacroCommand extends MacroCommand
	{

		override protected function initializeMacroCommand():void
		{
			super.initializeMacroCommand();
			
			addSubCommand(SetOpenPendingCommand);
			addSubCommand(PromptSaveBeforeOpenCommand);
		}
		
	}
}