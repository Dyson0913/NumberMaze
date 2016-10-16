package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import model.Model;

import flixel.util.FlxColor;
import flixel.input.FlxInput;

import flixel.system.scaleModes.RelativeScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.FillScaleMode;


class Adjust_tool extends FlxTypedGroup<FlxSprite>
{
	
	private var _test_btn:FlxButton;
	private var _test_btn2:FlxButton;
	private var _test_btn3:FlxButton;
	private var _test_btn4:FlxButton;	
	
	private var _control:FlxObject;
	
	private var _diff:Int = 10;
	
	public function new() 
	{
		super();
		FlxG.log.add("Adjust_tool init");
		
		Main._model.adjust_item.add(change);
		
		_test_btn = new FlxButton(400, 50, "+x", x);
		add(_test_btn);
		
		_test_btn2 = new FlxButton(300, 50, "-x", ng_x);
		add(_test_btn2);
		
		_test_btn3 = new FlxButton(350, 70, "+y", y);
		add(_test_btn3);
		
		_test_btn4 = new FlxButton(350, 30, "-y", ng_y);
		add(_test_btn4);
		
		//add(new FlxButton(100, 50, "test", pack_test));
		
		
	}
	
	private function pack_test():Void
	{
		//FlxG.scaleMode = new RelativeScaleMode(0.75, 0.75);
		//FlxG.scaleMode =new RatioScaleMode(true);
		
		//FlxG.scaleMode = new FillScaleMode();(true);
		//FlxG.resizeGame(1920, 1080);
		
		//FlxG.log.add("width = "+FlxG.stage.width);
		//FlxG.log.add("high = "+FlxG.stage.height);
		
	}
	
	private function change(s:Dynamic):Void
	{
		_control = s;
	}
	
	private function ng_x():Void
	{
		_control.x -= _diff;
		FlxG.log.add("item.x ="+_control.x);
		FlxG.log.add("item.y ="+_control.y);
	}
	
	private function x():Void
	{
		_control.x += _diff;
		FlxG.log.add("item.x ="+_control.x);
		FlxG.log.add("item.y ="+_control.y);
	}
	
	private function y():Void
	{
		_control.y += _diff;
		FlxG.log.add("item.x ="+_control.x);
		FlxG.log.add("item.y ="+_control.y);
	}
	
	private function ng_y():Void
	{
		_control.y -= _diff;
		FlxG.log.add("item.x ="+_control.x);
		FlxG.log.add("item.y ="+_control.y);
	}
	
	
	
}