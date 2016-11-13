package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.addons.transition.TransitionData;

import visual_component.GameInput;
import visual_component.GameMenu;
import visual_component.Adjust_tool;

import flixel.addons.transition.FlxTransitionableState;

class MenuState extends FlxTransitionableState
{
	private var _gameMenu:GameMenu;
	private var _gameinput:GameInput;
	
	private var _adjust:Adjust_tool;
	
	override public function create():Void
	{
		super.create();
		
		_adjust = new Adjust_tool();
		
		_gameMenu = new GameMenu();
		_gameMenu.set_text(["singlePlay", "Multiplay", "Credit"], [this.singlplayer, this.multiplayer, this.credit]);
		_gameMenu.init();
		add(_gameMenu);
		
		_gameinput = new GameInput();
		add(_gameinput);
		
		Main._model.Menu.dispatch(1);
	}

	private function singlplayer():Void
	{
		var fanin:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		var fanout:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		
		//#if (flash )
		//_file.load();
		//#else
		FlxG.switchState(new QuickState(fanin, fanout));
		
		//#end
	}
	
	private function multiplayer():Void
	{
		
	}
	
	private function credit():Void
	{
		var fanin:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		var fanout:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		
		//FlxG.switchState(new CreditState(fanin,fanout));
	}
	
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}