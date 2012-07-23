package org.gloplayer.data.serialiser
{
	public interface ISerialiser
	{
		function serialise(object:Object):XML;
		function deserialise(source:XML):Object;
	}
}