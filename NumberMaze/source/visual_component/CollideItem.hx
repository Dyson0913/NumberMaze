package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flash.geom.Point;
import flixel.addons.display.FlxExtendedSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

import model.Model;
import model.RegularSetting;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class CollideItem extends FlxTypedGroup<FlxSprite>
{
	public var group( default, null ):FlxGroup;
	
	public function new() 
	{
		super();
		
		group = new FlxGroup();
		var shift:Float = 50;
		for (i in 0...(50))
		{
			var p:Point = RegularSetting.row_po(i, 10);
			
			if ( p.y  % 2 == 0) shift = 70;
			else shift = 0;
			
			var x:Float = 654 + (p.x * 130) + shift;			
			var y:Float = 421 + (p.y * 110);
			
			var item:FlxExtendedSprite = new FlxExtendedSprite(x, y);			
			item.loadGraphic(AssetPaths.Number_Blocks_01_Set_2_128x128_0__png);						
			item.scale.set(0.5, 0.5);
			item.immovable = true;
			add(item);
			group.add(item);
			RegularSetting.set_debug(item);
		}
		
		
	}
	
	private function appear(s:Dynamic):Void
	{		
		
		
	}
	
	private function disappear(s:Dynamic):Void
	{		
		
	}
	
	
	
	
	
}