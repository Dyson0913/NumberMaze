package option;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;

import visual_component.GameInput;
import visual_component.Adjust_tool;
import flixel.addons.transition.FlxTransitionableState;

class CharSelectState extends FlxTransitionableState
{
	private var _gameinput:GameInput;
	
	private var _adjust:Adjust_tool;
	
	override public function create():Void
	{
		super.create();
		
		_adjust = new Adjust_tool();
		
		
		_gameinput = new GameInput();
		add(_gameinput);
		
		_gameinput.mouse_pressed.add(click);
		_gameinput.A.add(click);
		
		_gameinput.left.add(left);
		_gameinput.right.add(right);
		_gameinput.up.add(up);
		
		_gameinput.left_release.add(cancel);
		_gameinput.right_release.add(cancel);
		_gameinput.up_release.add(cancel);
		
		
		Main._model.credit.dispatch(1);
		
		
		//add(_adjust);
		//Main._model.adjust_item.dispatch(_right);
	}
	
	private function left(s:Dynamic):Void
	{
		
	}
	
	private function right(s:Dynamic):Void
	{
		
	}
	
	private function up(s:Dynamic):Void
	{
		
	}
	
	private function click(s:Dynamic):Void
	{
		
		
	}
	
	private function cancel(s:Dynamic):Void
	{
		
	}
	
	override public function update(elapsed:Float):Void
	{
		
		
		super.update(elapsed);
	}
	
}