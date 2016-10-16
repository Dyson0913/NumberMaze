package ;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import model.Model;

import flixel.input.touch.FlxTouchManager;
import flixel.addons.plugin.FlxMouseControl;

class Main extends Sprite
{
	public static var _model:Model;
	
	public function new()
	{
		super();
		
		_model = new Model();
	
		
		
		addChild(new FlxGame(1080, 1920, MenuState));
		FlxG.log.add("----widh = " + FlxG.stage.stageWidth);
		FlxG.log.add("----high = " + FlxG.stage.stageHeight);
		
		//FlxG.debugger.visible = true;
		#if (flash || js || desktop)
			FlxG.plugins.add(new FlxMouseControl());
		#end
	}
}