package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flixel.FlxG;
import flixel.addons.display.FlxExtendedSprite;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import model.*;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import openfl.geom.Point;


class StatisticBoard extends FlxTypedGroup<FlxSprite>
{
	private var _flip_card:FlxExtendedSprite;
	private var _flip_idx:Int;
	private var _flip_color:Int;
	private var _flip_Number:Int;
	private var _greens_side:Int;
	
	private var _amount:Int = 4;
	private var _RowCount:Int = 8;
	
	private var _frameSide:Int;
	
	public function new() 
	{
		super();
		
		_flip_idx = 0;
		
		//event
		Main._model.Menu.add(appear);
		Main._model.playing.add(appear);
		Main._model.Settle.add(disappear);
		Main._model.credit.add(disappear);
		
		_frameSide = 0;
		
		Main._model.StaticNotify.add(notify);
	}
	
	private function appear(s:Dynamic):Void
	{		
		
	}
	
	private function disappear(s:Dynamic):Void
	{		
		
	}
	
	private function notify(s:Dynamic):Void
	{
		var order:String = s[0];
		if ( order == "first_hand")
		{
			_flip_color = s[1];
			_flip_Number = s[2];
			
			//
			if (_flip_color == 3) 
			{
				_greens_side = 3;
				
				//更新BAR color
			}
			else 
			{
				_greens_side = 4;
			}
			
			
		}
		if ( order == "Flip_over")
		{
			
			_frameSide = (_frameSide +1) % 2;
			Main._model.TurnOverNotify.dispatch(["TurnOver",_frameSide]);
		}
		
	}
	
}