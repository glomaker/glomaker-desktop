package org.gloplayer.core
{
	import fr.kapit.puremvc.as3.multicore.patterns.facade.DebugFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * This class provides a conditional-compile directive to choose between
	 * the KapIT Debug-console enabled Facade and the standard PureMVC Multicore Facade.
	 * 
	 * Extend this Facade directly.
	 * 
	 * Update compiler directives in the Flex compiler settings as follows:
	 * FOR DEBUG: -define=CONFIG::release,false -define=CONFIG::debug,true
	 * FOR RELEASE: -define=CONFIG::release,false -define=CONFIG::debug,true
	 * 
	 * See http://lab.kapit.fr/display/puremvcconsole/Integration+Guide
	**/

    // Release version of the facade, extends Facade class from PureMVC
    CONFIG::release
    public class SwitchDebugFacade extends Facade
    {
      public function SwitchDebugFacade(key:String)
      {
        super(key);
      }
    }

    // Debug version of the facade, extends DebugFacade class from PureMVCKapit
    CONFIG::debug
    public class SwitchDebugFacade extends DebugFacade
    {
        public function SwitchDebugFacade(key:String)
        {
          super(key);
        }
    }

}