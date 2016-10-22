package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flash.geom.Point;
import flash.text.Font;
import flash.text.TextFormat;
import flixel.addons.transition.TransitionData;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import option.CharSelectState;
import option.CreditState;

import model.Model;
import model.RegularSetting;
import flixel.addons.transition.Transition;
import model.FileStream;

class GameMenu extends FlxTypedGroup<FlxSprite>
{
	private var _bg:FlxSprite;
	
	public var _arr:Array<FlxButton> = new Array<FlxButton>();
	
	private var _text:FlxText;
	#if (flash )
	private var _file:FileStream;
	#end
	public function new() 
	{
		super();
		
		_bg = new FlxSprite(0,0).makeGraphic(10,10);
		add(_bg);
		
		
		var name:Array<String> = new Array<String>();
		var func:Array<Void->Void> = new Array<Void->Void>();
		name = ["singlePlay", "Multiplay", "Credit"];
		func = [singlplayer, multiplayer,credit];
		for (i in 0...(3))
		{
			var p:Point = RegularSetting.col_position(i, 3);
			
			var x:Float = 300 + (p.x * 300);		
			var y:Float = 300 + (p.y * 80);
			
			var btn:FlxButton = create_flxbut(x, y, name[i], func[i]);
			btn.loadGraphic(AssetPaths.MenuButton__png,true,260,74);
			btn.animation.frameIndex = 0;
			Model.font_format(btn.label, 35);
			add(btn);
		}
		

		//#if mobile
			//_text = new FlxText(20, 20,500, "1234567890AbCdEfGh 看看：中文显示是否正常！m(^_*)$", 8, true);
			//_text.setFormat("/system/fonts/DroidSansFallback.ttf", 50, 0xFF0000);
			//add(_text);
		//#end
		
		
		//event
		Main._model.Menu.add(appear);
		Main._model.SelectRole.add(disappear);
		Main._model.playing.add(disappear);
		Main._model.Settle.add(disappear);
		Main._model.credit.add(disappear);
		
		#if (flash )
		_file = new FileStream();
		#end
		
		//Main._model.adjust_item.dispatch(_credit);
	}
	
	private function create_flxbut(x:Float,y:Float ,Name:String,_callback:Void->Void):FlxButton
	{
		return new FlxButton(x, y, Name, _callback);
	}
	
	private function appear(s:Dynamic):Void
	{		
		_bg.revive();
		
	}
	
	private function disappear(s:Dynamic):Void
	{		
		_bg.kill();
	}
	
	private function singlplayer():Void
	{
		var fanin:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		var fanout:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		
		//FlxG.switchState(new CharSelectState(fanin, fanout));
		Main._model.file_load_ok.add(ok);
		
		//#if (flash )
		//_file.load();
		//#else
		FlxG.switchState(new QuickState());
		//#end
		
		
	}
	
	private function ok(s:Dynamic):Void
	{
		FlxG.switchState(new QuickState());
	}
	
	private function multiplayer():Void
	{
		
	}
	
	private function credit():Void
	{
		var fanin:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		var fanout:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		
		FlxG.switchState(new CreditState(fanin,fanout));
	}
	
}