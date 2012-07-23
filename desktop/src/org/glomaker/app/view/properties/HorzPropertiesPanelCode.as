/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.properties
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.controls.VRule;
	
	import org.glomaker.app.view.components.GLOToolBar;
	import org.glomaker.app.view.properties.controls.CheckBoxControl;
	import org.glomaker.app.view.properties.controls.ColourSelectorControl;
	import org.glomaker.app.view.properties.controls.FilePathControl;
	import org.glomaker.app.view.properties.controls.IPropertyControl;
	import org.glomaker.app.view.properties.controls.IntegerControl;
	import org.glomaker.app.view.properties.controls.NumericStepperControl;
	import org.glomaker.hotdraw.ComponentProxyFigure;
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.BooleanProperty;
	import org.glomaker.shared.properties.ColourProperty;
	import org.glomaker.shared.properties.FilePathProperty;
	import org.glomaker.shared.properties.IComponentProperty;
	import org.glomaker.shared.properties.IntegerProperty;
	import org.glomaker.shared.properties.NumericStepperProperty;
	import org.glomaker.shared.utils.MutableArray;


	/**
	 * Code-behind for the HorzPropertiesPanelView.mxml component class. 
	 * @author Nils
	 */
	public class HorzPropertiesPanelCode extends HBox
	{
		

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		public var typeLabel:Label;
		public var dimensionContainer:GLOToolBar;
		public var verticalLine:VRule;
		public var xInput:TextInput;
		public var yInput:TextInput;
		public var wInput:TextInput;
		public var hInput:TextInput;
		public var controlsContainer:GLOToolBar;

		protected var _changeWatchers:Array = [];
		
		protected var _changeHandlers:Dictionary = new Dictionary(true);
		protected var _propertyControls:Array = [];
		
		protected var _editablePropertyArray:MutableArray;
		protected var _currentPlugin:IComponentPlugin;
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 */		
		public function HorzPropertiesPanelCode()
		{
			super();
		}


		// ------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------
		
		
		/**
		 * Creates controls for a specific component.
		 * @param figure 
		 */		
		public function generateControls(figure:ComponentProxyFigure):void
		{
			// clear existing controls
			clearControls();

			// show the type of component that was selected
			typeLabel.text = figure.getComponentInstance().component.name;
				
			// sort out x, y, width, height fields
			initialiseDimensionProperties(figure);

			// sort out controls for the custom properties			
			_currentPlugin = figure.getContent() as IComponentPlugin;
			
			if(_currentPlugin)
			{
				// get custom properties from the plugin
				_editablePropertyArray = _currentPlugin.getEditableProperties();
				
				// listen for changes to the property list
				_editablePropertyArray.addEventListener(Event.CHANGE, onEditablePropertiesChange);
				
				drawControls(_editablePropertyArray.source, _currentPlugin);
			}
		}
		
		protected function drawControls(propertyList:Array, plugin:IComponentPlugin):void
		{
			//
			var prop:IComponentProperty;
			var ctrl:DisplayObject;
			
			// cycle through each property and create custom controls for it
			for each(prop in propertyList)
			{
				ctrl = null;
				
				if(prop is FilePathProperty)
				{
					ctrl = getFileSelector(prop as FilePathProperty, plugin);
				}
				
				else if(prop is BooleanProperty){
					ctrl = getBooleanSelector(prop as BooleanProperty, plugin);
				}
				
				else if(prop is NumericStepperProperty){
					ctrl = getNumericStepper(prop as NumericStepperProperty, plugin);
				}

				else if(prop is ColourProperty){
					ctrl = getColourSelector(prop as ColourProperty, plugin);
				}
				
				else if(prop is IntegerProperty){
					ctrl = getIntegerField(prop as IntegerProperty, plugin);
				}
				
				if(ctrl)
					controlsContainer.addChild(ctrl);
			}
			
			// show the various elements again
			dimensionContainer.visible = true;
			verticalLine.visible = true;
			controlsContainer.visible = true;
			
		}
		
		
		/**
		 * Removes controls previously created. 
		 * 
		 */		
		public function clearControls():void
		{
			clearChildren();

			// clear/hide elements
			typeLabel.text = "";
			dimensionContainer.visible = false;
			verticalLine.visible = false;
			controlsContainer.visible = false;

			// remove property list change event listener
			if(_editablePropertyArray)
			{
				_editablePropertyArray.removeEventListener(Event.CHANGE, onEditablePropertiesChange);
				_editablePropertyArray = null;
			}
			
			// no plugin selected
			_currentPlugin = null;
		}
		
		protected function clearChildren():void
		{
			// remove elements
			controlsContainer.removeAllChildren();
		
			// clean up data binding
			releaseBindings();
			
			// destroy the controls themselves
			var ctrl:IPropertyControl;
			for each(ctrl in _propertyControls)
				ctrl.destroy();
				
			_propertyControls = [];
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS - UIComponent implementation
		// ------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			clearControls();
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS - DATA BINDING
		// ------------------------------------------------------------------
		
		
		/**
		 * Creates bindings for the x, y, width, height property fields. 
		 * @param figure
		 */		
		protected function initialiseDimensionProperties(figure:ComponentProxyFigure):void
		{
			createBindings(xInput, "text", figure, "x");
			createBindings(yInput, "text", figure, "y");
			createBindings(wInput, "text", figure, "width");
			createBindings(hInput, "text", figure, "height");
		}
		

		/**
		 * Releases change-watcher instances created through data binding methods.
		 * @see createBindings()
		 */
		protected function releaseBindings():void
		{
			// remove change watchers
			for each(var cw:ChangeWatcher in _changeWatchers)
			{
				cw.unwatch();
			}
			_changeWatchers = [];			
		}
		
		
		/**
		 * Shortcut to create bi-directional data bindings.
		 * Bindings created using this method are cleaned up with a call to releaseBindings().
		 * 
		 * The bindings are created in this order:
		 * First, first object is bound to property on second object, then second object is bound to property on first object.
		 * As a result, the shared value will be that currently stored in the second object's property.
		 * @param firstObject
		 * @param firstObjectProperty
		 * @param secondObject
		 * @param secondObjectProperty
		 * @see releaseBindings()
		**/
		protected function createBindings(firstObject:Object, firstObjectProperty:String, secondObject:Object, secondObjectProperty:String):void
		{
			var watcher:ChangeWatcher;
			
			// need to store references to the bindings that are created so we can reset them later on to clean up memory
			watcher = BindingUtils.bindProperty(firstObject, firstObjectProperty, secondObject, secondObjectProperty);
			_changeWatchers.push(watcher);
			
			watcher = BindingUtils.bindProperty(secondObject, secondObjectProperty, firstObject, firstObjectProperty);
			_changeWatchers.push(watcher);
		}
		
		
		// ------------------------------------------------------------------
		// PROTECTED METHODS - GENERIC CONTROL CREATION
		// ------------------------------------------------------------------
		
		
		/**
		 * Produces a finished container with all items required for a single property's controls. 
		 * @param optionalArgs Any number of arguments.
		 * @return 
		 */		
		protected function getContainedItem(...optionalArgs):DisplayObject
		{
			var dobj:DisplayObject;
			var container:HBox = new HBox();
			for each(dobj in optionalArgs)
			{
				container.addChild(dobj);
			}
			
			return container;
		}
		
		
		/**
		 * Creates a Label control. 
		 * @param label
		 * @return 
		 */		
		protected function getLabel(label:String, w:Number = NaN, style:String = "propertiesPanelLabel"):Label
		{
			var l:Label = new Label();
			l.text = label;
			
			if(isNaN(w))
				l.width = w;
				
			l.styleName = style;
			return l;
		}		
		
		
		/**
		 * Creates a TextInput field. 
		 * @param value
		 * @param w
		 * @param style
		 * @return 
		 */
		protected function getTextInput(value:String = "", w:Number = 90, style:String = "propertiesPanelInput"):TextInput
		{
			var ti:TextInput = new TextInput();
			ti.text = value;
			ti.width = w;
			ti.styleName = style;
			return ti;
		}
		
		
		/**
		 * Creates a button. 
		 * @param label
		 * @param style
		 * @return 
		 */
		protected function getButton(label:String, style:String = "propertiesPanelButton"):Button
		{
			var bt:Button = new Button();
			bt.label = label;
			bt.styleName = style;
			return bt;
		}
		
		
		
		// ------------------------------------------------------------------
		// PROTECTED METHODS - CUSTOM CONTROLS
		// ------------------------------------------------------------------
	
	
		/**
		 * Creates (and incorporates) a file selector property ui component. 
		 * @param label
		 * @param prop
		 * @return 
		 */		
		protected function getFileSelector(prop:FilePathProperty, component:IComponentPlugin):DisplayObject
		{
			var control:IPropertyControl = new FilePathControl();
			control.assignProperty(prop, component);
			
			_propertyControls.push(control);

			return getContainedItem(getLabel(prop.editLabel), control);			
		}
		
		/**
		 * Creates (and incorporates) a BooleanField property ui component. 
		 * @param prop
		 * @param property
		 * @return 
		 * 
		 */		
		protected function getBooleanSelector(prop:BooleanProperty, component:IComponentPlugin):DisplayObject
		{
			var control:IPropertyControl = new CheckBoxControl();
			control.assignProperty(prop, component);
			
			_propertyControls.push(control);

			return getContainedItem(getLabel(prop.editLabel), control);
		}
		
		/**
		 * Creates (and incorporates) a numeric stepper property ui component. 
		 * @param prop
		 * @return 
		 */		
		protected function getNumericStepper(prop:NumericStepperProperty, component:IComponentPlugin):DisplayObject
		{
			var control:IPropertyControl = new NumericStepperControl();
			control.assignProperty(prop, component);
			
			_propertyControls.push(control);

			return getContainedItem(getLabel(prop.editLabel), control);
		}
		
		/**
		 * Creates (and incorporates) a ColorPicker property ui component. 
		 * @param prop
		 * @param property
		 * @return 
		 * 
		 */		
		protected function getColourSelector(prop:ColourProperty, component:IComponentPlugin):DisplayObject
		{
			var control:IPropertyControl = new ColourSelectorControl();
			control.assignProperty(prop, component);
			
			_propertyControls.push(control);

			return getContainedItem(getLabel(prop.editLabel), control);
		}
		
		/**
		 * Creates (and incorporates) an IntegerField property ui component. 
		 * @param prop
		 * @param property
		 * @return 
		 * 
		 */		
		protected function getIntegerField(prop:IntegerProperty, component:IComponentPlugin):DisplayObject
		{
			var control:IPropertyControl = new IntegerControl();
			control.assignProperty(prop, component);
			
			_propertyControls.push(control);
			
			return getContainedItem(getLabel(prop.editLabel), control);
		}
		

		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		protected function onEditablePropertiesChange(evt:Event):void
		{
			clearChildren();
			drawControls(_editablePropertyArray.source, _currentPlugin);
		}
			
			
				
		
	}
}