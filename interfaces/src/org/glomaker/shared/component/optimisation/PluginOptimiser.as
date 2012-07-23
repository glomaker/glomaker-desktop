/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.component.optimisation
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.ControlBar;
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.NumericStepper;
	import mx.controls.RadioButton;
	import mx.controls.SWFLoader;
	import mx.controls.Spacer;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.TileList;
	
	import org.glomaker.shared.component.BaseComponent;
	import org.glomaker.shared.component.utils.MissingImageSkin;
	import org.glomaker.shared.properties.AbstractCustomProperty;
	import org.glomaker.shared.properties.AbstractSimpleProperty;
	import org.glomaker.shared.properties.ArrayProperty;
	import org.glomaker.shared.properties.BooleanProperty;
	import org.glomaker.shared.properties.ColourProperty;
	import org.glomaker.shared.properties.FilePathArrayProperty;
	import org.glomaker.shared.properties.FilePathProperty;
	import org.glomaker.shared.properties.IComponentProperty;
	import org.glomaker.shared.properties.IntegerProperty;
	import org.glomaker.shared.properties.NumberProperty;
	import org.glomaker.shared.properties.NumericStepperProperty;
	import org.glomaker.shared.properties.RichTextProperty;
	import org.glomaker.shared.properties.StringProperty;
	import org.glomaker.shared.ui.DynamicTextArea;
	import org.glomaker.shared.ui.editbutton.EditableButton;
	import org.glomaker.shared.utils.MutableArray;
	
	public class PluginOptimiser
	{

		private var classIncludes:Array = [
					BaseComponent,
					
					IComponentProperty,
					AbstractSimpleProperty,
					AbstractCustomProperty,
					ArrayProperty,
					BooleanProperty,
					ColourProperty,
					FilePathArrayProperty,
					FilePathProperty,
					IntegerProperty,
					NumberProperty,
					NumericStepperProperty,
					RichTextProperty,
					StringProperty,
					
					Array,
					ArrayCollection,
					MissingImageSkin,
					MutableArray,
					
					JSON
				];
				
		private var uiIncludes:Array = [
					Label,
					TextArea,
					DataGrid,
					Image,
					NumericStepper,
					Text,
					SWFLoader,
					Button,
					Panel,
					Spacer,
					ControlBar,
					HBox,
					VBox,
					Canvas,
					List,
					TileList,
					CheckBox,
					RadioButton,
					EditableButton,
					DynamicTextArea
				];

	}
}