package org.gloplayer.controller.startup
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
			addSubCommand(InitialiseMediatorsCommand);
			//addSubCommand(RunStartupSequenceCommand);
		}
		
	}
}