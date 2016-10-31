package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flash.geom.Point;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import model.Model;
import model.RegularSetting;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;


class Prob_panel extends FlxTypedGroup<FlxSprite>
{
	private var _prob_bar:FlxGroup;
	private var _prob_text:FlxGroup;
	
	private var _mybar:FlxBar;
	private var _otherbar:FlxBar;
	
	private var _amount:Int;
	private var _bar_item:FlxBar;
	private var _del:FlxText;
	
	private var _self_color:Int;
	
	public function new() 
	{
		super();
		
		_amount = 2;
		
		_prob_bar = new FlxGroup();
		creat_prob_bar(28, 170, _prob_bar);
		
		_prob_text = new FlxGroup();
		creat_prob_amount(400, 90, _prob_text);
		
		_del = new FlxText(470, 90, 170, "", 70, true);
		Model.font_format(_del, 70, FlxColor.WHITE, "center");
		_del.text = ":";
		//Model.font_Chinese_format(text, 24, FlxColor.WHITE, "left");
		add(_del);			
		
		//event
		
		
		Main._model.probNotify.add(prochange);
		appear(1);
	}
	
	private function appear(s:Dynamic):Void
	{
		_prob_bar.revive();
		_prob_text.revive();
		
		prob_update(_prob_text, ["0","0"]);
		prob_bar_update(_prob_bar, [0, 0]);
		//Main._model.adjust_item.dispatch(_del);
		//Main._model.adjust_item.dispatch(_prob_text.getFirstAlive());
		
	}
	
	private function disappear(s:Dynamic):Void
	{
		_prob_bar.kill();
		_prob_text.kill();
	}
	
	public function prochange(s:Dynamic):Void
	{
		var order:String = s[0];
		if ( order == "self_color")
		{
			var color:Int = s[1];
			_self_color = color;
			if (color == 3)
			{
				_mybar.createImageBar(null, AssetPaths.prob_green_bar__png);
				_otherbar.createImageBar(null, AssetPaths.prob_blue_bar__png);
			}
			else 
			{
				_mybar.createImageBar(null, AssetPaths.prob_blue_bar__png);
				_otherbar.createImageBar(null, AssetPaths.prob_green_bar__png);
			}
		}
		else if ( order == "update_vale")
		{
			var green_value:Int = s[1];
			var blue_value:Int = s[2];
			//prob_update(_prob_text, ["モンスター", "ハンター"]);
			if ( _self_color == 3 )
			{
				prob_bar_update(_prob_bar, [green_value, blue_value]);
				prob_update(_prob_text, [Std.string(green_value), Std.string(blue_value)]);
			}
			else
			{
				prob_bar_update(_prob_bar, [blue_value, green_value]);
				prob_update(_prob_text, [Std.string(blue_value), Std.string(green_value)]);
			}
		}
	}
	
	private function creat_prob_bar(_x:Float,_y:Float,target:FlxGroup):Void
	{
		var ColumnCnt:Int = 10;
		for (i in 0...(_amount))
		{
			var p:Point = RegularSetting.row_po(i, 10);
			var x:Float = _x + (p.x * 512) ;
			var y:Float = _y+ (p.y *40);
			
			var _bar:FlxBar;
			if ( i == 0)
			{
				_bar = new FlxBar(x, y, LEFT_TO_RIGHT, 512, 24);
				_bar.createImageBar(null, AssetPaths.prob_green_bar__png);
				_mybar = _bar;
			}
			else 
			{
				_bar = new FlxBar(x, y, RIGHT_TO_LEFT, 512, 24);
				_bar.createImageBar(null, AssetPaths.prob_blue_bar__png);
				_otherbar = _bar;
			}
			
			_bar.value = 0;
			add(_bar);
			target.add(_bar);
			_bar_item = _bar;
		}
		
	}
	
	private function prob_bar_update(target:FlxGroup,data:Array<Int>):Void
	{		
		var i:Int = 0;
		for ( mem in target)
		{
			var item:FlxBar = cast(mem, FlxBar);
			var k:Int = data[i];			
			//item.value = k;
			FlxTween.tween(item, { value: k },  1 );
			//item.updateFilledBar();
			i++;
		}
	}	
	
	private function prob_update(target:FlxGroup,data:Array<String>):Void
	{		
		var i:Int = 0;
		for ( mem in target)
		{
			var item:FlxText = cast(mem, FlxText);
			var value:Int = Std.parseInt(data[i]);
			//FlxG.log.add("-----------------"+value);
			item.text = data[i];
			//FlxTween.tween(item, { text: value },  1 );
			i++;
		}
	}	
	
	private function creat_prob_amount(_x:Float,_y:Float,target:FlxGroup):Void
	{
		var ColumnCnt:Int = 10;		
		for (i in 0...(_amount))
		{
			var p:Point = RegularSetting.row_po(i, 10);
			var x:Float = _x+ (p.x *135);			
			var y:Float = _y+ (p.y *34);
			
			var text = new FlxText(x, y, 170, "", 70, true);
			//Model.font_format(text,24, FlxColor.YELLOW, "right");
			Model.font_format(text, 70, FlxColor.WHITE, "center");
			//Model.font_Chinese_format(text, 24, FlxColor.WHITE, "left");
			add(text);			
			target.add(text);	
			
		}
	}
	
	
}