/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.properties.controls
{
	import mx.core.IUIComponent;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.IComponentProperty;
	
	public interface IPropertyControl extends IUIComponent
	{
		function assignProperty(prop:IComponentProperty, component:IComponentPlugin):void;
		function destroy():void;
		
		function get property():IComponentProperty;
		function get component():IComponentPlugin;
	}
}