package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

import model.Model;

class GameInput extends FlxTypedGroup<FlxSprite>
{
	private var _up:FlxSprite;
	//private var _down:FlxSprite;
	private var _left:FlxSprite;
	private var _right:FlxSprite;
	
	
	
	//event
	public var mouse_pressed = new Signal<Dynamic>();
	public var mouse_release = new Signal<Dynamic>();
	
	public var up = new Signal<Dynamic>();
	public var down = new Signal<Dynamic>();
	public var left = new Signal<Dynamic>();
	public var right = new Signal<Dynamic>();
	
	public var up_release = new Signal<Dynamic>();
	public var down_release = new Signal<Dynamic>();
	public var left_release = new Signal<Dynamic>();
	public var right_release = new Signal<Dynamic>();
	
	
	public var _shot(default,default):FlxSprite;
	
	public var A = new Signal<Dynamic>();
	public var B = new Signal<Dynamic>();
	
	public var A_release = new Signal<Dynamic>();
	
	public function new() 
	{
		super();
		
		_up = new FlxSprite(200, 854);
		_up.loadGraphic(AssetPaths.direction_arrow__png, true, 88, 88);
		_up.animation.frameIndex = 0;
		_up.scale.set(2, 2);
		add(_up);
		
		//_down = new FlxSprite(120, 994);
		//_down.loadGraphic(AssetPaths.direction_arrow__png, true, 88, 88);
		//_down.animation.frameIndex = 2;
		//add(_down);
		
		_left = new FlxSprite(44, 964);
		_left.loadGraphic(AssetPaths.direction_arrow__png, true, 88, 88);
		_left.animation.frameIndex = 3;
		_left.scale.set(2, 2);
		add(_left);
		
		_right = new FlxSprite(350, 964);
		_right.loadGraphic(AssetPaths.direction_arrow__png, true, 88, 88);
		_right.animation.frameIndex = 1;
		_right.scale.set(2, 2);
		add(_right);
		
		_shot = new FlxSprite(1790, 910).loadGraphic(AssetPaths.Letter_Blocks_01_Set_2_A_128x128__png);
		_shot.scale.set(3, 3);
		add(_shot);
		
		disappear(1);
		
		//event
		Main._model.Menu.add(disappear);
		Main._model.SelectRole.add(disappear);
		Main._model.playing.add(appear);
		Main._model.Settle.add(disappear);
		
		//Main._model.adjust_item.dispatch(_shot);
	}
	
	private function appear(s:Dynamic):Void
	{
		//_up.revive();
		//_down.revive();
		//_left.revive();
		//_right.revive();
		//
		//_shot.revive();
	}
	
	private function disappear(s:Dynamic):Void
	{		
		_up.kill();
		//_down.kill();
		_left.kill();
		_right.kill();
		
		_shot.kill();
	}
	
	override public function update(elapsed:Float):Void
	{
		#if (flash || js || desktop)
		if (FlxG.mouse.pressed) 
		{
			//_ball.fireFromAngle(_speed);
			
			mouse_pressed.dispatch();
		}
		
		if (FlxG.mouse.justPressed) {}
		if (FlxG.mouse.justReleased) 
		{
			
		}
		
		if (FlxG.keys.pressed.LEFT) left.dispatch();
		if (FlxG.keys.justReleased.LEFT) left_release.dispatch();
		
		if (FlxG.keys.pressed.RIGHT) right.dispatch();
		if (FlxG.keys.justReleased.RIGHT) right_release.dispatch();
		
		if (FlxG.keys.pressed.UP) up.dispatch();
		if (FlxG.keys.justReleased.UP) up_release.dispatch();
			
		#end
		
		
		#if mobile
		
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed) 
			{ 
				//FlxG.log.add("justPressed ============= ");
			}
			if (touch.pressed) 
			{
				if (touch.overlaps(_left)) left.dispatch();
				else if (touch.overlaps(_right)) right.dispatch();
				else if (touch.overlaps(_shot)) A.dispatch();
				else if (touch.overlaps(_up)) up.dispatch();
			}
			if (touch.justReleased) 
			{
				if (touch.overlaps(_left)) left_release.dispatch();
				else if (touch.overlaps(_right)) right_release.dispatch();
				else if (touch.overlaps(_shot)) A_release.dispatch();
				else if (touch.overlaps(_up)) up_release.dispatch();
			}
		}
		#end
		
		super.update(elapsed);
	}
	
}