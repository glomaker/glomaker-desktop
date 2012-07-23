/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.properties.controls
{
	import mx.controls.NumericStepper;
	import mx.events.NumericStepperEvent;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.IComponentProperty;
	import org.glomaker.shared.properties.NumericStepperProperty;

	public class NumericStepperControl extends NumericStepper implements IPropertyControl
	{

		protected var _prop:NumericStepperProperty;
		protected var _comp:IComponentPlugin;
		
		public function assignProperty(prop:IComponentProperty, component:IComponentPlugin):void
		{
			// save
			_prop = NumericStepperProperty(prop);
			_comp = component;
			
			// check correct property type 
			if(!_prop)
			{
				destroy();
				throw new Error("The PropertyField must be a NumericStepperProperty");
			}
			
			// initialise correctly
			minimum = _prop.minimum;
			maximum = _prop.maximum;
			value = _prop.propValue;
			
			// listen for changes
			addEventListener(NumericStepperEvent.CHANGE, onValueChange);
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
			removeEventListener(NumericStepperEvent.CHANGE, onValueChange);
			_prop = null;
			_comp = null;
		}
		
		protected function onValueChange(evt:NumericStepperEvent):void
		{
			// update the value stored in the property
			_prop.propValue = evt.value;
			
			// notify the associated component
			_comp.editablePropertyUpdated(_prop);
		}
		
	}
}