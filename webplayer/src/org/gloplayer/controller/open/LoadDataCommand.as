package org.gloplayer.controller.open
{
	import org.gloplayer.controller.BaseCommand;
	import org.gloplayer.model.PlayerDataProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Opens a new GLO project file. 
	 * @author Nils
	 */
	public class LoadDataCommand extends BaseCommand
	{

		/**
		 * @inheritDoc
		 * @param notification Body should contain the File object of the file to open.
		 */
		override public function execute(notification:INotification):void
		{
			playerDataProxy.url = configProxy.projectPath;
		}
		
		
	}
}