package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.text.FlxText;
import model.Model;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


class HintMessage extends FlxTypedGroup<FlxSprite>
{
	public var group( default, null ):FlxGroup;
	
	public function new() 
	{
		super();
		
		group = new FlxGroup();
		for (i in 0...(5))
		{//560
			var item:FlxSprite = new FlxSprite(i * 151 +580, 1110);
			item.loadGraphic(AssetPaths.alpha__png,true, 137, 151);
			if( i ==0) item.animation.frameIndex = 18;
			if( i ==1) item.animation.frameIndex = 19;
			if( i ==2) item.animation.frameIndex = 0;
			if( i ==3) item.animation.frameIndex = 6;
			if( i ==4) item.animation.frameIndex = 4;
			item.ID = i;
			item.kill();
			add(item);
			group.add(item);
		}
		//add(_ready);
		
		//event
		Main._model.Menu.add(appear);
		Main._model.playing.add(appear);
		Main._model.Settle.add(disappear);
		Main._model.credit.add(disappear);
		
		disappear(1);
		
		Main._model.hintmsgNotify.add(show);
	}
	
	private function appear(s:Dynamic):Void
	{
		
	}
	
	private function disappear(s:Dynamic):Void
	{		
		
	}
	
	private function show(s:Dynamic):Void
	{
		group.forEach(effect);
	}
	
	private function effect(item:FlxBasic):Void
	{		
		var myitem:FlxSprite = cast(item, FlxSprite);
		myitem.revive();
		if ( myitem.ID == 4) FlxTween.tween(myitem, { y: myitem.y -530 }, 1, { ease: FlxEase.bounceOut,startDelay:0.1*myitem.ID,onComplete: ready_go } );
		else FlxTween.tween(myitem, { y: myitem.y -530 }, 1, { ease: FlxEase.bounceOut,startDelay:0.1*myitem.ID } );
	}
	
	private function ready_go(Tween:FlxTween):Void
	{
		FlxTween.tween(this, { }, 1, { onComplete: put_go } );
	}
	
	private function put_go(Tween:FlxTween):Void
	{
		group.forEach(effect_go);
	}
	
	private function effect_go(item:FlxBasic):Void
	{
		var myitem:FlxSprite = cast(item, FlxSprite);
		if (myitem.ID == 1) 
		{
			myitem.animation.frameIndex = 6;
			FlxTween.tween(myitem.scale, { x: 3.0 ,y:3.0 }, 1, { ease: FlxEase.cubeOut } );
			FlxTween.tween(myitem,{ alpha: 0 }, 1, { ease: FlxEase.cubeOut } );
		}
		else if (myitem.ID == 3) 
		{
			myitem.animation.frameIndex = 14;
			FlxTween.tween(myitem.scale, { x: 3.0 , y:3.0}, 1, { ease: FlxEase.cubeOut } );
			FlxTween.tween(myitem, { alpha: 0 }, 1, { ease: FlxEase.cubeOut } );
			
			Main._model.playing.dispatch(1);			
		}
		else FlxTween.tween(myitem, { alpha: 0 }, 0.1);
	}
	
	
	
}