/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.glomaker.app.utils.PluginDiscoveryHelper;
	import org.glomaker.common.vo.PluginInfoVO;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;


	/**
	 * Provides functionality for auto-discovery of plugin files. 
	 * This is an abstract class - extend it to use in your own project.
	 * You will need to override various classes to provide functionality. These are marked with @abstract and throw exceptions when called directly.
	 *  
	 * @author Nils
	 */
	public class PluginProxy extends Proxy
	{
		// The root path to all plugins, to be set in the AppStartupCommand
		public static var rootPath:String = "";

		/**
		 * PureMVC Notification - Error occurred.
		 * Body: Error string.
		 * Type: The name of the proxy sending the notification. 
		 */
		public static const ERROR:String = "PluginProxy.Error";
		
		/**
		 * PureMVC Notification - Discovery process is working on the next file.
		 * Body: Name of plugin directory being discovered.
		 * Type: The name of the proxy sending the notification. 
		 */		
		public static const DISCOVERING:String = "PluginProxy.Discovering";
		
		/**
		 * PureMVC Notification - Discovery process has completed.
		 * Body: The proxy instance sending the Notification. 
		 * Type: The name of the proxy sending the notification.
		 */		
		public static const DISCOVERY_COMPLETE:String = "PluginProxy.DiscoveryComplete";
		
		
				
		
		/**
		 * List of XML files still waiting to be processed. 
		 */		
		private var _pendingFiles:Array = [];
		
		/**
		 * Lookup table - maps plugin IDs to plugin descriptor classes.
		 */		
		private var _byIdLookup:Dictionary = new Dictionary(true);
		private var _isDiscoveryComplete:Boolean = false;		
		
		/**
		 * Timer used for plugin discovery.
		**/
		private var _discoveryTimer:Timer;
		
		/**
		 * Delay between processing of consecutive plugin directories during discovery phase.
		 * In milliseconds.
		**/
		private static const DISCOVER_TIMER_DELAY:Number = 50;
		
		
		/**
		 * Constructor
		 * @param proxyName
		 * @param data
		 */		
		public function PluginProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
			
			// initialise
			_discoveryTimer = new Timer(DISCOVER_TIMER_DELAY, 1);
			_discoveryTimer.addEventListener(TimerEvent.TIMER, onDiscoveryTimer);
		}
		
		
		/**
		 * Start plugin discovery 
		 */		
		public function discover():void
		{
			// update state
			_isDiscoveryComplete = false;
			_discoveryTimer.stop();
			
			// clear storage
			setData([]);
			
			// get discovery directory reference
			// this can be overridden by each subclass to point to different directories
			var pluginDir:File = getPluginPath();
			
			// create new service and try to discover
			var service:PluginDiscoveryHelper = new PluginDiscoveryHelper(pluginDir);
			
			// discover files
			_pendingFiles = service.discoverPluginInfoFiles();
			
			// process each file in turn
			if(_pendingFiles.length == 0)
			{
				_isDiscoveryComplete = true;
				sendNotification(DISCOVERY_COMPLETE, this, getProxyName());
			}else{
				processNextPendingFile();
			}
		}


		/**
		 * Process the next pending plugin information file. 
		 */		
		private function processNextPendingFile():void
		{
			// timer no longer needed
			_discoveryTimer.stop();
			
			// all done?
			if(_isDiscoveryComplete)
				return;
				
			// process next file
			var f:File = _pendingFiles.pop() as File;
			if(f && f.exists)
			{
				
				sendNotification(DISCOVERING, f.parent.name, getProxyName());
				
				try{
					// different steps:
					// - read XML from file
					// - create standard plugin value object from the XML
					// - check it's valid
					// - carry out custom processing steps
					// - store the resulting object in the array
					
					var rawXML:XML = fileToXML(f);
					var vo:PluginInfoVO = xmlToVO(f, rawXML);
					
					if(checkValidPluginVO(vo))
					{
						// allow subclasses to carry out custom processing
						vo = doCustomProcessing(vo, f, rawXML);
						
						// save it
						(getData() as Array).push(vo);
						_byIdLookup[vo.id] = vo;
					}
					
				}catch(e:Error){
					
					// trace("getProxyName()::processNextPendingFile plugin processing error", e.message);
					processNextPendingFile();
				}
			}
			
			// any files left?
			_isDiscoveryComplete = (_pendingFiles.length == 0);
			
			if(!_isDiscoveryComplete)
			{
				_discoveryTimer.reset();
				_discoveryTimer.start();
			}else{
				
				sendNotification(DISCOVERY_COMPLETE, this, getProxyName());
			}
		}
		
		
		/**
		 * Convert info file content to XML object. 
		 * @param f
		 * @return
		 * @throws 
		 */		
		private function fileToXML(f:File):XML
		{
			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.READ);
			
			var raw:String = stream.readUTFBytes(f.size);
			return new XML(raw);
		}
		
		
		/**
		 * Convert info file content into a PluginInfoVO value object instance. 
		 * @param infoFile
		 * @return 
		 * @throws
		 */
		private function xmlToVO(infoFile:File, rawXML:XML = null):PluginInfoVO
		{
			// convert to XML if not supplied
			if(rawXML == null)
			{
				rawXML = fileToXML(infoFile);
			}
			
			// convert to value object
			var vo:PluginInfoVO = getPluginVO();
			
			vo.id = rawXML.id;
			vo.type = getPluginType();
			vo.author = rawXML.author;
			vo.version = rawXML.version;
			vo.glomakerVersion = rawXML.glomaker;
			vo.name = rawXML.name;
			
			if(rawXML.description.length() > 0)
				vo.description = rawXML.description;
			
			// save file paths
			vo.pluginURL = infoFile.parent.url;
			
			// might have an icon
			var iconFile:File = infoFile.parent.resolvePath("icon.png");
			if(iconFile.exists)
				vo.iconURL = iconFile.url;
			
			// done
			return vo;
		}
		
		
		/**
		 * Event handler - discovery timer has triggered. 
		 * @param evt
		 */		
		private function onDiscoveryTimer(evt:TimerEvent):void
		{
			processNextPendingFile();
		}



		// *********************
		// PROTECTED METHODS
		// *********************
		
		/**
		 * Check whether a particular PluginInfoVO instance contains a valid plugin definition.
		 * Can be overridden by subclasses to provide more specific functionality.
		 * @param vo
		 * @return 
		 */		
		protected function checkValidPluginVO(vo:PluginInfoVO):Boolean
		{
			// @todo - implement all necessary data checks
			var isValid:Boolean = true;
			
			// check no duplicate IDs
			isValid = isValid && (_byIdLookup[vo.id] == null);
			
			// done
			return isValid;
		}
		
		
		/**
		 * Return filesystem path to plugin directory.
		 * @abstract 
		 * @return 
		 */		
		protected function getPluginPath():File
		{
			throw new Error("Abstract method - must be implemented in subclass.");
		}


		/**
		 * Return plugin type that this proxy stores.
		 * Each proxy subclass can only store one particular plugin type.
		 * @abstract 
		 * @return 
		 */		
		protected function getPluginType():uint
		{
			throw new Error("Abstract method - must be implemented in subclass.");
		}
		
		/**
		 * Return a value object instance to store information about a single plugin.
		 * By default, it will return a PluginInfoVO instance - but you can override to return a class that extends that VO.
		 * @return
		**/
		protected function getPluginVO():PluginInfoVO
		{
			return new PluginInfoVO();
		}
		
		/**
		 * Carry out custom processing steps after the plugin information has been extraced from the information XML.
		 * Implement in your subclass to provide custom processing functionality.
		 * By default, the original value object is returned unchanged.
		 * @param vo The value-object instance originally returned by getPluginVO(), filled with parsed information.
		 * @param rawXML
		 * @return
		 * @throws Error if processing failed.
		 */		
		protected function doCustomProcessing(vo:PluginInfoVO, infoFile:File, rawXML:XML):PluginInfoVO
		{
			return vo;
		}
		
		
		/**
		 * Return an item stored in the 'byId' lookup table.
		 * This method is declared protected - it should be used in a subclass that can cast the resulting Object to a more specific type.  
		 * @param id
		 * @return 
		 * 
		 */		
		protected function getById(id:String):Object
		{
			return _byIdLookup[id];
		}
		
		
	}
}