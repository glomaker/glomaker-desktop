package org.gloplayer.controller.startup
{
	import org.gloplayer.controller.BaseCommand;
	import org.gloplayer.core.GLOPlayerMediator;
	import org.gloplayer.view.player.PlayerView;
	import org.gloplayer.view.player.PlayerViewMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Creates Mediator instances for the application and registers them with the facade. 
	 * @author Nils
	 */	
	public class InitialiseMediatorsCommand extends BaseCommand
	{
		/**
		 * @inheritDoc 
		 * @param notification Expects the main application instance in the Body.
		 */
		override public function execute(notification:INotification):void
		{
			var appRef:GloWebPlayer = notification.getBody() as GloWebPlayer;
			
			// test correct body
			if(!appRef)
				throw new Error("Notification body must be the main application instance.");
			
			// mediator for the main application
			// all other mediators are added by this class when startup has completed
			facade.registerMediator(new GLOPlayerMediator(appRef));
			facade.registerMediator(new PlayerViewMediator(appRef.playerView as PlayerView));
		}
		
	}
}