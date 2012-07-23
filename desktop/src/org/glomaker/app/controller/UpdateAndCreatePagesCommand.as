/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;


	/**
	 * Chains the UpdatePatternProxyCommand and the CreatePatternPagesCommand.
	 * Use this command to refresh data stored in the PatternMakerProxy and create project pages based on that data.
	 * The update / page creation is a synchronous operation and doesn't result in further Notifications.
	 *  
	 * @author Nils
	 */
	public class UpdateAndCreatePagesCommand extends MacroCommand
	{
		/**
		 * @inheritDoc 
		 */
		override protected function initializeMacroCommand():void
		{
			super.initializeMacroCommand();
			
			addSubCommand(SavePatternDataCommand);
			addSubCommand(CreatePatternPagesCommand);
		}
		
	}
}