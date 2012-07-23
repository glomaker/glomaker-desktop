/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.controller.startup
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Carries out PureMVC application startup. 
	 * @author Nils
	 */	
	public class AppStartupMacroCommand extends MacroCommand
	{
		
		/**
		 * @inheritDoc 
		 */		
		override protected function initializeMacroCommand():void
		{
			super.initializeMacroCommand();
			
			addSubCommand(InitialiseProxiesCommand);
			addSubCommand(InitFlashvarsCommand);
			
			addSubCommand(InitialiseMediatorsCommand);
			addSubCommand(LoadDataCommand);
		}
		
	}
}