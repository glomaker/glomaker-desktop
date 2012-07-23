/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.component.interfaces
{
	import mx.core.IUIComponent;
	
	import org.glomaker.shared.properties.IComponentProperty;
	import org.glomaker.shared.utils.MutableArray;
	
	/**
	 * Defines methods to be implemented by GLO component plugins. 
	 * @author Nils
	 */	
	public interface IComponentPlugin extends IUIComponent
	{
		

		// ------------------------------------------------------------------
		// PROPERTY COLLECTIONS
		// ------------------------------------------------------------------


		/**
		 * Return the saveable PropertyFields defined by this component.
		 * These properties are interrogated when saving component data and initialising the component with new data. 
		 * @return 
		 */		
		function getSaveableProperties():Array;
		
		/**
		 * Return the editable PropertyFields defined by this component.
		 * These properties will be displayed in the properties panel in GLOMaker.
		 * The properties won't be initialised with data and won't be saved, unless they are also in getSaveableProperties(). 
		 * @return 
		 */		
		function getEditableProperties():MutableArray;
		

		// ------------------------------------------------------------------
		// LIFECYCLE METHODS
		// ------------------------------------------------------------------

		
		/**
		 * Notifies the component that the values of its defined PropertyFields have been updated.
		 * Called as part of a component's lifecycle within GLOMaker or the player. 
		 */
		function propertyValuesInitialised():void;
		
		/**
		 * Notifies the component that it should update its defined PropertyField values to match those stored/displayed by the component.
		 * This method is called before the component's PropertyField values are saved.
		 * Called as part of a component's lifecycle within GLOMaker or the player. 
		 */		
		function prepareValuesForSave():void;
		
		
		/**
		 * Notifies the component that the value of an individual property has been updated.
		 * Called as part of a component's lifecycle within GLOMaker or the player.
		 * @param prop
		 */		
		function editablePropertyUpdated(prop:IComponentProperty):void;
		

		/**
		 * Cleanup method called when a component instance is permanently removed from the display list. 
		 * Called as part of a component's lifecycle within GLOMaker or the player.
 		 */		
		function destroy():void;


		// ------------------------------------------------------------------
		// EDIT MODE METHODS
		// ------------------------------------------------------------------

		
		/**
		 * Determines whether or not the component has its own custom edit mode.
		 * If true, the GLOMaker will enable double-click on the component and calls setEditMode(). 
		 * @return 
		 */		
		function hasEditMode():Boolean;
		
		/**
		 * Change the mode of the component between edit (true) and display (false) modes 
		 */		
		function setEditMode(f:Boolean):void;		
		

		// ------------------------------------------------------------------
		// SHARED MEMORY
		// ------------------------------------------------------------------
		
		/**
		 * Provides the component with the shared memory object.
		 * This object persists throughout the lifespan of the GLO project and can be used to store data across pages.
		 */		
		function setSharedMemory(o:Object):void;
		
	}
}