/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.controls.Button;
	import mx.controls.TextInput;
	
	
	/**
	 * Handles file selection duties.
	 * 
	 * Can optionally hook up automatically to a button (to trigger the file selector) and a TextInput, to display the path.
	 * 
	 * Usage:
	 
 			fsHelper = new FileSelectHelper(browseBT, filepathTI);
			fsHelper.title = "Select an image";
			fsHelper.fileFilters = [new FileFilter("Images", "*.jpg;*.gif;*.png")];
			
			Manual trigger (not required if a button is specified in the constructor):
			fsHelper.browseFiles();
			 
			Manual update event handling:
			fsHelper.addEventListener(Event.SELECT, onFileSelect);
			
			OR, via dataBinding:
			<mx:Image source="{fsHelper.filePath}"/>
			
			Use 'destroy()' to clean up reference before removing an instance.

	**/
	public class FileSelectHelper extends EventDispatcher
	{
		
		/**
		 * Stores last selected directory.
		 * Static so it can be shared by all instances. 
		 */			
		protected static var LAST_DIR_PATH:String;
		
		
		/**
		 * Temp variable to hold the File instance that launched the file selector dialog. 
		 */			
		protected var _imgFile:File;
		

		/**
		 * The associated 'Browse' trigger-button (might be null).
		 */
		protected var _triggerButton:Button;
		
		/**
		 * The associated output field (might be null). 
		 */			
		protected var _outputField:TextInput;
		
		/**
		 * Native path of last selected file.
		 */			
		protected var _filePath:String;
		
		/**
		 * FileFilter instances used in the file selector.
		 * @see set fileFilters() 
		 */			
		protected var _fileFilters:Array;
		
		/**
		 * Title displayed in the file selector.
		 * @see set title() 
		 */			
		protected var _title:String = "";


		/**
		 * Constructor 
		 * @param triggerButton [optional] If supplied, CLICK event handler will be added automatically.
		 * @param outputField [optional] If supplied, contents will be used to determine start path and content will be updated upon select.
		 */
		public function FileSelectHelper(triggerButton:Button = null, outputField:TextInput = null)
		{
			_triggerButton = triggerButton;
			_outputField = outputField;
			
			// init
			_fileFilters = [];
			
			// set up listener
			if(_triggerButton)
				_triggerButton.addEventListener(MouseEvent.CLICK, onTriggerClick);
		}
		
		
		/**
		 * Cleanup method - call before removing a reference to a FileSelectHelper instance.
		 * The instance won't be functional anymore after you've called this method. 
		 */			
		public function destroy():void
		{
			if(_imgFile)
			{
				_imgFile.removeEventListener(Event.SELECT, onFileSelect);
				_imgFile = null;
			}
			
			if(_triggerButton)
			{
				_triggerButton.removeEventListener(MouseEvent.CLICK, onTriggerClick);
				_triggerButton = null;
			}
			
			if(_outputField)
			{
				_outputField = null;
			}			
		}
		
		[Bindable]
		public function get fileURL():String
		{
			return _filePath;
		} 
		public function set fileURL(value:String):void
		{
			_filePath = value;
		}
		
		public function set fileFilters(value:Array):void
		{
			_fileFilters = value;
		}
		public function get fileFilters():Array
		{
			return _fileFilters;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		public function get title():String
		{
			return _title;
		}
		
		
		protected function onTriggerClick(evt:MouseEvent):void
		{
			browseFiles();
		}
		
		public function browseFiles():void
		{
			// get starting path
			var startPath:String = null;
			
			if(_outputField && _outputField.text)
				startPath = getPath(_outputField.text);
			else if(LAST_DIR_PATH)
				startPath = LAST_DIR_PATH;
			
			_imgFile = new File(startPath);
			
			// Issue 154 - problems arise if startPath is no longer valid (eg. points to removable drive)
			// note that it's possible that startPath is null, in which case _imgFile.exists will throw an exception
			if(startPath && !_imgFile.exists)
				_imgFile = File.documentsDirectory;
			
			// browse for file
			_imgFile.browseForOpen(title, fileFilters);
			_imgFile.addEventListener(Event.SELECT, onFileSelect);
		}
		
		protected function getPath(raw:String):String
		{
			var f:File;
			
			try{
				f = new File(raw);
			}catch(e:Error){
				// error - can't use this file path
				return null;
			}
			
			if(f.exists)
			{
				if(f.isDirectory)
					return f.nativePath;
				else if(f.parent)
					return f.parent.nativePath;
			}
			
			return null;
		}
		
		protected function onFileSelect(evt:Event):void
		{
			_imgFile.removeEventListener(Event.SELECT, onFileSelect);
			
			var selected:File = evt.target as File;
			if(selected)
			{
				_imgFile = null;
				LAST_DIR_PATH = selected.parent.nativePath;
				fileURL = selected.url;
				
				// update output field
				if(_outputField)
					_outputField.text = fileURL;
			}
			
			// pass it on
			dispatchEvent(evt);
		}		

	}
}