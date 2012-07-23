/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import com.adobe.crypto.MD5;
	
	/**
	 * Utility class that provides validation code for GLO project files.
	 * Validation works by creating an md5 hash of the entire contents and storing it in the project XML.
	 * In order to validate, the tag storing the hash is removed, a new md5 hash is calculated and compared with the stored value.
	 * @author Nils
	 */
	final public class GLOProjectFileValidator
	{

		public static const VALIDATION_TAG_NAME:String = "filehash";


		/**
		 * Check whether a given project XML is valid.
		 * Make sure you call addValidationTag() for it first.
		 * 
		 * @param source
		 * @return 
		 */		
		public function validateProjectXML(source:XML):Boolean
		{
			// if no validation tag was found, then we can't validate, so assume invalid
			if(!hasValidationTag(source))
				return false;

			// quicker just to remove the validation tag and add it back again later
			// otherwise we'd have to copy the entire XML

			// store the hash value
			var sourceHashValue:String = source.child(VALIDATION_TAG_NAME);
			
			// (Back door) ... exception, ignore the process of validation if the key word ignore is found! (Musbah: 09July09) .. to allow people to edit the XML file manually
			if(sourceHashValue == "ignore")
			 return true;
			
			// remove it
			removeValidationTag(source);
			
			//
			var md5:String = calcDocumentHash(source);
			
			// add tag again
			source.appendChild(createValidationTag(sourceHashValue));
			
			// compare
			return (md5 == sourceHashValue);
		}
		
		public function addValidationTag(source:XML):void
		{
			// make sure existing validation tag isn't included in hash value
			if(hasValidationTag(source))
				removeValidationTag(source);

			// calc new hash value
			var hashValue:String = calcDocumentHash(source);
			
			// create validation tag
			
			
			// add it
			source.appendChild(createValidationTag(hashValue));
		}
		
		public function createValidationTag(hashValue:String):XML
		{
			var tag:XML = <tag/>;
			tag.setName(VALIDATION_TAG_NAME);
			tag.appendChild(hashValue);
			return tag;			
		}

		public function removeValidationTag(source:XML):void
		{
			delete source.child(VALIDATION_TAG_NAME)[0];
		}
		
		public function hasValidationTag(source:XML):Boolean
		{
			return (source.hasOwnProperty(VALIDATION_TAG_NAME));
		}
		
		public function calcDocumentHash(source:XML):String
		{
			return MD5.hash(source.toXMLString());
		}
		
		
	}
}