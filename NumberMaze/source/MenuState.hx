package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import visual_component.GameInput;
import visual_component.GameMenu;
import visual_component.Adjust_tool;

class MenuState extends FlxState
{
	private var _gameMenu:GameMenu;
	private var _gameinput:GameInput;
	
	private var _adjust:Adjust_tool;
	
	override public function create():Void
	{
		super.create();
		
		_adjust = new Adjust_tool();
		
		_gameMenu = new GameMenu();
		add(_gameMenu);
		
		_gameinput = new GameInput();
		add(_gameinput);
		
		
		
		
		Main._model.Menu.dispatch(1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}