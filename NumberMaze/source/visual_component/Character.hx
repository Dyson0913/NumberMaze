package visual_component;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;

import flixel.FlxG;

/**
 * ...
 * @author Dyson0913
 */
class Character extends FlxSprite
{
	public var state( default, default ):SpriteState;
	
	private var _move_speed:Float;
	private var _jump_speed:Float;
	
	public function new(X:Float=0, Y:Float=0,Graphic:FlxGraphicAsset,Width:Int = 0, Height:Int = 0) 
	{
		super(X, Y);
		//makeGraphic(16, 16, FlxColor.BLUE);
		var graph:FlxGraphic = FlxG.bitmap.add(Graphic);
		loadGraphic(Graphic, true, Width, Height);
		
		//tween to idx animation.frameIndex = 1;
		animation.frameIndex = 0;
		animation.add("idle", [11]);
		animation.add("jump", [2]);
		animation.add("walk", [9, 10, 11]);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		//antialiasing = true;
		acceleration.y = 980;
		state = SpriteState.idel;
		_move_speed = 500;
		_jump_speed = 500;
		
		//FlxG.watch.add(this, "state");
		//FlxG.watch.add(this, "velocity");
		
	}
	
	override public function update(elapsed:Float):Void
	{
		velocity.x = 0;
		
		//位移
		if (state == SpriteState.right) turn_right();
		if (state == SpriteState.left) turn_left();
		
		
		//影格切換
		//FlxG.log.add("char ============= "+isTouching(FlxObject.FLOOR) + " v = "+ velocity.y);
		if (isTouching(FlxObject.FLOOR)) 
		{
			if (state == SpriteState.right) animation.play("walk");
			else if (state == SpriteState.left) animation.play("walk");
			else if (state == SpriteState.idel) animation.play("idle");
			
			if (state == SpriteState.jump && velocity.y ==0) animation.play("idle");
		}
		
	
		
		super.update(elapsed);
	}
	
	public function turn_left():Void
	{
		facing = FlxObject.LEFT;
		velocity.x -= _move_speed;
	}
	
	public function turn_right():Void
	{
		facing = FlxObject.RIGHT;
		velocity.x += _move_speed;
	}
	
	public function jump():Void
	{
		//FlxG.log.add("jump ============= "+isTouching(FlxObject.FLOOR) + " v = "+ velocity.y);
		if (isTouching(FlxObject.FLOOR)) 
		{
			velocity.y = -_jump_speed;
			animation.play("jump");
			state = SpriteState.jump;
		}
	}
	
	override public function destroy():Void 
	{
		// Make sure that this object is removed from the MouseEventManager for GC
		super.destroy();
	}
}

enum SpriteState
{
	idel;
	left;
	right;
	jump;
}