package com.hotdraw.java.awt
{
	public class Color
	{
		
		  /**
     * The color white.  In the default sRGB space.
     */
    public static var white:Color= new Color(255, 255, 255);

    /**
     * The color white.  In the default sRGB space.
     */
    public  static var WHITE:Color= white;

    /**
     * The color light gray.  In the default sRGB space.
     */
    public static var lightGray:Color= new Color(192, 192, 192);

    /**
     * The color light gray.  In the default sRGB space.
     */
    public static var LIGHT_GRAY:Color= lightGray;

    /**
     * The color gray.  In the default sRGB space.
     */
    public static var gray:Color= new Color(128, 128, 128);

    /**
     * The color gray.  In the default sRGB space.
     */
    public static var GRAY:Color= gray;

    /**
     * The color dark gray.  In the default sRGB space.
     */
    public static var darkGray:Color= new Color(64, 64, 64);

    /**
     * The color dark gray.  In the default sRGB space.
     */
    public static var DARK_GRAY:Color= darkGray;

    /**
     * The color black.  In the default sRGB space.
     */
    public static var black:Color= new Color(0, 0, 0);
    
    /**
     * The color black.  In the default sRGB space.
     */
    public static var BLACK:Color= black;
    
    /**
     * The color red.  In the default sRGB space.
     */
    public static var red:Color= new Color(255, 0, 0);

    /**
     * The color red.  In the default sRGB space.
     */
    public static var RED:Color= red;

    /**
     * The color pink.  In the default sRGB space.
     */
    public static var pink:Color= new Color(255, 175, 175);

    /**
     * The color pink.  In the default sRGB space.
     */
    public static var PINK:Color= pink;

    /**
     * The color orange.  In the default sRGB space.
     */
    public static var orange:Color= new Color(255, 200, 0);

    /**
     * The color orange.  In the default sRGB space.
     */
    public static var ORANGE:Color= orange;

    /**
     * The color yellow.  In the default sRGB space.
     */
    public static var yellow:Color= new Color(255, 255, 0);

    /**
     * The color yellow.  In the default sRGB space.
     */
    public static var YELLOW:Color= yellow;

    /**
     * The color green.  In the default sRGB space.
     */
    public static var green:Color= new Color(0, 255, 0);

    /**
     * The color green.  In the default sRGB space.
     */
    public static var GREEN:Color= green;

    /**
     * The color magenta.  In the default sRGB space.
     */
    public static var magenta:Color= new Color(255, 0, 255);

    /**
     * The color magenta.  In the default sRGB space.
     */
    public static var MAGENTA:Color= magenta;

    /**
     * The color cyan.  In the default sRGB space.
     */
    public static var cyan:Color= new Color(0, 255, 255);

    /**
     * The color cyan.  In the default sRGB space.
     */
    public static var CYAN:Color= cyan;

    /**
     * The color blue.  In the default sRGB space.
     */
    public static var blue:Color= new Color(0, 0, 255);

    /**
     * The color blue.  In the default sRGB space.
     */
    public static var BLUE:Color= blue;
    
    private var red:Number = 0;
    private var green:Number = 0;
    private var blue:Number = 0;
    
		public function Color(r:Number,g:Number,b:Number){
		 red = r;
		 green = g;
		 blue = b;		
		}
		
		public function value():Number {
         return red << 16 ^ green << 8 ^ blue;
		}

	}
}