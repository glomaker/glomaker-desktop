/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.properties.controls
{
	import flash.events.Event;
	import flash.net.FileFilter;
	
	import mx.controls.Button;
	
	import org.glomaker.app.utils.FileSelectHelper;
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.FilePathProperty;
	import org.glomaker.shared.properties.IComponentProperty;

	public class FilePathControl extends Button implements IPropertyControl
	{

		protected var _prop:FilePathProperty;
		protected var _comp:IComponentPlugin;
		protected var _fsHelper:FileSelectHelper;
		
		
		public function assignProperty(prop:IComponentProperty, component:IComponentPlugin):void
		{
			// save
			_prop = FilePathProperty(prop);
			_comp = component;
			
			// check correct property type 
			if(!_prop)
			{
				destroy();
				throw new Error("The PropertyField must be a FilePathProperty");
			}
			
			// initialise correctly
			// label
			label = "Browse...";
			
			// create the fileselecthelper instance that will show the file selection indicator
		 	_fsHelper = new FileSelectHelper(this);
			_fsHelper.title = "Select a file";
		 	
			// use file filter data if available
			if(_prop.fileExtensions)
			{
				_fsHelper.fileFilters = [new FileFilter(_prop.fileTypeLabel, _prop.fileExtensions)];
			}
			
			// listen for file selection event
			_fsHelper.addEventListener(Event.SELECT, onFileSelect);
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
			_fsHelper.removeEventListener(Event.SELECT, onFileSelect);
			_fsHelper.destroy();
			_fsHelper = null;
			
			_prop = null;
			_comp = null;
		}
		
		protected function onFileSelect(evt:Event):void
		{
			// update the value stored in the property
			_prop.propValue = _fsHelper.fileURL;
			
			// notify the associated component
			_comp.editablePropertyUpdated(_prop);
		}
		
	}
}