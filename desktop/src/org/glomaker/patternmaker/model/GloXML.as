/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.model
{
	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.geom.Point;
	
	public class GloXML extends PatternsModel implements IPatternsModel{
		private var sourceXML:XML;
		private var GLOXML:XML;
		//private var GLO_manifest:XML;
		private static var nodeCount:uint;
		private static var gloCount:uint;
		
		public function GloXML(aStage:Stage){
			super(aStage);
		}
		
		private function appendIDs():void{
			//trace(GLO_manifest.defaultGLO.pattern..glo.page.(@type == "Reflect"));
			//var test:Array = new Array();
			var nodeID:String = "";
			for each(var item:XML in GLOXML.page){
				//trace("w2"+item.@realisationType.toXMLString());
				switch(item.@type.toString()){
					case "Orient":
						
						switch(item.@realisationType.toString()){
							case "Quick Orientation":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = item.@layoutType == "Multimedia WiT" ? nodeID="p2": "p1";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = item.@layoutType == "Multimedia WiT" ? nodeID="p20": "p18";
									break;
								}
								//What is Topic
							case "What Topic":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p3";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p19";
									break;
								}
								break;
							case "What":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p35";
									break;
								}
								if(item.parent().@type == "AMP"){
									nodeID = "p37";
									break;
								}
								break;
						}
						break;
					case "OrientElaborate":
						switch(item.@realisationType.toString()){
							case "Be Attracted":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p4";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p21";
									break;
								}
								break;
							case "Scenario":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p7";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p24";
									break;
								}
								break;
							case "List of Points":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p8";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p25";
									break;
								}
								break;
							case "Explain Why":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p36";
									break;
								}
								if(item.parent().@type == "AMP"){
									nodeID = "p38";
									break;
								}
								break;
							case "Preview Outcome":
								nodeID = "p39"
								break;
						}
					case "ComprehendDefault":
						switch(item.@realisationType.toString()){
							case "Scenario":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p5";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p22";
									break;
								}
								break;
							case "undefined":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p12";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p29";
									break;
								}
								break
						}
						break;
					case "Comprehend":
						switch(item.@realisationType.toString()){
							case "Scenario":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p6";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p23";
									break;
								}
								break;
							case "undefined":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p13";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p30";
									break;
								}
								break
						}
						break;
					case "Apprehend":
						switch(item.@realisationType.toString()){
							case "flashNoNarrative":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p10";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p27";
									break;
								}
								break;
							case "undefined":
								if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
									nodeID = "p9";
									break;
								}
								if(item.parent().@type == "MEASA"){
									nodeID = "p26";
									break;
								}
								break
						}
						break;
					case "SeeOverallEffect":
						if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
							nodeID = "p11";
							break;
						}
						if(item.parent().@type == "MEASA"){
							nodeID = "p28";
							break;
						}
						break;
					case "TryReflect":
						if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
							nodeID = "p14";
							break;
						}
						if(item.parent().@type == "MEASA"){
							nodeID = "p31";
							break;
						}
						break;
					case "Construct 2":
						if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
							nodeID = "p15";
							break;
						}
						if(item.parent().@type == "MEASA"){
							nodeID = "p32";
							break;
						}
						break;
					case "Construct":
						if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
							nodeID = "p16";
							break;
						}
						if(item.parent().@type == "MEASA"){
							nodeID = "p33";
							break;
						}
						break;
					case "MultipleChoice":
						if(item.parent().@type == "EASA" || item.parent().@type == "freestyle"){
							nodeID = "p17";
							break;
						}
						if(item.parent().@type == "MEASA"){
							nodeID = "p34";
							break;
						}
						if(item.parent().@type == "AMP"){
							nodeID = "p44";
							break;
						}
						break;
					case "Prepare":
						nodeID = "p40";
						break;
					case "Feedback":
						nodeID = "p41";
						break;
					case "Main Task":
						nodeID = "p42";
						break;
					case "Access Views":
						nodeID = "p43";
						break;
					case "Reflect":
						nodeID = "p45";
						break;
					case "Comprehend Test":
						nodeID = "p46";
						break;
					case "generic":
						switch(item.@realisationType.toString()){
							case "introduce":
								nodeID = "p47";
								break;
							case "doLearning":
								nodeID = "p48";
								break;
							case "assessReflect":
								nodeID = "p49";
								break;
						}
					case "multiple":
						nodeID = "p50";
						break;
					
						
				}
				
				item.@gloRef = nodeID;
				//test.push(nodeID);
				
			}
			//Add a unique ID to each node
			uniqueIDs();
			//trace(patternXML.toXMLString());
			//mdm.Dialogs.prompt(GLOXML.toXMLString());
		}
		//private function processGloManifest():void{
			//GLO_manifest.xml is a list of all possible page types, with unique IDs.
			//We need to cross reference the incoming glo xml with this list.
			//Prepare
			//removeAllNodes();
			
			
			/*//The tricky bit. We need to go through GLOXML and reference the manifest
			for each(var item:XML in GLOXML.page){
				switch(item.@type.toString()){
					case "Orient":
						switch(item.@realisationType.toString()){
							case "Quick Orientation":
								//p1
								item.@gloRef = "p1";
								break;
							case "What is Topic?":
								//p2
								item.@gloRef = "p2";
								break;
							case "What":
								//p13
								item.@gloRef = "p13";
								break;
						}
						break;
					case "OrientElaborate":
						switch(item.@realisationType.toString()){
							case "Be Attracted":
								//p3
								item.@gloRef = "p3";
								break;
							case "List of Points":
								//p5
								item.@gloRef = "p5";
								break;
							case "Explain Why":
								//p14
								item.@gloRef = "p14";
								break;
							case "Preview Outcome":
								//p15
								item.@gloRef = "p15";
								break;
						}
						break;
					case "ComprehendDefault":
							if(item.@realisationType.toString() == "Scenario"){
								//p4
								item.@gloRef = "p4";
							}else{
								//p7
								item.@gloRef = "p7";
							}
						break;
					case "Apprehend":
						//p6
						item.@gloRef = "p6";
						break;
					case "SeeOverallEffect":
						//p8
						item.@gloRef = "p8";
						break;
					case "TryReflect":
						//p9
						item.@gloRef = "p9";
						break;
					case "Construct":
						//p10
						item.@gloRef = "p10";
						break;
					case "Construct 2":
						//p11
						item.@gloRef = "p11";
						break;
					case "MultipleChoice":
						if(item.@parentStage.toString() == "Reflect"){
							//p20
							item.@gloRef = "p20";
						}else{
							//p12
							item.@gloRef = "p12";
						}
						break;
					case "Prepare":
						//p16
						item.@gloRef = "p16";
						break;
					case "Feedback":
						//p17
						item.@gloRef = "p17";
						break;
					case "Main Task":
						//p18
						item.@gloRef = "p18";
						break;
					case "Access Views":
						//p19
						item.@gloRef = "p19";
						break;
					case "Reflect":
						//p21
						item.@gloRef = "p21";
						break;
					
				}
			}*/
			//Add unique IDs.
			/*uniqueIDs();
			//The GLOXML now has references to GLO_manifest, using attribute gloRef (p1, p2...). Also a unique id (n1, n2...).
			patternXML = new XML(<patterns></patterns>);
			//Now build menu, from manifest. Here we need to select the correct pattern from the manifest.
			var pattern:XML = GLO_manifest.pattern.(@type == GLOXML.@type)[0];
			var pages:XML = new XML(<pages />);
			
			for each(var page:XML in pattern.page){
				//trace(page.toXMLString());
				pages.appendChild(GLO_manifest.pages.page.(@id == page.@instanceID)[0]);
			}
			//The headings have to be worked out from the available information.
			var headings:XML = new XML(<headings />);
			for each(page in pages.page){
				headings.appendChild(GLO_manifest.headings.heading.(@id == page.@parent)[0]);
			} 
			
			//Remove duplicates
			var dupList:XMLList = headings.heading;
			
			//Works from the end back to the beginning
			for(var i:int=dupList.length()-1; i>=0; i--){
				for(var j:int=dupList.length()-2; j>=0; j--){
					if(dupList[i].@id == dupList[j].@id){
						delete dupList[j];
						i--;
						j--;
					}
				}
			}
			//Sort
			var sort:Array = new Array();
			
			for each(var heading:XML in dupList){
				sort.push(heading.@id);
			}
			
			sort.sort();
			
			//Create headings
			patternXML.appendChild(<pattern name={GLOXML.@type} id={GLO_manifest.pattern.(@type == GLOXML.@type)[0].@id}></pattern>);
			
			for(i=0; i<sort.length; i++){
				var name:String = GLO_manifest.headings.heading.(@id == sort[i])[0].text()[0];
				var hFunction:String = GLO_manifest.headings.heading.(@id == sort[i])[0].@type[0];
				var id:String = GLO_manifest.headings.heading.(@id == sort[i])[0].@id[0];
				
				heading = <heading name={name} hFunction={hFunction} id={id}></heading>
				patternXML.pattern[0].appendChild(heading);
			}
			//At this stage, a correct set of headings should have been created.
			//Add Nodes
			
			for each(page in pages.page){
				name = page.text();
				var nFunction:String = page.@type;
				
				//The recently added unique ID and gloRef are added to patternXML.
				id = "n"+page.@id.toString().split("p")[1];
				var gloRef:String = page.@id;
				
				var node:XML = new XML(<node name={name} nFunction={nFunction} id={id}></node>);
				node.appendChild(<colour>{GLO_manifest.headings.heading.(@id == page.@parent)[0].@colour}</colour>);
				node.appendChild(<defaultTxt>{name}</defaultTxt>);
				node.appendChild(<gloRef>{gloRef}</gloRef>);
				patternXML.pattern[0].heading.(@id == page.@parent).appendChild(node);
				
			}

			//mdm.Dialogs.prompt(patternXML.toXMLString());
			setMenu(GLOXML.@type);
			populateScreen();

*/
		//}		
		private function uniqueIDs():void{
			gloCount = 1;
			for each(var item:XML in GLOXML.page){
				item.@id = "n"+gloCount;
				gloCount++;
			}
		}
		private function joinNodes():void{
			if(nodeArray.length < 1){
				return;
			}
			
			nodeArray[0].rootNode = true;
			
			for(var i:uint=1; i<nodeArray.length; i++){
				nodeArray[i].parent = nodeArray[i-1].id;
				nodeArray[i-1].child = nodeArray[i].id;
			}
			//Trigger redraw
			update("setDrag");
			update("joinNodes");
		}
		
		/*private function processGloManifest():void{
			
			removeAllNodes();
			patternXML = new XML(<patterns></patterns>);
			
			switch(GLOXML.@type.toString()){
				case "EASA":
					patternXML.appendChild(sourceXML.pattern.(@name == "EASA")[0]);
					setMenu("EASA");
					break;
				case "MEASA":
					patternXML.appendChild(sourceXML.pattern.(@name == "EASA")[0]);
					setMenu("EASA");
					break;
				case "AMP":
					patternXML.appendChild(sourceXML.pattern.(@name == "EMI")[0]);
					setMenu("EMI");
					break;
			}
			uniqueIDs();
			//correlateXML();
			populateScreen();
			joinNodes();
		}*/

		/*private function correlateXML():void{
			switch(GLOXML.@type.toString()){
				case "EASA":
					
					break;
				case "MEASA":
					
					break;
				case "AMP":
					
					break;
			}
		}*/
		/*private function populateScreen():void{ 
			var insetH:uint = 200;
			var insetV:uint = 100;
			var separation:uint = 60;
			var count:uint = 0;
			
			for each(var item:XML in GLOXML.page){
				switch(item.@type.toString()){
					case "Orient":
						createNode("n13", new Point(insetH, separation*count + insetV), item);
					 	break;
						
					case "OrientElaborate":
						if(item.@realisationType.toString() == "Explain Why"){
							createNode("n14", new Point(insetH, separation*count + insetV), item);
						}else if(item.@realisationType.toString() == "Preview Outcome"){
							createNode("n15", new Point(insetH, separation*count + insetV), item);
						}
						break;
						
					case "Prepare":
						createNode("n16", new Point(insetH, separation*count + insetV), item);
						
					 	break;
					case "Feedback":
						createNode("n17", new Point(insetH, separation*count + insetV), item);
						
					 	break;
					case "Main Task":
						createNode("n18", new Point(insetH, separation*count + insetV), item);
						
					 	break;
					case "Access Views":
						createNode("n19", new Point(insetH, separation*count + insetV), item);
						
					 	break;
					case "MultipleChoice":
						createNode("n20", new Point(insetH, separation*count + insetV), item);
						
					 	break;
					case "Reflect":
						createNode("n21", new Point(insetH, separation*count + insetV), item);
						
					 	break;
						
		
				}
				count++;
			}
		}*/

		/*private function processGLO():void{
			GLOXML = new XML(
							 <patterns>
							 <pattern name={patternXML.@type} presentationStyle={patternXML.@presentationStyle} id="p1" type="glo">
							 </pattern>
							 </patterns>);
			allocateHeaders();
			allocateNodes();
			addColours();
			appendPages();
			
			patternXML = GLOXML;
			
			update("onXMLLoaded");
			parsePatternXML();
			
		}*/
		/*private function allocateHeaders():void{
			
			if(patternXML.@type == "EASA"){
				GLOXML.pattern.appendChild(<heading name="Orient" hFunction="Orient"></heading>);
				GLOXML.pattern.appendChild(<heading name="Understand" hFunction="Understand"></heading>);
				GLOXML.pattern.appendChild(<heading name="Use" hFunction="Use"></heading>);
			}
		}*/
		/*private function allocateNodes():void{
			if(patternXML.@type == "EASA"){
				
				for each(var page:XML in patternXML..page){
					
					switch(page.@type.toString()){
						case "Orient":
							GLOXML.pattern.heading.(@name == "Orient")[0].appendChild(<node name={page.@realisationType} nFunction={page.@type} id={"n"+nodeCount++}></node>);
		
							break;
						case "OrientElaborate":
							GLOXML.pattern.heading.(@name == "Orient")[0].appendChild(<node name={page.@realisationType} nFunction={page.@type} id={"n"+nodeCount++}></node>);

							break;
						case "ComprehendDefault":
							if(page.@realisationType.toString() == "Scenario"){
								GLOXML.pattern.heading.(@name == "Orient")[0].appendChild(<node name={page.@realisationType} nFunction={page.@type} id={"n"+nodeCount++}></node>);
							}else if(page.@realisationType.toString() == "undefined"){
								GLOXML.pattern.heading.(@name == "Understand")[0].appendChild(<node name="Comprehend" nFunction={page.@type} id={"n"+nodeCount++}></node>);

							}
							break;
						case "Apprehend":
							GLOXML.pattern.heading.(@name == "Understand")[0].appendChild(<node name="Apprehend" nFunction={page.@type} id={"n"+nodeCount++}></node>);

							break;
						case "SeeOverallEffect":
							GLOXML.pattern.heading.(@name == "Understand")[0].appendChild(<node name="See Overall Effect" nFunction={page.@type} id={"n"+nodeCount++}></node>);
							
							break;
						case "TryReflect":
							GLOXML.pattern.heading.(@name == "Understand")[0].appendChild(<node name="Try Reflect" nFunction={page.@type} id={"n"+nodeCount++}></node>);

							break;
						case "Construct":
							GLOXML.pattern.heading.(@name == "Use")[0].appendChild(<node name="Construct" nFunction={page.@type} id={"n"+nodeCount++}></node>);

							break;
						case "Construct 2":
							GLOXML.pattern.heading.(@name == "Use")[0].appendChild(<node name="Construct" nFunction={page.@type} id={"n"+nodeCount++}></node>);

							break;
						case "MultipleChoice":
							GLOXML.pattern.heading.(@name == "Use")[0].appendChild(<node name="Multiple Choice" nFunction={page.@type} id={"n"+nodeCount++}></node>);

							break;
					}
					
				}
			}
		}*/
/*		private function addColours():void{
			for each(var node:XML in GLOXML..node){
				
				  switch(node.parent().@hFunction.toString()){
					case "Orient":
						node.appendChild(<colour>{RED}</colour>);
						break;
					case "Understand":
						node.appendChild(<colour>{YELLOW}</colour>);
						break;
					case "Use":
						node.appendChild(<colour>{GREEN}</colour>);
						break;
				  }
			}
		}*/
		/*private function appendPages():void{
			var count = 0;
			for each(var node:XML in GLOXML..node){
				node.appendChild(patternXML..page[count]);
				count++;
			}
		}*/

	}
}