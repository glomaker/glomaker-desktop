package org.gloplayer.data.serialiser
{
	import flash.geom.Point;
	
	import org.glomaker.shared.patternmaker.IPatternNode;
	import org.gloplayer.data.PatternMakerNode;
	
	/**
	 * Utility method to serialise/deserialise an IPatternNode instance.  
	 * @author Nils
	 */	
	public class NodeSerialiser implements ISerialiser
	{

		public function serialise(object:Object):XML
		{
			var node:IPatternNode = object as IPatternNode;
			if(!node)	throw new Error("Object to serialise must be IPatternNode.");
			
			// serialise	
			var out:XML = <node>
							<locx>{node.loc.x}</locx>
							<locy>{node.loc.y}</locy>
							<root>{node.rootNode}</root>
							<hfunc>{node.hFunction}</hfunc>
							<ntitle>{node.nTitle}</ntitle>
							<active>{node.active}</active>
							<id>{node.id}</id>
							<originalid>{node.originalID}</originalid>
							<parent>{node.parent}</parent>
							<ntext>{node.nText}</ntext>
							<name>{node.name}</name>
							<colour>{node.colour}</colour>
							<nfunc>{node.nFunction}</nfunc>
							<drag>{node.drag}</drag>
							<hname>{node.hName}</hname>
							<receiver>{node.receiver}</receiver>
							<child>{node.child}</child>
							<gloref>{node.gloRef}</gloref>
							<page>{node.page}</page>							  
						  </node>;
			
			// done
			return out;
		}
		
		public function deserialise(source:XML):Object
		{
			var node:PatternMakerNode = new PatternMakerNode();

			if(source.hasOwnProperty("locx") && source.hasOwnProperty("locy"))
				node.loc = new Point(source.locx, source.locy);
				
			if(source.hasOwnProperty("root"))
				node.rootNode = (source.root == "true");
				
			if(source.hasOwnProperty("hfunc"))	
				node.hFunction = source.hfunc;

			if(source.hasOwnProperty("ntitle"))	
				node.nTitle = source.ntitle;

			if(source.hasOwnProperty("active"))	
				node.active = (source.active == "true");

			if(source.hasOwnProperty("id"))	
				node.id = source.id;
				
			if(source.hasOwnProperty("originalid"))	
				node.originalID = source.originalid;

			if(source.hasOwnProperty("parent"))	
				node.parent = source.parent;

			if(source.hasOwnProperty("ntext"))	
				node.nText = source.ntext;

			if(source.hasOwnProperty("name"))	
				node.name = source.name;

			if(source.hasOwnProperty("colour"))	
				node.colour = source.colour;

			if(source.hasOwnProperty("nfunc"))	
				node.nFunction = source.nfunc;

			if(source.hasOwnProperty("drag"))	
				node.drag = (source.drag == "true");

			if(source.hasOwnProperty("hname"))	
				node.hName = source.hname;

			if(source.hasOwnProperty("receiver"))	
				node.receiver = source.receiver;

			if(source.hasOwnProperty("child"))	
				node.child = source.child;

			if(source.hasOwnProperty("gloref"))	
				node.gloRef = source.gloref;
			
			try{
				// 'page' seems to be an XML node - we try and extract it from the source data
				// if the node isn't defined, this is going to fail, so code is wrapped in a try-catch block
				node.page = source.page.page[0]; 
			}catch(e:Error){}
			
			// done
			return node;
		}
		
	}
}