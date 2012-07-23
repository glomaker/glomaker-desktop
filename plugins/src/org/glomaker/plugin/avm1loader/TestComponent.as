/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.avm1loader
{
	import mx.core.UIComponent;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;

	public class TestComponent extends UIComponent
	{
		
		private var _moduleInfo:IModuleInfo;
		
		public function TestComponent()
		{
			super();
			
			loadModule();
		}
		
		protected function loadModule():void
			{
				// components are modules, so we use ModuleManager to obtain an instance
				_moduleInfo = ModuleManager.getModule("org/glomaker/plugin/swfloader/SWFLoaderPlugin.swf");
				
		 	   // add event listener before calling 'load()' - if the module was previously loaded, the event listener will fire immediately
				_moduleInfo.addEventListener(ModuleEvent.READY, onModuleReady, false, 0, true);
				
				// load in the module
				_moduleInfo.load();
			}
			
			protected function onModuleReady(evt:ModuleEvent):void
			{
				var child:UIComponent = _moduleInfo.factory.create() as UIComponent;
				
				child.width  = 500;
				child.height = 500;

				addChild(child);
			}
		
	}
}