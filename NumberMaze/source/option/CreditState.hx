package option;


import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import visual_component.GameMenu;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import model.Model;
import model.RegularSetting;

import visual_component.GameInput;
import visual_component.Adjust_tool;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;


class CreditState extends FlxTransitionableState
{
	
	private var _gameMenu:GameMenu;
	
	override public function create():Void
	{
		super.create();
	
		_gameMenu = new GameMenu();
		_gameMenu.set_text(["back"], [this.back]);
		_gameMenu.init(400,800);
		add(_gameMenu);
		
		var arr:Array<String> = new Array<String>();
		arr.push("developer:dyson");
		arr.push("res: GameArtForge(Author) from http://opengameart.org/");
		
		for (i in 0...(2))
		{
			var p:Point = RegularSetting.col_position(i, 10);
			var x:Float = 100+ (p.x *135);			
			var y:Float = 100+ (p.y *100);
			
			var text:FlxText = new FlxText(x, y, 800, "", 70, true);
			//Model.font_format(text,24, FlxColor.YELLOW, "right");
			Model.font_format(text, 50, FlxColor.WHITE, "center");
			text.text = arr[i];
			//Model.font_Chinese_format(text, 24, FlxColor.WHITE, "left");
			add(text);			
		}
	}
	
	private function back():Void
	{
		var fanin:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		var fanout:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		
		FlxG.switchState(new MenuState(fanin,fanout));
	}
	

	
}