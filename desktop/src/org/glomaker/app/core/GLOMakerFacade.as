/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.core
{
	import mx.core.Application;
	
	import org.glomaker.app.controller.CleanupAfterEditorRemovalCommand;
	import org.glomaker.app.controller.HotDrawClearSelectionCommand;
	import org.glomaker.app.controller.HotDrawFigureSelectedCommand;
	import org.glomaker.app.controller.HotdrawViewCanvasCreated;
	import org.glomaker.app.controller.LaunchGlomakerWebsiteCommand;
	import org.glomaker.app.controller.MoveComponentAboveCommand;
	import org.glomaker.app.controller.MoveComponentBehindCommand;
	import org.glomaker.app.controller.NavRequestGotoCommand;
	import org.glomaker.app.controller.NavRequestNextCommand;
	import org.glomaker.app.controller.NavRequestPreviousCommand;
	import org.glomaker.app.controller.PageAddComponentCommand;
	import org.glomaker.app.controller.PageLayoutChangeCommand;
	import org.glomaker.app.controller.PageListSelectCommand;
	import org.glomaker.app.controller.PageRemoveComponentCommand;
	import org.glomaker.app.controller.ProcessPageSelectionCommand;
	import org.glomaker.app.controller.SelectPatternCommand;
	import org.glomaker.app.controller.ShowAboutCommand;
	import org.glomaker.app.controller.ShowComponentPopupCommand;
	import org.glomaker.app.controller.ShowGlomakerLicenseCommand;
	import org.glomaker.app.controller.ShowLayoutPopupCommand;
	import org.glomaker.app.controller.ShowPageLayoutWarningCommand;
	import org.glomaker.app.controller.ShowStagePropertyPopup;
	import org.glomaker.app.controller.StageChangeCommand;
	import org.glomaker.app.controller.StageColorCommand;
	import org.glomaker.app.controller.StageResizeCommand;
	import org.glomaker.app.controller.SwitchToAppSectionCommand;
	import org.glomaker.app.controller.TracePageLayoutCommand;
	import org.glomaker.app.controller.TracePatternSequenceCommand;
	import org.glomaker.app.controller.UpdateAndCreatePagesCommand;
	import org.glomaker.app.controller.createnew.CreateFromPatternMacroCommand;
	import org.glomaker.app.controller.createnew.HandleCreateProjectCancelledCommand;
	import org.glomaker.app.controller.createnew.NewProjectMacroCommand;
	import org.glomaker.app.controller.createnew.ShowCreateWizardCommand;
	import org.glomaker.app.controller.exit.ExitNoSaveCommand;
	import org.glomaker.app.controller.exit.ExitWithSaveMacroCommand;
	import org.glomaker.app.controller.export.DoProjectExportCommand;
	import org.glomaker.app.controller.export.SelectExportLocationCommand;
	import org.glomaker.app.controller.export.ShowExportCompleteMessageCommand;
	import org.glomaker.app.controller.export.ShowExportFailedMessageCommand;
	import org.glomaker.app.controller.guidance.GuidanceOffCommand;
	import org.glomaker.app.controller.guidance.GuidanceOnCommand;
	import org.glomaker.app.controller.guidance.ShowGuidancePanelCommand;
	import org.glomaker.app.controller.invoke.HandleAppInvokeCommand;
	import org.glomaker.app.controller.open.FileOpenMacroCommand;
	import org.glomaker.app.controller.open.HandleFileOpenCancelledCommand;
	import org.glomaker.app.controller.open.HandleFileOpenFailedCommand;
	import org.glomaker.app.controller.open.LoadNewFileCommand;
	import org.glomaker.app.controller.open.SelectFileToOpenCommand;
	import org.glomaker.app.controller.save.SaveAsCommand;
	import org.glomaker.app.controller.save.SaveCommand;
	import org.glomaker.app.controller.save.SaveFileSelectCommand;
	import org.glomaker.app.controller.startup.AppStartupMacroCommand;
	import org.glomaker.app.controller.startup.ShowStartupWizardCommand;
	import org.glomaker.app.controller.startup.StartupProgressCommand;
	import org.glomaker.app.controller.state.SetIdleStateCommand;
	import org.glomaker.app.controller.state.SetStateCommand;
	import org.glomaker.app.model.PluginProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * PureMVC Facade implementation for GLO-Maker
	 * 
	 * Implements the Singleton interface.
	 *  
	 * @author Nils
	 */
	public class GLOMakerFacade extends Facade
	{


		/**
		 * Return multiton instance. 
		 * @return 
		 */
		public static function getInstance(key:String):GLOMakerFacade
		{
			if(!hasCore(key))
			{
				instanceMap[key] = new GLOMakerFacade(key);
			}
			
			return instanceMap[key] as GLOMakerFacade;
		}
		
		public function GLOMakerFacade(key:String)
		{
			super(key);
		}


		/**
		 * Application startup function.
		 * @param appRef Reference to the main application instance.
		 */
		public static function start(appKey:String, appRef:Application):void
		{
			getInstance(appKey).sendNotification(Notifications.APP_START, appRef);
		}
		
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			// startup command
			// Note: No Mediators registered at this stage
			registerCommand(Notifications.APP_START, AppStartupMacroCommand);
			
			// application invoke
			registerCommand(Notifications.APP_INVOKE, HandleAppInvokeCommand);
			
			// state manipulation
			registerCommand(Notifications.APP_SET_STATE, SetStateCommand);
			registerCommand(Notifications.APP_SET_STATE_IDLE, SetIdleStateCommand);
			
			// application section change
			registerCommand(Notifications.APP_REQUEST_SHOW_PATTERNMAKER, SwitchToAppSectionCommand);
			registerCommand(Notifications.APP_REQUEST_SHOW_EDITOR, SwitchToAppSectionCommand);
			registerCommand(Notifications.APP_REQUEST_SHOW_PLAYER, SwitchToAppSectionCommand);
			
			// application startup sequence
			// Note: No Mediators registered at this stage
			registerCommand(PluginProxy.DISCOVERING, StartupProgressCommand);
			registerCommand(PluginProxy.DISCOVERY_COMPLETE, StartupProgressCommand);
			
			registerCommand(Notifications.APP_SHOW_STARTUP_WIZARD, ShowStartupWizardCommand);
			registerCommand(Notifications.APP_STARTUP_COMPLETE, ShowStartupWizardCommand);
			
			// MENU COMMANDS
			registerCommand(Notifications.CONTROLS_SAVE, SaveCommand);
			registerCommand(Notifications.CONTROLS_SAVEAS, SaveAsCommand);
			registerCommand(Notifications.SAVEFILE_SELECT, SaveFileSelectCommand);
			registerCommand(Notifications.CONTROLS_EXIT, ExitWithSaveMacroCommand);
			
			// exit
			registerCommand(Notifications.APP_FORCE_EXIT, ExitNoSaveCommand);
			
			// open
			registerCommand(Notifications.CONTROLS_OPEN, FileOpenMacroCommand);
			registerCommand(Notifications.OPENFILE_SHOWSELECTOR, SelectFileToOpenCommand);
			registerCommand(Notifications.OPENFILE_SELECTED, LoadNewFileCommand);
			registerCommand(Notifications.OPENFILE_CANCELLED, HandleFileOpenCancelledCommand);
			registerCommand(Notifications.OPENFILE_FAILED, HandleFileOpenFailedCommand);
			
			
			// create
			registerCommand(Notifications.CONTROLS_NEW, NewProjectMacroCommand);
			registerCommand(Notifications.CREATE_NEW_PROJECT, ShowCreateWizardCommand);
			registerCommand(Notifications.CREATE_NEW_PATTERNSELECT, CreateFromPatternMacroCommand);
			registerCommand(Notifications.CREATE_NEW_CANCELLED, HandleCreateProjectCancelledCommand);
			
			// export
			registerCommand(Notifications.CONTROLS_EXPORT, SelectExportLocationCommand);
			registerCommand(Notifications.EXPORT_SHOWSELECTOR, SelectExportLocationCommand);
			registerCommand(Notifications.EXPORT_DIR_SELECTED, DoProjectExportCommand);
			
			registerCommand(Notifications.EXPORT_COMPLETE, ShowExportCompleteMessageCommand);
			registerCommand(Notifications.EXPORT_FAILED, ShowExportFailedMessageCommand);
			
			// settings menu
			registerCommand(Notifications.CONTROLS_SETTINGS_STAGE, ShowStagePropertyPopup);
			
			// about menu
			registerCommand(Notifications.CONTROLS_ABOUT_GLOMAKER, ShowAboutCommand);
			registerCommand(Notifications.CONTROLS_ABOUT_LICENSE, ShowGlomakerLicenseCommand);
			registerCommand(Notifications.CONTROLS_ABOUT_WEB, LaunchGlomakerWebsiteCommand);
			
			// page layouts
			registerCommand(Notifications.EDITOR_SHOW_COMPONENTMENU, ShowComponentPopupCommand);
			registerCommand(Notifications.EDITOR_SHOW_LAYOUTMENU, ShowLayoutPopupCommand);
			registerCommand(Notifications.PAGE_LAYOUT_REQUEST, ShowPageLayoutWarningCommand);
			registerCommand(Notifications.PAGE_LAYOUT_CONFIRM, PageLayoutChangeCommand);
			
/* 	for testing / advanced users */
			registerCommand(Notifications.CONTROLS_TRACE_LAYOUT, TracePageLayoutCommand);
			registerCommand(Notifications.CONTROLS_TRACE_PATTERN, TracePatternSequenceCommand);
 			
			// editor removed entirely
			registerCommand(Notifications.EDITOR_REMOVED, CleanupAfterEditorRemovalCommand);
			
			//
			registerCommand(Notifications.LIST_SELECT_ITEM, PageListSelectCommand);
			
			// navigation requests - all routed through one command
			registerCommand(Notifications.NAV_REQUEST_PREVIOUS, NavRequestPreviousCommand);
			registerCommand(Notifications.NAV_REQUEST_NEXT, NavRequestNextCommand);
			registerCommand(Notifications.NAV_REQUEST_GOTO, NavRequestGotoCommand);
			
			// new page was selected
			registerCommand(SelectionProxy.SELECTED_PAGE_UPDATED, ProcessPageSelectionCommand);
			
			// HotDraw
			registerCommand(Notifications.HOTDRAW_STANDARDDRAWINGCANVASCREATED, HotdrawViewCanvasCreated);
		
			// Page components
			registerCommand(Notifications.PAGE_ADD_COMPONENT, PageAddComponentCommand);
			registerCommand(Notifications.PAGE_REMOVE_COMPONENT, PageRemoveComponentCommand);
			
			// Pattern Maker
			registerCommand(Notifications.APP_PATTERN_STOREDATA, UpdateAndCreatePagesCommand);
			registerCommand(Notifications.APP_PATTERN_CHANGE, SelectPatternCommand);
			
			// HotDraw State Proxy Commands
			registerCommand(Notifications.HOTDRAW_FIGURESELECTED, HotDrawFigureSelectedCommand);
			registerCommand(Notifications.HOTDRAW_CLEARSELECTION, HotDrawClearSelectionCommand);
			// When the size of the stage changes
			registerCommand(Notifications.CHANGE_STAGE_SIZE, StageResizeCommand);
			// When the stage color changes
			registerCommand(Notifications.CHANGE_STAGE_COLOR, StageColorCommand);
			// when user selects a new stage
			registerCommand(Notifications.CHANGE_STAGE, StageChangeCommand);
			
			// guidance
			registerCommand(Notifications.EDITOR_GUIDANCE_ON, GuidanceOnCommand);
			registerCommand(Notifications.EDITOR_GUIDANCE_OFF, GuidanceOffCommand);
			registerCommand(Notifications.EDITOR_GUIDANCE_SHOW, ShowGuidancePanelCommand);
			
			// component layering
			registerCommand(Notifications.COMPONENT_BRINGFRONT, MoveComponentAboveCommand);
			registerCommand(Notifications.COMPONENT_SENDBACK, MoveComponentBehindCommand);
		}
		
	}
}