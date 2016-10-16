package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import model.Model;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;



class Timer extends FlxTypedGroup<FlxSprite>
{
	private var _ten:FlxSprite;
	private var _one:FlxSprite;
	
	private var _timer:FlxTimer;
	
	public function new() 
	{
		super();
		
		_ten = new FlxSprite(850, -60);
		_ten.loadGraphic(AssetPaths.time_numer__png, true, 160, 224);
		_ten.scale.set(0.45, 0.45);
		add(_ten);
		
		_one = new FlxSprite(906, -60);
		_one.loadGraphic(AssetPaths.time_numer__png, true, 160, 224);
		_one.scale.set(0.45, 0.45);
		add(_one);
		
		//event
		Main._model.Menu.add(appear);
		Main._model.playing.add(appear);
		Main._model.Settle.add(disappear);
		Main._model.credit.add(disappear);
		
		_timer = new FlxTimer();
		disappear(1);
		
		//Main._model.adjust_item.dispatch(_ten);
	}
	
	private function appear(s:Dynamic):Void
	{
		//Std.parseInt
		Main._model._remain_time = 60;
		_timer.start(1, timer_count, Main._model._remain_time);
	}
	
	private function disappear(s:Dynamic):Void
	{		
		_ten.kill();
		_one.kill();
		_timer.cancel();
	}
	
	private function timer_count(timer:FlxTimer):Void
	{		
		
		_ten.revive();
		_one.revive();
		var time_str:String =  Model.Format(timer.loopsLeft, 2);		
		
		var ten:String = time_str.substr(0, 1);
		var one:String = time_str.substr(1, 1);
		//FlxG.log.add("justPressed ============= ");
		
		_ten.animation.frameIndex = Std.parseInt(ten);
		_one.animation.frameIndex = Std.parseInt(one);
		
		Main._model.time_tick.dispatch(1);
		if ( timer.loopsLeft == 0)
		{			
			disappear(1);
		}
	}
	
	
	
}