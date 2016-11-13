package ;


import flixel.addons.display.FlxExtendedSprite;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

import haxe.Json;

import visual_component.*;

import flixel.util.helpers.FlxBounds.FlxBounds;
import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.FlxObject;
import flixel.util.FlxColor;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.addons.transition.TransitionData;

import model.RegularSetting;
import model.Model;
import openfl.Assets;
import model.FileStream;
import SimpleAdMobListener;

#if admobads
import extension.admob.AdMob;
import extension.admob.AdMobListener;
import extension.admob.AdMobGravity;
#end

import flixel.addons.transition.FlxTransitionableState;

class QuickState extends FlxTransitionableState
{
	private var _card:Card;
	private var _timer:Timer;
	private var _hint:HintMessage;
	private var _bar:Prob_panel;
	private var _static:StatisticBoard;
	
	private var _adjust:Adjust_tool;
	
	private var _gameinput:GameInput;
	
	private var _singleplayer:FlxButton;
	
	private var _gameMenu:GameMenu;
	
	#if (flash )
	//private var _file:FileStream;
	#end
	
	public var _bannerId:String = "ca-app-pub-2343865627432036/8188357502";
	
	override public function create():Void
	{
		super.create();
		
		
		_adjust = new Adjust_tool();
		
		//控制要先create,不然會有奇怪的bug(放到最後建,isTouching(FlxObject.FLOOR) 會為false)
		_gameinput = new GameInput();
		add(_gameinput);
		
		_gameinput.mouse_pressed.add(mouse_preseed_event);
		_gameinput.A.add(mouse_preseed_event);
		_gameinput.A_release.add(player_shut);
		
		
		_gameinput.left_release.add(player_reset);
		_gameinput.right_release.add(player_reset);
		_gameinput.up_release.add(player_reset);
		
		_bar = new Prob_panel();
		add(_bar);
		
		
		_timer = new Timer();
		
		_card = new Card();
		add(_card);
		
		_hint = new HintMessage();
		add(_hint);
		
		Main._model.time_tick.add(timetick);
		
		//add(_adjust);
		//Main._model.adjust_item.dispatch(_shot_icon_MAX);
		
		_static = new StatisticBoard();
		add(_static);
		
		
		Main._model.playing.add(appear);
		
		Main._model.recode_po.add(recode_info);
		
		//_singleplayer = new FlxButton( 10  , 20, "recode", singlplayer);
		//_singleplayer.loadGraphic(AssetPaths.MenuButton__png);
		//Model.font_format(_singleplayer.label, 35);
		//_singleplayer.scale.set(1.5, 1.5);
		
		
		
		#if (flash )
		//add(_singleplayer);
		//_file = new FileStream();
		#end
		
		#if admobads
		samcode();
		#end
		
		Main._model.GameOverNotify.add(Gameover);
		
		
	}
	
	override public function destroy():Void 
	{
		Main._model.GameOverNotify.remove(Gameover);
		_static.destroy();
		_bar.destroy();
		_card.destroy();
	}
	
	private function Gameover(s:Dynamic):Void
	{
		_gameMenu = new GameMenu();
		_gameMenu.set_text(["playAgain", "Menu"], [this.playerAgain, this.backMenu]);
		_gameMenu.init();
		add(_gameMenu);
		
	}
	
	private function playerAgain():Void
	{
		FlxG.resetState();
	}
	
	private function backMenu():Void
	{
		var fanin:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		var fanout:TransitionData = new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.5,new FlxPoint(1,0));
		
		FlxG.switchState(new MenuState(fanin,fanout));
	}
	
	private function samcode():Void
	{
		#if admobads
		AdMob.init(); 
		AdMob.setListener(new SimpleAdMobListener(bar_ok));

		//var interstitialId:String = "ca-app-pub-2343865627432036/8188357502";
		//AdMob.cacheInterstitial(interstitialId); // Cache interstitial with the id from your AdMob dashboard.
		
		AdMob.setBannerPosition(AdMobHorizontalGravity.CENTER, AdMobVerticalGravity.BOTTOM); // All banners will appear bottom center of the screen 
		//AdMob.refreshBanner(_bannerId);
		
		#end
	}
	
	
	private function bar_ok(st:String):Void
	{
		FlxG.log.add("bar_ok");
		#if admobads
		AdMob.showBanner(_bannerId);
		#end
	}
	
	private function singlplayer():Void
	{
		var i:Int = Main._model._po_list.length;
		
		for (k in 0...i)
		{
			FlxG.log.add("list = " + Main._model._po_list[k]);
			var list:FlxExtendedSprite =  Main._model._po_list[k];
			var po_info = { "id": list.ID,
			        "x":list.x,
					"y":list.y
			};
			var ob:Dynamic = Json.parse(Json.stringify(po_info));
			Main._model._po_info.push(Std.string(ob));
			//Main._model._po_info.push("\n");
		}
		
		#if (flash )
		//_file.save(Main._model._po_info.join('\n'), "po.txt");
		#end
		
	}
	
	public function appear(s:Dynamic):Void
	{
		//add(_timer);
	}
	
	public function recode_info(s:Dynamic):Void
	{
		var recode_item:FlxExtendedSprite = cast(s, FlxExtendedSprite);
		
		if ( Main._model._po_list.indexOf(recode_item) == -1)
		{
			Main._model._po_list.push(recode_item);
		}
		else
		{
			var i:Int = Main._model._po_list.indexOf(recode_item);
			Main._model._po_list[i] = recode_item;
		}
	}
	
	
	public function click(sp:FlxExtendedSprite,x:Int,y:Int):Void
	{
		FlxG.log.add("x = ");
		player_shut(1);
	}
	
	private function timetick(s:Dynamic):Void
	{
		
	}
	
	private function put_ready(Tween:FlxTween):Void
	{		
		Main._model.hintmsgNotify.dispatch(1);
	}
	
	override public function update(elapsed:Float):Void
	{
		//TODO 主要遊戲訊息溝通
		
		//FlxG.collide(_net.hoopleftPoint, _ball_);
		//FlxG.collide(_net.hooprightPoint, _ball_);
	
		
		//FlxG.collide(_net.hoopleftPoint2, _ball_);
		//FlxG.collide(_net.hooprightPoint2, _ball_);
		
		//FlxG.overlap(_net.checkPoint, _ball_, check_point);
		//FlxG.overlap(_net.checkPoint2, _ball_, check_point);
		
		//FlxG.overlap(_testBall.group, _player,ball_collect);
		
		super.update(elapsed);
	}
	
	private function mouse_preseed_event(s:Dynamic):Void
	{
		
	}
	
	private function player_shut(s:Dynamic):Void
	{
		
	}
	
	private function player_reset(s:Dynamic):Void
	{	
		
	}
	
	private function shot():Void
	{
		
	}
	
}