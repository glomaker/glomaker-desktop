/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.component
{
	import mx.events.FlexEvent;
	import mx.modules.Module;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.IComponentProperty;
	import org.glomaker.shared.utils.MutableArray;

	public class BaseComponent extends Module implements IComponentPlugin
	{
		/**
		 * Collection of all editable properties.
		 * These will be shown in the properties panel.
		 */
		private var _editableProperties:MutableArray;
		
		
		/**
		 * Collection of all saveable properties.
		 * These will be included when loading/saving data.
		 * Note: A property can be included in editable and saveable properties. 
		 */		
		private var _saveableProperties:Array;
		
		
		/**
		 * A list storing (unique) references to all properties created during the lifetime of the application.
		 * Used by destroy() to make sure that all properties are destroyed. 
		 */		
		private var _allProperties:Array;
	
	
		/**
		 * A reference to the shared memory object 
		 */
		private var _sharedMemory:Object;
		
		
		/**
		 * Has propertyValuesInitialised() been called?
		 * @see isAllInitialised()
		 */		
		private var _propertiesAvailable:Boolean = false;
		
		/**
		 * Has setSharedMemory() been called?
		 * @see isAllInitialised() 
		 */		
		private var _sharedMemoryAvailable:Boolean = false;
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR 
		// ------------------------------------------------------------------


		/**
		 * Constructor. 
		 * 
		 */
		public function BaseComponent()
		{
			super();
			
			// instantiate properties collections
			_editableProperties = new MutableArray();
			_saveableProperties = [];
			_allProperties = [];
			
			// add event listener to detect creationComplete
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}


		// ------------------------------------------------------------------
		// PROPERTY COLLECTIONS
		// IComponentPlugin IMPLEMENTATION
		// ------------------------------------------------------------------


		/**
		 * Return the saveable PropertyFields defined by this component.
		 * These properties are interrogated when saving component data and initialising the component with new data. 
		 * @return 
		 */		
		public function getSaveableProperties():Array
		{
			return _saveableProperties;
		}
		
		/**
		 * Return the editable PropertyFields defined by this component.
		 * These properties will be displayed in the properties panel in GLOMaker.
		 * The properties won't be initialised with data and won't be saved, unless they are also in getSaveableProperties(). 
		 * @return 
		 */		
		public function getEditableProperties():MutableArray
		{
			return _editableProperties;
		}
		

		// ------------------------------------------------------------------
		// LIFECYCLE METHODS
		// IComponentPlugin IMPLEMENTATION
		// ------------------------------------------------------------------

		
		/**
		 * Notifies the component that the values of its defined PropertyFields have been updated.
		 * Called as part of a component's lifecycle within GLOMaker or the player. 
		 * DEPRECATED: Use componentInitComplete() instead.
		 */
		public function propertyValuesInitialised():void
		{
			// empty - implement specific behaviour in subclass
			
			// update state
			_propertiesAvailable = true;
			
			// if all other initilisation steps have completed, call the final hook method
			if( isAllInitialised() )
			{
				componentInitComplete();
			}
		}
		
		/**
		 * Notifies the component that it should update its defined PropertyField values to match those stored/displayed by the component.
		 * This method is called before the component's PropertyField values are saved.
		 * Called as part of a component's lifecycle within GLOMaker or the player. 
		 */		
		public function prepareValuesForSave():void
		{
			// empty - implement specific behaviour in subclass
		}
		
		
		/**
		 * Notifies the component that the value of an individual property has been updated.
		 * Called as part of a component's lifecycle within GLOMaker or the player.
		 * @param prop
		 */		
		public function editablePropertyUpdated(prop:IComponentProperty):void
		{
			// empty - implement specific behaviour in subclass
		}
		

		/**
		 * Cleanup method called when a component instance is permanently removed from the display list. 
		 * Called as part of a component's lifecycle within GLOMaker or the player.
		 * When overriding this method, make sure you call super.destroy(). 
 		 */		
		public function destroy():void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			// free up properties
			var prop:IComponentProperty;
			
			for each(prop in _allProperties)
			{
				if(prop)
					prop.destroy();
			}
			
			_allProperties = null;
			_saveableProperties = null;
			_editableProperties = null;
		}


		// ------------------------------------------------------------------
		// EDIT MODE METHODS
		// IComponentPlugin IMPLEMENTATION
		// ------------------------------------------------------------------

		
		/**
		 * Determines whether or not the component has its own custom edit mode.
		 * If true, the GLOMaker will enable double-click on the component and calls setEditMode().
		 * Returns true by default - override to change this behaviour.
		 * @return 
		 */		
		public function hasEditMode():Boolean
		{
			// returns true by default - override to change this behaviour
			return true;
		}
		
		/**
		 * Change the mode of the component between edit (true) and display (false) modes 
		 */		
		public function setEditMode(f:Boolean):void
		{
			// empty - implement specific behaviour in subclass
		}	
		

		// ------------------------------------------------------------------
		// SHARED MEMORY
		// IComponentPlugin IMPLEMENTATION
		// ------------------------------------------------------------------
		
		/**
		 * Provides the component with the shared memory object.
		 * This object persists throughout the lifespan of the GLO project and can be used to store data across pages.
		 */		
		final public function setSharedMemory(o:Object):void
		{
			// if shared memory is set and is about to be cleared to null,
			// we allow the component plugin to store values first
			if( _sharedMemory && o == null )
			{
				sharedMemoryPreDestroyHook();
				_sharedMemory = null;
				return;
			}
			
			// save new value (not null)
			_sharedMemory = o;
			
			// update state
			_sharedMemoryAvailable = true;
			
			// if all other initilisation steps have completed, call the final componentInitComplete() method
			if( isAllInitialised() )
			{
				componentInitComplete();
			}
		}
		
		/**
		 * Shared memory is about to be cleared.
		 * This method provides a last-minute option to update values before the connection is lost. 
		 */		
		protected function sharedMemoryPreDestroyHook():void
		{
		}
		
		/**
		 * Read a named value from the shared memory object.
		 * @param name
		 * @return 
		 * @throws Error if shared memory isn't set - you're probably calling this method too early.
		 */
		final protected function readFromMemory( name:String ):*
		{
			// this method is final to avoid plugin developers overriding it by mistake
			if( !_sharedMemory )
			{
				throw new Error("Shared memory not set - can't read from it. Wait until sharedMemoryAvailable() is called.");
			}
			
			return _sharedMemory[ name ];
		}
		
		/**
		 * Store a value in shared memory.
		 * @param name Name to store it under.
		 * @param allowOverwrite Set to true to allow overwriting of existing property.
		 * @throws Error if trying to overwrite an existing property without setting allowOverwrite to true
		 * @throws Error if shared memory isn't set.
		 */
		final protected function writeToMemory( name:String, value:*, allowOverwrite:Boolean = false ):void
		{
			// this method is final to avoid plugin developers overriding it by mistake
			if( !_sharedMemory )
			{
				throw new Error("Shared memory not set - can't read from it. Wait until sharedMemoryAvailable() is called.");
			}
			
			if( _sharedMemory[ name ] && !allowOverwrite )
			{
				throw new Error("A value with this name already exists. Have you chosen the right name?");
			}
			
			_sharedMemory[ name ] = value;
		}
		
		/**
		 * Deletes a named property from shared memory. 
		 * @param name
		 */		
		final protected function deleteFromMemory( name:String ):void
		{
			// this method is final to avoid plugin developers overriding it by mistake
			if( !_sharedMemory )
			{
				throw new Error("Shared memory not set - can't read from it. Wait until sharedMemoryAvailable() is called.");
			}
			
			delete _sharedMemory[ name ];
		}


		// ------------------------------------------------------------------
		// PROTECTED INSTANCE METHODS
		// ------------------------------------------------------------------

		
		/**
		 * Triggered once the component is complete. 
		 * @param evt
		 */
		protected function onCreationComplete(evt:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

			// define default properties for this component
			defineProperties();
		}

		
		/**
		 * Method used to define properties exposed by this component.
		 * You would not normally call this method directly - it is callled automatically for you by BaseComponent.
		 */		
		protected function defineProperties():void
		{
			// empty - implement specific behaviour in subclass			
		}
		
		
		/**
		 * Internal method that's called when all initialisation sequences (properties, shared memory) have completed.
		 * Override this method in order to access shared memory and other data properties. 
		 */		
		protected function componentInitComplete():void
		{
		}
		
		/**
		 * Adds a PropertyField instance to the list of properties that this component exposes to GLOMaker.
		 * The property will be included when data is saved and will be initialised from existing data when the component first loads.
 		 * The property will be included when data is saved and will be shown in the property control panel.
 		 * 
 		 * This method should only be called from within defineProperties()!
 		 * 
		 * @param prop
		 * 
		 * @see addSaveableProperty()
		 * @see addEditableProperty()
		 */
		protected function addProperty(prop:IComponentProperty):void
		{
			addPropertyRef(prop);
			addSaveableProperty(prop);
			addEditableProperty(prop);
		}		
		
		
		/**
		 * Adds a PropertyField instance to the list of properties that this component exposes to GLOMaker.
		 * The property will be included when data is saved and will be initialised from existing data when the component first loads.
		 * The property won't be accessible via the GLOMaker properties panel.
		 * 
		 * This method should only be called from within defineProperties()!
		 * 
		 * @param prop
		 * 
		 * @see addProperty()
		 * @see addEditableProperty()
		 */
		protected function addSaveableProperty(prop:IComponentProperty):void
		{
			addPropertyRef(prop);
			_saveableProperties.push(prop);
		}


		/**
		 * Adds a PropertyField instance to the list of properties that this component exposes to GLOMaker.
		 * The property won't be included when data is saved or loaded.
		 * The property will be accessible via the GLOMaker properties panel.
		 * 
		 * This method should only be called from within defineProperties()!
		 * 
		 * @param prop
		 *
		 * @see addProperty()  
		 * @see addSaveableProperty()
		 */
		protected function addEditableProperty(prop:IComponentProperty):void
		{
			addPropertyRef(prop);
			_editableProperties.source.push(prop);
		}
		
		/**
		 * Advanced method that allows you to update the properties shown in the properties panel at runtime.
		 * All existing editable properties will be replaced by the new list that you provide.
		 * 
		 * This is a method for advanced component development and will only be used rarely.
		 *  
		 * @param completeList
		 * 
		 */		
		protected function updateEditableProperties(completeList:Array):void
		{
			for each(var prop:IComponentProperty in completeList)
				addPropertyRef(prop);
			
			// assign new ones
			_editableProperties.wrap(completeList);
		}
		
		/**
		 * Adds a property to the _allproperties array.
		 * The property is only added if it's not already part of the array. 
		 * @param prop
		 */		
		private function addPropertyRef(prop:IComponentProperty):void
		{
			if(!(prop in _allProperties))
				_allProperties.push(prop);
		}
		
		
		/**
		 * Allows code to check whether all initialisation functions have fired. 
		 * @return 
		 */		
		private function isAllInitialised():Boolean
		{
			return ( _sharedMemoryAvailable && _propertiesAvailable );
		}
		
	}
}