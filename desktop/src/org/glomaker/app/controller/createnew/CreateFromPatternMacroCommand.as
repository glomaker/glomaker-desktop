/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.createnew
{
	import org.glomaker.app.controller.SelectPatternCommand;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class CreateFromPatternMacroCommand extends MacroCommand
	{

		override protected function initializeMacroCommand():void
		{
			super.initializeMacroCommand();
			
			addSubCommand(SelectPatternCommand);
			addSubCommand(InitialiseNewProjectCommand);
		}
		
	}
}