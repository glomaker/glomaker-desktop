/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.properties.controls
{
	import mx.controls.ColorPicker;
	import mx.events.ColorPickerEvent;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.ColourProperty;
	import org.glomaker.shared.properties.IComponentProperty;

	public class ColourSelectorControl extends ColorPicker implements IPropertyControl
	{

		protected var _prop:ColourProperty;
		protected var _comp:IComponentPlugin;
		
		public function assignProperty(prop:IComponentProperty, component:IComponentPlugin):void
		{
			// save
			_prop = ColourProperty(prop);
			_comp = component;
			
			// check correct property type 
			if(!_prop)
			{
				destroy();
				throw new Error("The PropertyField must be a ColourProperty");
			}
			
			// initialise correctly
			selectedColor = _prop.propValue;
			
			// listen for changes
			addEventListener(ColorPickerEvent.CHANGE, onValueChange);
		}
		
		public function get property():IComponentProperty
		{
			return _prop;
		}
		
		public function get component():IComponentPlugin
		{
			return _comp;
		}
		
		public function destroy():void
		{
			removeEventListener(ColorPickerEvent.CHANGE, onValueChange);
			_prop = null;
			_comp = null;
		}
		
		protected function onValueChange(evt:ColorPickerEvent):void
		{
			// update the value stored in the property
			_prop.propValue = selectedColor;
			
			// notify the associated component
			_comp.editablePropertyUpdated(_prop);
		}
		
	}
}