/*
 * @(#)PaletteListener.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.util {
/**
 * Interface for handling palette events.
 *
 * @see PaletteButton
 */

public interface PaletteListener {
    /**
     * The user selected a palette entry. The selected button is
     * passed as an argument.
     */
    function paletteUserSelected(button:PaletteButton):void ;

    /**
     * The user moved the mouse over the palette entry.
     */
    function paletteUserOver(button:PaletteButton, inside:Boolean):void ;
}
}