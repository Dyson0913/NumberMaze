package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

import model.RegularSetting;
import flixel.tweens.FlxTween;

class GroupComponent extends FlxTypedGroup<FlxSprite>
{
	public var group( default, null ):FlxGroup;
	
	public var cd_group:FlxGroup;
	
	public function new() 
	{
		super();
		
		group = new FlxGroup();
		for (i in 0...(3))
		{
			var item:FlxSprite = new FlxSprite(i * 140 +1300, 0,AssetPaths.trature__png);
			item.kill();
			add(item);
			group.add(item);
		}
		
		
		
		disappear(1);
	}
	
	private function appear(s:Dynamic):Void
	{		
		group.forEach(RegularSetting.group_show);		
	}
	
	private function disappear(s:Dynamic):Void
	{
		group.forEach(RegularSetting.group_hide);
	}
	
	public function one_item_avalible(Tween:FlxTween):Void
	{
		Start_CD();
	}
	
}