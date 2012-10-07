package org.glomaker.plugin.dragdrop
{
	import flash.events.Event;
	
	import mx.controls.TextArea;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	/**
	 * An extension of TextArea that automatically adjusts height to fit its content.
	 * Includes support for editable TextAreas, padding and border styles.
	 * Does not include support for HTML text.
	 * 
	 * @author Nils Millahn, DN Digital Ltd.
	 */	
	public class SelfAdjustingTextArea extends TextArea
	{
		
		public function SelfAdjustingTextArea()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			wordWrap = true;
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true );
		}
		
		override public function set editable(value:Boolean):void
		{
			super.editable = value;
			value ? addChangeListeners() : removeChangeListeners();
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
			adjustHeight();
		}

		// ---------------------
		// PROTECTED METHODS
		// ---------------------
		
		/**
		 * Adds textfield change event listeners to track user-editable textfields.
		 * Since this adds overhead they are only used when absolutely necessary.
		 */		
		protected function addChangeListeners():void
		{
			addEventListener( Event.CHANGE, onTextChange, false, 0, true );
		}

		/**
		 * Removes textfield change event listeners to track user-editable textfields.
		 */
		protected function removeChangeListeners():void
		{
			removeEventListener( Event.CHANGE, onTextChange );
		}
		
		/**
		 * Adjusts the component's height so that the entire text will fit.
		 */		
		protected function adjustHeight():void
		{
			if( textField == null )
				return;
			
			// weird glitch when editing 2-line textfields
			// and if using exact linemetrics height text will get cut off
			var adjustment:uint = ( textField.numLines == 2 ? 2 : 1 );

			// ensure all pending changes have been accounted for
			validateNow();
			
			// iterate through lines and calculate required height
			var newHeight:Number = 0;
			for(var i:uint = 0; i < textField.numLines ; i++ )
			{
				newHeight += textField.getLineMetrics( i ).height + adjustment;
			}
			
			// add padding and borders
			newHeight += getStyleNum( "paddingTop", 0 );
			newHeight += getStyleNum( "paddingBottom", 0 );
			newHeight += getStyleNum( "borderThicknessTop", getStyleNum( "borderThickness", 0 ) ); // top takes precendence over general setting
			newHeight += getStyleNum( "borderThicknessBottom", getStyleNum( "borderThickness", 0 ) ); // bottom takes precedence over general setting
			
			// apply
			if( height != newHeight )
			{
				height = newHeight; 
			}
		}

		/**
		 * Retrieves a style value 
		 * @param styleName
		 * @param defaultValue
		 * @return 
		 */		
		protected function getStyleNum( styleName:String, defaultValue:Number ):Number
		{
			var val:Number = Number( getStyle( styleName ) );
			if( isNaN( val ) )
			{
				return defaultValue;
			}
			return val;
		}
		
		// ---------------------
		// EVENT HANDLERS
		// ---------------------
		
		protected function onCreationComplete( e:FlexEvent ):void
		{
			removeEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete );
			adjustHeight();
		}
		
		protected function onAddedToStage( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			editable ? addChangeListeners() : removeChangeListeners();
		}
		
		protected function onTextChange( e:Event ):void
		{
			adjustHeight();
			textField.scrollV = 1;
			validateNow(); // for instantaneous feedback
		}
		

	}
}