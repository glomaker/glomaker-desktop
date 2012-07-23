/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.app.model.ApplicationStateProxy;
	import org.glomaker.app.model.ComponentPluginProxy;
	import org.glomaker.app.model.ConfigProxy;
	import org.glomaker.app.model.GuidanceProxy;
	import org.glomaker.app.model.PagePluginProxy;
	import org.glomaker.app.model.PatternPluginProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.app.model.SharedMemoryProxy;
	import org.glomaker.app.model.StagePluginProxy;
	import org.glomaker.app.model.StateProxy;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Base class to use for BaseCommand classes.
	 * Provides easy access to the proxy classes registered in the framework.
	 *  
	 * @author Nils
	 */
	public class BaseCommand extends SimpleCommand
	{
		
		/**
		 * Retrieve a reference of the ConfigProxy instance currently registered with the framework. 
		 * @return 
		 */
		protected function get configProxy():ConfigProxy
		{
			return facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
		}
		
		/**
		 * Retrieve a reference of the ApplicationStateProxy instance currently registered with the framework. 
		 * @return 
		 */
		protected function get appStateProxy():ApplicationStateProxy
		{
			return facade.retrieveProxy(ApplicationStateProxy.NAME) as ApplicationStateProxy;
		}

		/**
		 * Retrieve a reference of the StateProxy instance currently registered with the framework. 
		 * @return 
		 */
		protected function get stateProxy():StateProxy
		{
			return facade.retrieveProxy(StateProxy.NAME) as StateProxy;
		}

		/**
		 * Retrieve a reference of the SelectionProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get selections():SelectionProxy
		{
			return facade.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
		}


		/**
		 * Retrieve a reference of the ProjectSettingsProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get project():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}

		/**
		 * Retrieve a reference of the PagePluginProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get pagePlugins():PagePluginProxy
		{
			return facade.retrieveProxy(PagePluginProxy.NAME) as PagePluginProxy;
		}

		/**
		 * Retrieve a reference of the ComponentPluginProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get componentPlugins():ComponentPluginProxy
		{
			return facade.retrieveProxy(ComponentPluginProxy.NAME) as ComponentPluginProxy;
		}
		
		/**
		 * Retrieve a reference of the StagePluginProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get stagePlugins():StagePluginProxy
		{
			return facade.retrieveProxy(StagePluginProxy.NAME) as StagePluginProxy;
		}
		
		/**
		 * Retrieve a reference of the PatternPluginProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get patternPlugins():PatternPluginProxy
		{
			return facade.retrieveProxy(PatternPluginProxy.NAME) as PatternPluginProxy;
		}				
	   
	   /**
		 * Retrieve a reference of the StagePluginProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get sharedMemoryProxy():SharedMemoryProxy
		{
			return facade.retrieveProxy(SharedMemoryProxy.NAME) as SharedMemoryProxy;
		}	
		
		/**
		 * Retrieve a reference of the PatternMakerProxy instance currently registered with the framework. 
		 * @return 
		 */		
		protected function get guidanceProxy():GuidanceProxy
		{
			return facade.retrieveProxy(GuidanceProxy.NAME) as GuidanceProxy;
		}	
		
	}
}