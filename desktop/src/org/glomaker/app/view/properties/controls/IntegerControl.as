/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.properties.controls
{
	import flash.events.Event;
	
	import mx.controls.TextInput;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.IComponentProperty;
	import org.glomaker.shared.properties.IntegerProperty;

	public class IntegerControl extends TextInput implements IPropertyControl
	{

		protected var _prop:IntegerProperty;
		protected var _comp:IComponentPlugin;
		
		public function assignProperty(prop:IComponentProperty, component:IComponentPlugin):void
		{
			// save
			_prop = IntegerProperty(prop);
			_comp = component;
			
			// check correct property type 
			if(!_prop)
			{
				destroy();
				throw new Error("The PropertyField must be a IntegerProperty");
			}
			
			// initialise correctly
			text = _prop.propValue;
			width = 50;
			restrict = "0-9";
			
			// listen for changes
			addEventListener(Event.CHANGE, onValueChange);
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
			removeEventListener(Event.CHANGE, onValueChange);
			_prop = null;
			_comp = null;
		}
		
		protected function onValueChange(evt:Event):void
		{
			// update the value stored in the property
			_prop.propValue = text;
			
			// notify the associated component
			_comp.editablePropertyUpdated(_prop);
		}
		
	}
}