/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.core
{
	
	/**
	 * Stores GLO-Maker PureMVC notification names. 
	 * @author Nils
	 */	
	public class Notifications
	{
		
		// ------------------------------------------------------------------
		// STARTUP
		// ------------------------------------------------------------------
		
		/**
		 * Application startup notification.
		 * Body: GLO_v2 application instance. 
		 */		
		public static const APP_START:String = "App.Start";
		
		
		/**
		 * Status message informing of actions carried out during the startup process.
		 * Body: Message (:String)
		 */
		public static const APP_STARTUP_MESSAGE:String = "App.Startup.Message";
		
		
		/**
		 * Startup (loading) sequence has completed.
		 * Data is now available, all relevant mediators have been instantiated.
		 * Body: None. 
		 */
		public static const APP_STARTUP_COMPLETE:String = "App.Startup.Complete";
		
		/**
		 * Show the startup wizard.
		 * Body: None. 
		 */		
		public static const APP_SHOW_STARTUP_WIZARD:String = "App.Show.StartupWizard";
		
		/**
		 * The application has been invoked.
		 * This means that the application has just been launched or the user has chosen to open a GLO file with GLOMaker.
		 * Body: The InvokeEvent received by the invoke event handler. 
		 */		
		public static const APP_INVOKE:String = "App.Invoke";
		

		// ------------------------------------------------------------------
		// VIEW CHANGE
		// ------------------------------------------------------------------
		
		/**
		 * Show the patternmaker.
		 * Request might be blocked by SwitchToAppSectionCommand.
		 * Mediators should listen for ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION instead. 
		 */		
		public static const APP_REQUEST_SHOW_PATTERNMAKER:String = "App.Show.PatternMaker";

		/**
		 * Show the editor.
		 * Request might be blocked by SwitchToAppSectionCommand.
		 * Mediators should listen for ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION instead. 
		 */		
		public static const APP_REQUEST_SHOW_EDITOR:String = "App.Show.Editor";

		/**
		 * Show the preview player.
		 * Request might be blocked by SwitchToAppSectionCommand.
		 * Mediators should listen for ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION instead. 
		 */		
		public static const APP_REQUEST_SHOW_PLAYER:String = "App.Show.Player";
		
		public static const APP_SHOW_APPLICATION:String = "App.Show.Application";
		public static const APP_HIDE_APPLICATION:String = "App.Hide.Application";
		

		// ------------------------------------------------------------------
		// STATE MANIPULATION
		// ------------------------------------------------------------------
		
		/**
		 * Set application state to a new value.
		 * Body: New state (:uint, use static const properties on StateProxy) 
		 */		
		public static const APP_SET_STATE:String = "App.Set.State";
		
		
		/**
		 * Set application state to idle.
		 * Body: None. 
		 */		
		public static const APP_SET_STATE_IDLE:String = "App.Set.State.Idle";		
		
		
		// ------------------------------------------------------------------
		// EDITOR PAGE DRAW / REDRAW / SAVE
		// ------------------------------------------------------------------
		
		/**
		 * Application requests for a new page to be drawn.
		 * Body: Page definition (:PageInstanceVO)
		 */
		public static const APP_PAGE_DRAW:String = "App.Page.Draw";
		
		
		/**
		 * Application requests that the current page be saved.
		 * Body: None.
		 */
		public static const APP_SAVE_DATA:String = "App.Page.Save";
		
		
		/**
		 * Application notification - data displayed on the page should be refreshed.
		 * Body: None. 
		 */		
		public static const APP_REFRESH_DISPLAY:String = "App.RefreshDisplay";
		
		
		/**
		 * Requests that the component selection menu be shown.
		 * Body: None. 
		 */		
		public static const EDITOR_SHOW_COMPONENTMENU:String = "Editor.ShowComponentMenu";
		
		
		/**
		 * Requests that the page layout selection menu be shown.
		 * Body: None. 
		 */		
		public static const EDITOR_SHOW_LAYOUTMENU:String = "Editor.ShowLayoutMenu";
		
		
		/**
		 * Notifies the application that the EditorMediator (and therefore the entire Editor section) has been removed. 
		 */		
		public static const EDITOR_REMOVED:String = "Editor.Removed";

		
		
		// ------------------------------------------------------------------
		// APPLICATION EXIT
		// ------------------------------------------------------------------
		
		
		/**
		 * Triggers an immediate exit from the application.
		 * No data will be saved.
		 * Body: None.
		 */		
		public static const APP_FORCE_EXIT:String = "App.Force.Exit";
		
		
		/**
		 * Close all popup windows.
		 * Body: None. 
		 */		
		public static const APP_CLOSE_ALL_POPUPS:String = "App.Close.Popups";
		
		
		// ------------------------------------------------------------------
		// APPLICATION MENU
		// ------------------------------------------------------------------
		
		/**
		 * App controls - create new project.
		 * Body: none
		**/
		public static const CONTROLS_NEW:String = "Controls.New";
		
		/**
		 * App controls - open another project.
		 * Body: none 
		 */		
		public static const CONTROLS_OPEN:String = "Controls.Open";
		
		/**
		 * App controls - save current project.
		 * Body: none 
		 */		
		public static const CONTROLS_SAVE:String = "Controls.Save";


		/**
		 * App controls - save current project.
		 * Body: none 
		 */		
		public static const CONTROLS_SAVEAS:String = "Controls.SaveAs";
		

		/**
		 * App controls - export current project to player.
		 * Body: none 
		 */		
		public static const CONTROLS_EXPORT:String = "Controls.Export";
		

		/**
		 * App controls - exit from application.
		 * Body: none 
		 */		
		public static const CONTROLS_EXIT:String = "Controls.Exit";
		
		/**
		 * App menu controls - show the stage settings dialog.
		 * Body: None. 
		 */		
		public static const CONTROLS_SETTINGS_STAGE:String = "Controls.Settings.Stage";
		
		/**
		 * App menu controls - show the About GLOMaker popup.
		 * Body: None. 
		 */		
		public static const CONTROLS_ABOUT_GLOMAKER:String = "Controls.About.GloMaker";

		
		/**
		 * App menu controls - show the About GLOMaker popup.
		 * Body: None. 
		 */		
		public static const CONTROLS_ABOUT_LICENSE:String = "Controls.About.License";

		
		/**
		 * App menu controls - show the glomaker website.
		 * Body: None.
		 */		
		public static const CONTROLS_ABOUT_WEB:String = "Controls.About.Web";
		
		
		/**
		 * App menu controls - test method - trace current page layout to the debug console.
		 * Body: None; 
		 */		
		public static const CONTROLS_TRACE_LAYOUT:String = "Controls.Trace.Layout";


		/**
		 * App menu controls - test method - trace current pattern sequence to the debug console.
		 * Body: None; 
		 */		
		public static const CONTROLS_TRACE_PATTERN:String = "Controls.Trace.Pattern";



		// ------------------------------------------------------------------
		// FILE SAVING
		// ------------------------------------------------------------------
		
		/**
		 * App controls - user has selected the file the project should be saved under.
		 * Body: File object representing the new selection. 
		 */		
		public static const SAVEFILE_SELECT:String = "SaveFile.Select";

		
		/**
		 * App controls - user canceled save file selector.
		 * Body: File object associated with the file selector. 
		 */
		public static const SAVEFILE_CANCEL:String = "SaveFile.Cancel";
		
		
		// ------------------------------------------------------------------
		// FILE OPEN
		// ------------------------------------------------------------------
		
		
		/**
		 * File open - request the 'open file' selector to be shown.
		 * Body: None. 
		 */		
		public static const OPENFILE_SHOWSELECTOR:String = "OpenFile.ShowSelector";
		
		/**
		 * File open - user has selected a new file to open.
		 * Body: File object representing the new selection.
		 */		
		public static const OPENFILE_SELECTED:String = "OpenFile.Selected";

		
		/**
		 * File open - user has cancelled the file open selector.
		 */		
		public static const OPENFILE_CANCELLED:String = "OpenFile.Cancelled";

		/**
		 * File open process failed.
		 * Might be due to a corrupt file, insufficient user permissions, etc.
		 * Body: Error message.
		 */		
		public static const OPENFILE_FAILED:String = "OpenFile.Failed";


		// ------------------------------------------------------------------
		// FILE NEW
		// ------------------------------------------------------------------
		
		/**
		 * Requests that a brand-new project is created.
		 * Body: None.
		 */		
		public static const CREATE_NEW_PROJECT:String = "CreateNewProject";
		
		
		/**
		 * Pedagogical Pattern selected as part of the 'create new project' process.
		 * Body: PatternVO instance.
		 */		
		public static const CREATE_NEW_PATTERNSELECT:String = "CreateNewPatternSelect";
		
		
		/**
		 * The 'create new project' process was cancelled by the user.
		 * Body: None. 
		 */		
		public static const CREATE_NEW_CANCELLED:String = "CreateNewCancelled";
		
		
		// ------------------------------------------------------------------
		// EXPORT PROJECT
		// ------------------------------------------------------------------
		
		/**
		 * Prompt to show the directory selector for project export. 
		 */		
		public static const EXPORT_SHOWSELECTOR:String = "Export.Show.Selector";
		
		
		/**
		 * Export directory has been selected.
		 * Body: File instance pointing to the selected directory.
		 */		
		public static const EXPORT_DIR_SELECTED:String = "Export.Dir.Selected";		
		
		
		/**
		 * Export has completed.
		 * Body: None. 
		 */
		public static const EXPORT_COMPLETE:String = "Export.Complete";
		
		
		/**
		 * Export has failed.
		 * Body: Error message.
		 */		
		public static const EXPORT_FAILED:String = "Export.Failed";
		
		

		// ------------------------------------------------------------------
		// PATTERNMAKER INTEGRATION
		// ------------------------------------------------------------------
		

		/**
		 * Requests that PatternMaker data be stored by the application.
		 * Body: Array of IPatternNode instances describing current pattern. 
		 */		
		public static const APP_PATTERN_STOREDATA:String = "App.Pattern.StoreData";
		
		
		/**
		 * User has selected a different pattern.
		 * Body: PatternVO instance.
		 */		
		public static const APP_PATTERN_CHANGE:String = "App.Pattern.Change";
		
		
		// ------------------------------------------------------------------
		// EDITOR MODULE
		// ------------------------------------------------------------------
		
		/**
		 * User has selected a new page in the editor.
		 * Body: Index of selected item.
		**/
		public static const LIST_SELECT_ITEM:String = "List.Select.Item";
		
		
		/**
		 * User has selected an item from the component library.
		 * Body: data.ComponentVO instance that was selected.
		 */		
		public static const COMPONENT_LIBRARY_SELECT:String = "ComponentLibrary.Select";
		
				
		// ------------------------------------------------------------------
		// EDITOR - STAGE PROPERTY CHANGES
		// ------------------------------------------------------------------
		
		/**
		 * Change the current stage (from a list of Stage plugins)
		 * Body: StageVO 
		 */	
		public static const CHANGE_STAGE:String = "Change.Stage";
	
	     /**
		 * Change the current stage size
		 * Body: Size (used to store the size as Width Height) 
		 */	
		public static const CHANGE_STAGE_SIZE:String = "Change.Stage,Size";

	     /**
		 * Change the current stage color
		 * Body: uint  
		 */	
		public static const CHANGE_STAGE_COLOR:String = "Change.Stage,Color";


		// ------------------------------------------------------------------
		// EDITOR - PAGE NAVIGATION
		// ------------------------------------------------------------------
		
		/**
		 * Navigation request - go to previous slide.
		 * Body: None. 
		 */
		public static const NAV_REQUEST_PREVIOUS:String = "NavRequest.Previous";
		
		
		/**
		 * Navigation request - go to next slide.
		 * Body: None. 
		 */		
		public static const NAV_REQUEST_NEXT:String = "NavRequest.Next";
		
		
		/**
		 * Navigation request - go to a specific slide.
		 * Body: new page/slide index (:int) 
		 */		
		public static const NAV_REQUEST_GOTO:String = "NavRequest.Goto";
		
		
		// ------------------------------------------------------------------
		// EDITOR - HOTDRAW FUNCTIONALITY
		// ------------------------------------------------------------------
		
		/**
		 * HotDraw ToolDone notification,
		 * Body: None
		 */		
		public static const HOTDRAW_TOOLDONE:String = "HotDraw.ToolDone";
		
		/**
		 * HotDraw DrawingView Canvas created,
		 * Body: None
		 */		
		public static const HOTDRAW_STANDARDDRAWINGCANVASCREATED:String = "HotDraw.StandardDrawingCanvasCreated";

		/**
		 * HotDraw a single figure has been selected,
		 * Body: Figure
		 */		
		public static const HOTDRAW_FIGURESELECTED:String = "HotDraw.FigureSelected";
	
	    /**
		 * HotDraw clear the selection
		 * Body: Figure
		 */		
		 
		public static const HOTDRAW_CLEARSELECTION:String = "HotDraw.ClearSelection";
		
		
		// ------------------------------------------------------------------
		// EDITOR - PAGE LAYOUT
		// ------------------------------------------------------------------

		/**
		 * User has requested to change the layout of the page.
		 * This notification should be followed by a 'warning: all data will be lost' dialog.
		 * Body: New page (:PageVO)
		 */
		public static const PAGE_LAYOUT_REQUEST:String = "Page.Layout.Request";


		/**
		 * User has confirmed that they wish to change the layout of the page.
		 * Body: New page (:PageVO)
		 */
		public static const PAGE_LAYOUT_CONFIRM:String = "Page.Layout.Confirm";



		// ------------------------------------------------------------------
		// EDITOR - PAGE LAYOUT / CONTENT
		// ------------------------------------------------------------------
		
		/**
		 * A component has been added to the current page.
		 * This may or may not be a new component.
		 * Body: Component instance (:ComponentInstanceVO) 
		 */		
		public static const PAGE_ADD_COMPONENT:String = "Page.Add.Component";
		
		
		/**
		 * A component has been removed from the current page.
		 * Body: Component instance (:ComponentInstanceVO)
		 */		
		public static const PAGE_REMOVE_COMPONENT:String = "Page.Remove.Component";

		/**
		 * A component has  entered edit mode
		 * Body: Component instance (:ComponentProxyFigure)
		 */		
		public static const COMPONENT_EDIT_MODE:String = "Component.Edit.Mode";

		/**
		 * A component has changed to normal edit mode
		 * Body: None.
		 */		
		public static const COMPONENT_NORMAL_MODE:String = "Component.Normal.Mode";
		
		/**
		 * Component send back
		 * Body: Component
		 */		
		public static const COMPONENT_SENDBACK:String = "Component.SendBack";
		
	    /**
		 * Component send component front
		 * Body: Component
		 */		
		public static const COMPONENT_BRINGFRONT:String = "Component.BringFront";
		
		
		// ------------------------------------------------------------------
		// EDITOR - GUIDANCE
		// ------------------------------------------------------------------
		
		/**
		 * Turn the guidance feature on.
		 * Body: None. 
		 */		
		public static const EDITOR_GUIDANCE_ON:String = "Editor.Guidance.On";
		
		
		/**
		 * Turn the guidance feature off.
		 * Body: None. 
		 */		
		public static const EDITOR_GUIDANCE_OFF:String = "Editor.Guidance.Off";


		/**
		 * Show the guidance panel for a particular page.
		 * Body: PageInstanceVO. 
		 */		
		public static const EDITOR_GUIDANCE_SHOW:String = "Editor.Guidance.Show";
		
		/**
		 * Copy to Clipboard
		 * Body: None
		 */		
		public static const EDIT_COPY:String = "EDIT.COPY";

		/**
		 * Paste from Clipboard
		 * Body: None
		 */		
		public static const EDIT_PASTE:String = "EDIT.PASTE";

		/**
		 * Cut to Clipboard
		 * Body: None
		 */		
		public static const EDIT_CUT:String = "EDIT.CUT";
		
		
		
	}
}