/*
 * @(#)Command.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.util {
import com.hotdraw.java.awt.*;
import com.hotdraw.java.util.*;

/**
 * Commands encapsulate an action to be executed. Commands have
 * a name and can be used in conjunction with <i>Command enabled</i>
 * ui components.
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld010.htm>Command</a></b><br>
 * Command is a simple instance of the command pattern without undo
 * support.
 * <hr>
 *
 * @see CommandButton
 * @see CommandMenu
 * @see CommandChoice
 */
public class Command {

    private var fName:String;

    /**
     * Constructs a command with the given name.
     */
    public function Command(name:String) {
        fName = name;
    }

    /**
     * Executes the command.
     */
    public function execute():void {;}

    /**
     * Tests if the command can be executed.
     */
    public function isExecutable():Boolean {
        return true;
    }

    /**
     * Gets the command name.
     */
    public function name():String {
        return fName;
    }
}
}