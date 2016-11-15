package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flash.geom.Point;
import flash.text.Font;
import flash.text.TextFormat;


import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.addons.transition.TransitionData;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import option.CharSelectState;
import option.CreditState;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import model.Model;
import model.RegularSetting;
import flixel.addons.transition.Transition;
import model.FileStream;

class GameMenu extends FlxTypedGroup<FlxSprite>
{
	
	public var _arr:Array<FlxButton> = new Array<FlxButton>();
	
	private var name:Array<String> = new Array<String>();
	private var func:Array<Void->Void> = new Array<Void->Void>();
	
	private var _text:FlxText;
	#if (flash )
	private var _file:FileStream;
	#end
	public function new() 
	{
		super();
	}
	
	public function set_text(buttonName:Array<String>,fun:Array<Void->Void>):Void
	{
		name = buttonName;
		func = fun;
	}
	
	public function init(x:Float = 0, y:Float =0 ):Void
	{
		for (i in 0...(name.length))
		{
			var p:Point = RegularSetting.col_position(i, 3);
			
			var x:Float = x + (p.x * 300);		
			var y:Float = y + (p.y * 300);
			
			var btn:FlxButton = create_flxbut( x,0, name[i], func[i]);
			btn.loadGraphic(AssetPaths.MenuButton__png, true, 260, 74);
			btn.animation.frameIndex = 0;
			Model.font_format(btn.label, 50);
			btn.scale.x = 3;
			btn.scale.y = 3;
			add(btn);
			FlxTween.tween(btn, { y:y }, 2, { type: FlxTween.ONESHOT, ease:FlxEase.bounceOut } );
		
		}
		

		//#if mobile
			//_text = new FlxText(20, 20,500, "1234567890AbCdEfGh 看看：中文显示是否正常！m(^_*)$", 8, true);
			//_text.setFormat("/system/fonts/DroidSansFallback.ttf", 50, 0xFF0000);
			//add(_text);
		//#end
		
		
		//event
		//Main._model.Menu.add(appear);
		//Main._model.SelectRole.add(disappear);
		//Main._model.playing.add(disappear);
		//Main._model.Settle.add(disappear);
		//Main._model.credit.add(disappear);
		
		#if (flash )
		//_file = new FileStream();
		#end
		
		
		//Main._model.adjust_item.dispatch(_credit);
	}
	
	override public function destroy():Void 
	{
		
	}
	
	private function create_flxbut(x:Float,y:Float ,Name:String,_callback:Void->Void):FlxButton
	{
		return new FlxButton(x, y, Name, _callback);
	}
	
	private function appear(s:Dynamic):Void
	{		
		
		
	}
	
	private function disappear(s:Dynamic):Void
	{		
		
	}
	
}