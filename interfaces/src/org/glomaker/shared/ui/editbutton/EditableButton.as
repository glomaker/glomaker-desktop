/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.ui.editbutton
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.core.BitmapAsset;
	import mx.core.mx_internal;

	/**
	 * Creates a button with an editable label.
	 * When the 'isEditable' button property is set to true, the user can type in a different button label.
	 * 
	 * By default, the button is not editable.
	 * When the button is in editable state, you won't be able to receive button events from it.
	 *  
	 * @author Nils
	 */	
	public class EditableButton extends Button
	{

		use namespace mx_internal;

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		
		[Embed(source="edit_icon.png")]
		/**
		 * Small icon used to show that the button is editable. 
		 */
		protected static const PENCIL_ICON:Class;
		
		
		/**
		 * Amount of width to add to the textfield in addition to the button's own label's width.
		 * 
		 * TextInput components automatically scroll text to the left when you reach the end of the line.
		 * This causes a confusing user experience when editing the button label.
		 * By adding a fixed amount of space at the end (thus always making the TextInput more than long enough), the automatic scrolling can be avoided.
		 */		
		protected static const TEXTINPUT_OVERFLOW_SIZE:uint = 40;
		

		// ------------------------------------------------------------------
		// CLASS INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		protected var _editField:TextInput;
		protected var _editIcon:BitmapAsset;
		protected var _isEditable:Boolean = false;
		
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------

		[Bindable]
		/**
		 * Sets whether or not the button's label is editable.
		 * When in editable mode, a small icon is shown. 
		 */
		public function set isEditable(value:Boolean):void
		{
			if(value != _isEditable)
			{
				_isEditable = value;
				updateEditState();
			}
		}
		public function get isEditable():Boolean
		{
			return _isEditable; 
		}
		
		
		/**
		 * @inheritDoc 
		 * @param value
		 */		
		override public function set label(value:String):void
		{
			super.label = value;
			
			if(_editField)
				_editField.text = value;
		}
		
		
		
		// ------------------------------------------------------------------
		// BUTTON OVERRIDES
		// ------------------------------------------------------------------

		/**
		 * @inheritDoc 
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// make sure edit/non-edit state elements are correctly initialised
			// called here because all child elements will have been created
			updateEditState();
		}
		
		
		/**
		 * @inheritDoc 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// resize child elements
			if(_editField)
			{
				// update the child element's size (required in custom components)
				_editField.setActualSize(_editField.getExplicitOrMeasuredWidth(), _editField.getExplicitOrMeasuredHeight());
			
				// if the edit field is currently on the display list,
				// move it to the top to make sure it is above the icon and skin elements
				// and size it so it looks as if it's actually on the button
				if(_editField.parent)
				{
					addChild(_editField);
					sizeEditField();
				}
			}
			
			// if the edit icon is currently on the display list,
			// then move it to the top to make sure it is above the icon and skin elements
			if(_editIcon && _editIcon.parent)
			{
				addChild(_editIcon);
			}
		}
		
		/**
		 * @inheritDoc 
		 * @param event
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			// if the button isn't in edit mode, we just use the default behaviour
			if(!_isEditable)
			{
				super.keyDownHandler(event);
				return;
			}
			
			// in edit mode - override behaviour completely
			switch(event.keyCode)
			{
				 case Keyboard.ENTER:
					// ENTER should finish editing
					// set focus on the button itself
					// this automatically moves focus away from the TextInput - and onFocusOut() will handle cleanup
					setFocus();
					
					break;
			}			
		}
		
		
		/**
		 * @inheritDoc 
		 * @param event
		 */		
		override protected function keyUpHandler(event:KeyboardEvent):void
		{
			// if the button isn't in edit mode, we just use the default behaviour
			if(!_isEditable)
			{
				super.keyDownHandler(event);
				return;
			}
			
			// in edit mode - override behaviour completely
			// no further action - but by overriding we prevent the default behaviour of space-bar pressing the button
		}
		

		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Creates child elements (_editField, _editIcon) used for the editable button state.
		 * Elements are not added to the display list.
		 */		
		protected function createEditChildren():void
		{
			if(!_editField)
			{
				_editField = createInFontContext(TextInput) as TextInput;
				_editField.styleName = this;
			
				// additional styles to make the edit field look as seamless as possible	
				_editField.setStyle("backgroundAlpha", 0);
				_editField.setStyle("borderThickness", 0);
				_editField.setStyle("borderStyle", "none");
				_editField.setStyle("paddingTop", 0);
				_editField.setStyle("paddingBottom", 0);
				_editField.setStyle("paddingLeft", 0);
				_editField.setStyle("paddingRight", 0);
				_editField.setStyle("textAlign", "left");
				_editField.setStyle("focusAlpha", 0);
			}
			
			if(!_editIcon)
			{ 
				_editIcon = BitmapAsset(new PENCIL_ICON());
				_editIcon.y = -4;
				_editIcon.x = 3;
			}
		}
		
		/**
		 * Updates the displayed elements depending on whether the button is in 'editable' mode or not. 
		 */		
		protected function updateEditState():void
		{
			// may be called too early, before child elements have been created
			if(!textField)
				return;

			if(_isEditable)
			{
				// in Edit mode
				
				// the button itself shouldn't be clickable anymore - it just becomes a backdrop to a TextInput
				// and only the TextInput should be mouse enabled

				mouseEnabled = false;
				mouseChildren = true;
				
				var i:uint;
				var child:Object;
				for(i = 0; i< numChildren; i++)
				{
					child = getChildAt(i);
					if(child != _editField)
					{
						// not all children necessarily provide mouseEnabled / mouseChildren properties
						try{
							child.mouseEnabled = false;
							child.mouseChildren = false;
						}catch(e:Error){}
					}
				}
				
				// instead of the button's label, we show an editable TextInput field instead
				textField.visible = false;
				
				// create the editor elements
				createEditChildren();
				
				// add them to the display list
				addChild(_editIcon);
				addChild(_editField);
				
				// update
				_editField.text = label;
				
				// add listeners to react to user interaction with the textfield
				_editField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			
			}else{
				
				// no longer in edit mode
				// make sure the label is visible
				textField.visible = true;

				// switch the button back on again
				mouseEnabled = true;
				mouseChildren = false;
				
				// cleanup the TextInput field
				if(_editField)
				{
					if(_editField.parent)
						_editField.parent.removeChild(_editField);

					removeEditListeners();
					_editField = null;
				}
					
				// cleanup the edit state icon
				if(_editIcon)
				{
					if(_editIcon.parent)
						_editIcon.parent.removeChild(_editIcon);

					_editIcon = null;
				}
			}
		}
		
		
		/**
		 * Size the textfield to match the current button label's position and dimensions. 
		 */		
		protected function sizeEditField():void
		{
			_editField.x = textField.x;
			_editField.y = textField.y;
			_editField.height = textField.height;
			_editField.width = textField.width + TEXTINPUT_OVERFLOW_SIZE;
		}
		
		/**
		 * Remove all event listeners used in the editable state. 
		 */		
		protected function removeEditListeners():void
		{
			_editField.removeEventListener(Event.CHANGE, onChange);
			_editField.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_editField.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}


		// ------------------------------------------------------------------
		// EVENT LISTENERS
		// ------------------------------------------------------------------

		/**
		 * Edit-state TextInput value has changed. 
		 * @param evt
		 */		
		protected function onChange(evt:Event):void
		{
			// copy it across to the button to make sure it stays in sync with the edit field
			label = _editField.text;
		}
		
		/**
		 * Edit-state TextInput has received focus. 
		 * @param evt
		 */		
		protected function onFocusIn(evt:FocusEvent):void
		{
			// add additional listeners to capture user interaction
			_editField.addEventListener(Event.CHANGE, onChange);
			_editField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			// capture mouse clicks elsewhere so that TextInput can be unfocussed when the user clicks away from it
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		/**
		 * Edit-state TextInput has lost its focus. 
		 * @param evt
		 */
		protected function onFocusOut(evt:FocusEvent):void
		{
			// remove all user-interaction event listeners
			removeEditListeners();
			
			// if we're in edit mode, we have to listen to the focus event
			// (its event listener is also removed in removeEditListeners())
			if(_isEditable)
				_editField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			
			// one last update to make sure the button label remains in sync
			label = _editField.text;
		}
		
		/**
		 * User has clicked away from the TextInput field. 
		 * @param evt
		 */		
		protected function onStageMouseDown(evt:MouseEvent):void
		{
			// make sure the click really was away from the field
			var overEditField:Boolean = _editField.hitTestPoint(evt.stageX, evt.stageY, false);
			
			if(!overEditField)
			{
				// set focus on the button itself
				// this automatically moves focus away from the TextInput - and onFocusOut() will handle cleanup
				setFocus();
			}
		}
		
		
	}
}