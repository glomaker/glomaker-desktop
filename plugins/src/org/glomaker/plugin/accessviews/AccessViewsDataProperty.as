/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.accessviews
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.glomaker.plugin.accessviews.files.TopicData;
	import org.glomaker.shared.properties.AbstractCustomProperty;

	public class AccessViewsDataProperty extends AbstractCustomProperty
	{
		
		[Bindable]
        public var _topics:ArrayCollection;
            
        [Bindable]
        public var _speakers:ArrayCollection;
        
        private var speakerCount:Number = 1;
        private var topicCount:Number = 1;
        
		public function AccessViewsDataProperty(name:String, label:String=null, value:Object=null)
		{
			super(name, label, value);
			
			_topics = new ArrayCollection([new TopicData("Topic 1","Topic_1")]);
			_speakers = new ArrayCollection([new SpeakerData("Speaker 1")]);
		}
		
		public function addSpeaker():void{
			 var i:int = ++speakerCount;
			//_speakers.addItem(new SpeakerData("Speaker " + i)); 
			_speakers.addItem(new SpeakerData("Speaker " + (_speakers.length+1))); 
			               
		}
		
		public function addTopic():void{
			 var i:int = ++topicCount;
			//_topics.addItem(new TopicData("Topic " + i,"Topic_"+i)); 
			_topics.addItem(new TopicData("Topic " + (_topics.length+1),"Topic_"+i)); 
			               
		}
		
		public function removeSpeaker(index:int):void{
			_speakers.removeItemAt(index);
		}
		
		public function removeTopic(index:int):void{
			// before removing the topic, delete all associated sounds from speakers
			var topicData:TopicData = TopicData(_topics.getItemAt(index));
		    for each(var speaker:SpeakerData in _speakers){
				delete speaker.sounds[topicData.id];
			}
			// Now remove the topic
			_topics.removeItemAt(index);
		}
		
		
		public function changeSpeakerImage(speakerIndex:int,source:String):void{
			var speakerData:SpeakerData = SpeakerData(_speakers.getItemAt(speakerIndex));
			speakerData.imageSource = source;
		}
		
		public function changeSpeakerTopicScript(speakerIndex:int,topicIndex:int,source:String):void{
			var speakerData:SpeakerData = SpeakerData(_speakers.getItemAt(speakerIndex));
			var topicData:TopicData = TopicData(_topics.getItemAt(topicIndex));
			speakerData.scripts[topicData.id] = source;
		}

		public function changeSpeakerTopicSound(speakerIndex:int,topicIndex:int,source:String):void{
			var speakerData:SpeakerData = SpeakerData(_speakers.getItemAt(speakerIndex));
			var topicData:TopicData = TopicData(_topics.getItemAt(topicIndex));

			speakerData.sounds[topicData.id] = source;
		}
		 
		public function getSpeakerTopicScript(speakerIndex:int,topicIndex:int): String{
			
			var speakerData:SpeakerData = SpeakerData(_speakers.getItemAt(speakerIndex));
			var topicData:TopicData = TopicData(_topics.getItemAt(topicIndex));

			return speakerData.scripts[topicData.id];
		}

		public function getSpeakerTopicSound(speakerIndex:int,topicIndex:int): String{
			
			var speakerData:SpeakerData = SpeakerData(_speakers.getItemAt(speakerIndex));
			var topicData:TopicData = TopicData(_topics.getItemAt(topicIndex));

			return speakerData.sounds[topicData.id];
		}
		
		override public function serialiseToXML(parentNode:XML):void{
			var tag:XML;
			var topic:TopicData;
			
			// serialise class data
			tag = <internalData speakerCount={JSON.encode(speakerCount)} topicCount={JSON.encode(topicCount)}></internalData>;
			parentNode.appendChild( tag );


			// serialise speakers
		    for each(var speaker:SpeakerData in _speakers){
				tag = <speaker title={JSON.encode(speaker.title)}></speaker>;
				tag.appendChild(serialiseFilePath(speaker.imageSource,"image"));
				var subTag:XML;
					// serialise sounds for each topic avaiable
		    		for each(topic in _topics){
		    			if(speaker.sounds[topic.id])
		    				subTag = serialiseFilePath(speaker.sounds[topic.id],"sound");
		    			else
		    				subTag = serialiseFilePath("","sound");
		    			subTag.@id = JSON.encode(topic.id)
						tag.appendChild( subTag );
					}

					// serialise script for each topic avaiable
		    		for each(topic in _topics){
		    			if(speaker.scripts[topic.id])
		    				subTag = serialiseFilePath(speaker.scripts[topic.id],"script");
		    			else
		    				subTag = serialiseFilePath("","script");
		    			subTag.@id = JSON.encode(topic.id)
						tag.appendChild( subTag );
					}

				parentNode.appendChild( tag );
			}

			// serialise speakers
		    for each(topic in _topics){
				tag = <topic id={JSON.encode(topic.id)} data={JSON.encode(topic.data)}></topic>;
				parentNode.appendChild( tag );
			}

	} 
		
		override public function deserialiseFromXML(value:XML):void{
			
			_speakers = new ArrayCollection();
			_topics = new ArrayCollection();

			// deserialise speakers
			
			for each(var speaker:XML in value.speaker){
				var sData:SpeakerData = new SpeakerData(JSON.decode(speaker.@title));
				//sData.imageSource = deserialiseFilePath(speaker.image);
				sData.imageSource = JSON.decode(speaker.image.text());
				        // deserialise sounds
						for each(var sound:XML in speaker.sound){
							sData.sounds[JSON.decode(sound.@id)] = JSON.decode(sound.text());
						}
						
				        // deserialise scripts
						for each(var script:XML in speaker.script){
							sData.scripts[JSON.decode(script.@id)] = JSON.decode(script.text());
						}

				_speakers.addItem(sData);
			}
			// deserialise topics
			for each(var topic:XML in value.topic){
				var tData:TopicData = new TopicData(JSON.decode(topic.@data),JSON.decode(topic.@id));
				_topics.addItem(tData);
			}
			
			// deserialise class data
			speakerCount = JSON.decode(value.internalData.@speakerCount) as Number;
			topicCount = JSON.decode(value.internalData.@topicCount) as Number;
			
		}
		

	}
}