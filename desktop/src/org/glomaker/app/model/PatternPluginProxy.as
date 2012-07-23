/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import org.glomaker.common.data.PluginType;
	import org.glomaker.common.data.serialiser.NodeSerialiser;
	import org.glomaker.common.data.serialiser.PatternHeadingSerialiser;
	import org.glomaker.common.vo.PatternVO;
	import org.glomaker.common.vo.PluginInfoVO;
	import org.glomaker.interfaces.pattern.IPatternFunction;
	import org.glomaker.interfaces.pattern.IPatternHeading;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.interfaces.pattern.PatternGuidancePage;
	
	public class PatternPluginProxy extends PluginProxy
	{
		
		/**
		 * PureMVC identifier 
		 */		
		public static const NAME:String = "PatternPluginProxy";
		
		
		/**
		 * Stores an ordered version of the plugin list.
		 * Acts as a cache to prevent sorting the list more than once. 
		 */		
		protected var _orderedListCache:Array;
		
		
		/**
		 * Stores IPatternFunction instances by their ID value.
		 * Used to provide nodes with their required associated. 
		 */		
		protected var _functionLookup:Dictionary;
		
		
		
		/**
		 * Constructor 
		 */		
		public function PatternPluginProxy()
		{
			super(NAME, []);
			_functionLookup = new Dictionary(true);
		}
		
		
		// ------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------
		
		public function getPatternById(id:String):PatternVO
		{
			return getById(id) as PatternVO;
		}
		
		public function getPatternList():Array
		{
			return getData() as Array;
		}
		
		public function getSortedPatternList():Array
		{
			// sorting is expensive - we cache the results
			if(!_orderedListCache)
			{
				// make a copy and sort it (sorting modifies the array itself)
				_orderedListCache = (getData() as Array).concat();
				_orderedListCache.sortOn("name", Array.CASEINSENSITIVE);
			}
			
			return _orderedListCache;
		}
		
		public function getFunctionById(funcID:String):IPatternFunction
		{
			return _functionLookup[funcID] as IPatternFunction;
		}
		
		
		override public function setData(data:Object):void
		{
			// overridden so we can clear the cache when data changes
			_orderedListCache = null;
			super.setData(data);
		}
		

		// ------------------------------------------------------------
		// PluginProxy OVERRIDES
		// ------------------------------------------------------------
		
		override protected function getPluginPath():File
		{
			//var f:File = File.applicationStorageDirectory;
			var f:File = File.applicationDirectory;
			//return f.resolvePath(rootPath+"plugins/components/");
			return f.resolvePath("plugins/patterns/");
		}
		
		override protected function getPluginType():uint
		{
			return PluginType.PATTERN;
		}
		
		override protected function getPluginVO():PluginInfoVO
		{
			return new PatternVO();
		}
		
		override protected function doCustomProcessing(vo:PluginInfoVO, infoFile:File, rawXML:XML):PluginInfoVO
		{
			// note: incoming vo parameters is of type returned by getPluginVO(),
			// which in this class is the class PatternVO
			vo = super.doCustomProcessing(vo, infoFile, rawXML);
			
			// custom processing
			var patternVO:PatternVO = vo as PatternVO;
			
			//
			if(patternVO)
			{
				var xml:XML;
				var list:Array;

				// are nodes editable?
				if(rawXML.hasOwnProperty("allowNodeEditing"))
					patternVO.allowNodeEditing = (String(rawXML.allowNodeEditing).toLowerCase() == "yes");

				// get the long description
				if(rawXML.hasOwnProperty("htmlLongDescription"))
				{
					patternVO.htmlLongDescription = rawXML.htmlLongDescription;
					processLongDescription(patternVO);
				}

				// parse library items
				list = [];
				
				for each(xml in rawXML.library.heading)
				{
					list.push(createHeading(xml, infoFile));
				}
				
				// store the list of headings
				patternVO.headings = list;
				
				// parse default nodes
				list = [];
				
				for each(xml in rawXML.instance.node)
					list.push(createDefaultNode(xml));
					
				patternVO.defaultNodes = list;
			}
			
			// done
			return vo;
		}
		
		
		// ------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------
		
		
		/**
		 * Deserialises an XML snippet into a PatternLibraryItemVO instance 
		 * @param vo
		 * @param xml
		 */		
		protected function createHeading(xml:XML, infoFile:File):IPatternHeading
		{
			var heading:IPatternHeading = new PatternHeadingSerialiser().deserialise(xml) as IPatternHeading;
			
			// update function lookup table
			var page:PatternGuidancePage;
			
			for each(var func:IPatternFunction in heading.functions)
			{
				_functionLookup[func.id] = func;
				
				for each(page in func.guidance)
				{
					processGuidance(page, infoFile);
				}
			}
			
			// done			
			return heading;
		}
		
		
		/**
		 * Deserialises an XML snippet into an IPatternNode instance 
		 * @param xml
		 * @return 
		 */		
		protected function createDefaultNode(xml:XML):IPatternNode
		{
			var node:IPatternNode = new NodeSerialiser().deserialise(xml) as IPatternNode;
			
			// add function reference
			var funcID:String = xml.funcid;
			
			if(funcID)
				node.func = getFunctionById(funcID);

			// @todo - error handling for 'function not found'
			
			// done
			return node as IPatternNode;
		}
		
		/**
		 * Processes a pattern's long description HTML content.
		 * The content is wrapped up in html tags so it constitutes a complete HTML document.
		 * A CSS file reference is included to enable content styling. 
		 * @param page
		 */		
		protected function processLongDescription(pattern:PatternVO):void
		{
			// add page wrapper to enable CSS styling
			var wrapperStart:String = "<html><head><link rel='stylesheet' href='appdata/css/patterninfo.css'/></head><body>";
			var wrapperEnd:String = "</body></html>";

			var wrappedHTML:String = wrapperStart + pattern.htmlLongDescription + wrapperEnd;
			
			// reassign
			pattern.htmlLongDescription = wrappedHTML;				
		}		
		
		/**
		 * Processes raw guidance information. 
		 * @param page
		 */		
		protected function processGuidance(page:PatternGuidancePage, infoFile:File):void
		{
			// add page wrapper to enable CSS styling
			var wrapperStart:String = "<html><head><link rel='stylesheet' href='appdata/css/guidance.css'/></head><body>";
			var wrapperEnd:String = "</body></html>";

			var wrappedHTML:String = wrapperStart + page.htmlContent + wrapperEnd;
			
			// replace image urls with absolute paths into the pattern's asset folder
			var htmlXML:XML = new XML(wrappedHTML);
			var img:XML;
			var source:String;
			var filename:String;
			var assetFile:File;
			
			// regular expression to strip the path off a filename, simply leaving the name + extension
			// the [\/\\] sequence will match either a \ or a / character to accommodate different operating system path separators
			var pathRegExp:RegExp = /.*[\/\\]/;
				
			for each(img in htmlXML..img)
			{
				source = img.@src;
				filename = source.replace(pathRegExp, "");
				filename = infoFile.parent.url + File.separator + "assets" + File.separator + filename;
				
				img.@src = filename;
			}
			
			// reassign
			page.htmlContent = htmlXML.toXMLString();				
		}
		
	}
}