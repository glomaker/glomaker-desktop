package com.hotdraw.CH.ifa.draw.cursor
{
	import com.hotdraw.CH.ifa.draw.framework.Handle;
	import com.hotdraw.CH.ifa.draw.handles.EastHandle;
	import com.hotdraw.CH.ifa.draw.handles.NorthEastHandle;
	import com.hotdraw.CH.ifa.draw.handles.NorthHandle;
	import com.hotdraw.CH.ifa.draw.handles.NorthWestHandle;
	import com.hotdraw.CH.ifa.draw.handles.SouthEastHandle;
	import com.hotdraw.CH.ifa.draw.handles.SouthHandle;
	import com.hotdraw.CH.ifa.draw.handles.SouthWestHandle;
	import com.hotdraw.CH.ifa.draw.handles.WestHandle;
	
	public class MouseTheme{
		
		
		public static var w:int = 25;
		public static var h:int = 25;
		
		// Source of Mouse Pointers!
		// http://www.kde-look.org/content/show.php/Flat+White+Mouse+without+Shadow?content=6369
		
		[Embed(source="com/hotdraw/CH/ifa/draw/cursor/top_bottom.png")]
		public static var top_bottom:Class;

		[Embed(source="com/hotdraw/CH/ifa/draw/cursor/left_right.png")]
		public static var left_right:Class;

		[Embed(source="com/hotdraw/CH/ifa/draw/cursor/top_left_corner.png")]
		public static var top_left_corner:Class;
		
		[Embed(source="com/hotdraw/CH/ifa/draw/cursor/top_right_corner.png")]
		public static var top_right_corner:Class;
		
		[Embed(source="com/hotdraw/CH/ifa/draw/cursor/fleur.png")]
		public static var fleur:Class;
		
		[Embed(source="com/hotdraw/CH/ifa/draw/cursor/hand.png")]
		public static var hand:Class;

		[Embed(source="com/hotdraw/CH/ifa/draw/cursor/cross.png")]
		public static var cross:Class;
		
		public function MouseTheme()	{
		}
		
		// Returns the appropriate mouse cursor for each handle
		public static function getHandleMouseCursor(handle:*):Class{
			
			if(handle is SouthHandle || handle is NorthHandle) return top_bottom;
			if(handle is EastHandle || handle is WestHandle) return left_right;
			if(handle is NorthWestHandle || handle is SouthEastHandle)return top_left_corner;
			if(handle is NorthEastHandle || handle is SouthWestHandle)return top_right_corner;			
			
			
		return hand;
		}

	}
}