package com.hotdraw.CH.ifa.draw.standard
{
	import com.hotdraw.CH.ifa.draw.framework.DrawingView;
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	public class DeleteFigureCommand extends DeleteCommand
	{
		private var figure:Figure;
		public function DeleteFigureCommand(name:String, view:DrawingView, fig:Figure)
		{
			super(name, view);
			figure = fig;
		}
		
	override public function execute():void {
    	Alert.yesLabel = "Yes";
    	Alert.noLabel = "No";		
		Alert.show("Do you want to delete this Component?", "Warning!",Alert.YES | Alert.NO,null,alertListener, null, Alert.YES);

    }
    
     private function alertListener(eventObj:CloseEvent):void             {
                // Check to see if the OK button was pressed.
                if (eventObj.detail==Alert.YES) {
                    fView.removeFromSelection(figure);
        			fView.drawing().remove(figure);
        			fView.checkDamage(); 
                }
            }
		
	}
}