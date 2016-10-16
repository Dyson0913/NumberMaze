package visual_component;

/**
 * ...
 * @author hhg4092
 */
import flixel.FlxG;
import flixel.addons.display.FlxExtendedSprite;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import model.*;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import openfl.geom.Point;


class StatisticBoard extends FlxTypedGroup<FlxSprite>
{
	private var _flip_card:FlxExtendedSprite;
	private var _flip_idx:Int;
	private var _flip_color:Int;
	private var _flip_Number:Int;
	private var _greens_side:Int;
	
	public var group( default, null ):FlxGroup;
	public var _arr:Array<FlxExtendedSprite> = new Array<FlxExtendedSprite>();
	
	private var _amount:Int = 4;
	private var _RowCount:Int = 8;
	
	//四個版的顏色
	private var _op:Array<Int>;
	private var _numberlist:Array<Int>;
	
	private var _frame:FlxSprite;
	private var _frameSide:Int;
	
	public function new() 
	{
		super();
		
		_op = new Array<Int>();
		_numberlist = new Array<Int>();
		_flip_idx = 0;
		
		group = new FlxGroup();
		for (i in 0...(_amount))
		{
			var p:Point = RegularSetting.row_po(i, _RowCount);
			var shift:Int = 0;
			if ( i >= 2) shift = 512;
			
			var x:Float = 28 + (p.x * 128) +shift ;		
			var y:Float = -200;// 64 + (p.y * 128);
			
			var item:FlxExtendedSprite = new FlxExtendedSprite(x, y);
			gernerate_way(item,1,0);
			
			add(item);
			
			item.ID = i;
			#if flash
			//item.mousePressedCallback = clcik;
			#end
			group.add(item);
			_arr.push(item);
			//RegularSetting.set_debug(item);
		}
		
		//event
		Main._model.Menu.add(appear);
		Main._model.playing.add(appear);
		Main._model.Settle.add(disappear);
		Main._model.credit.add(disappear);
		
		_frameSide = 0;
		//_frame = new FlxSprite(28, 0);
		//_frame.loadGraphic(AssetPaths.frame256__png);
		//add(_frame);
		
		Main._model.StaticNotify.add(notify);
	}
	
	private function appear(s:Dynamic):Void
	{		
		
	}
	
	private function disappear(s:Dynamic):Void
	{		
		
	}
	
	public function clcik(sp:FlxExtendedSprite, x:Int, y:Int):Void
	{
		FlxG.log.add(sp.ID);
		poker_turn(sp);
	}
	
	private function notify(s:Dynamic):Void
	{
		var order:String = s[0];
		if ( order == "first_hand")
		{
			_flip_color = s[1];
			_flip_Number = s[2];
			
			//
			if (_flip_color == 3) 
			{
				_greens_side = 3;
				
				//更新BAR color
			}
			else 
			{
				_greens_side = 4;
			}
			
			//poker_turn(_arr[0]);
		}
		if ( order == "Flip_over")
		{
			
			var green:Int = s[1];
			var blue:Int = s[2];
			
			FlxG.log.add("green ----" + green);
			FlxG.log.add("blue ----" + blue);
			//FlxG.log.add("blue ----" + Math.floor( green / 10));
			
			// left
			_numberlist.slice(0, 0);
			_flip_idx = 0;
			if ( _greens_side == 3)
			{
				_numberlist.push( Math.floor( green / 10));
				_numberlist.push( green % 10);
				
				_numberlist.push( Math.floor( blue / 10));
				_numberlist.push( blue % 10);
				FlxG.log.add("_numberlist ----" + _numberlist);
				_flip_color = 3;
				_op.push(3);
				_op.push(4);
				_op.push(4);
			}
			else
			{
				_numberlist.push( Math.floor( blue / 10));
				_numberlist.push( blue % 10);
				
				_numberlist.push( Math.floor( green / 10));
				_numberlist.push( green % 10);
				FlxG.log.add("_numberlist ----" + _numberlist);
				_flip_color = 4;
				_op.push(4);
				_op.push(3);
				_op.push(3);
			}
			
			poker_turn(_arr[0]);
			
			
		}
		
	}
	
	private function poker_turn(card:FlxExtendedSprite):Void
	{
		_flip_card = card;
        FlxTween.tween(card.scale, { x: 0 }, 0.2 / 2, { onComplete: pickCard });
	}
	
	private function pickCard(Tween:FlxTween):Void
	{
		gernerate_way(_flip_card,0,_numberlist[0]);
		FlxTween.tween(_flip_card.scale, { x: 1 }, 0.2 / 2);
		
		_numberlist.shift();
		
		if (_op.length != 0)
		{
			_flip_idx += 1;
			_flip_color = _op[0];
			_op.shift();
			poker_turn(_arr[_flip_idx]);
		}
		else
		{
			//比數更新完畢
			if( _frameSide == 0) FlxTween.tween(this, {  }, 0.1,{ onComplete: turnover });
			else FlxTween.tween(this, {  }, 0.1,{ onComplete: turnover });
		}
		
	}
	
	private function turnover(Tween:FlxTween):Void
	{
		_frameSide = (_frameSide +1) % 2;
		Main._model.TurnOverNotify.dispatch(["TurnOver",_frameSide]);
	}
	
	private function gernerate_way(card:FlxExtendedSprite,type:Int,digit:Int):Void
	{
		if ( type == 0)
		{
		  var num:Int = digit;
		  var color:Int = _flip_color;
		  card.loadGraphic("assets/images/Number_Blocks_01_Set_" + color + "_128x128_" + num + ".png");
		}
		if ( type == 1)
		{
		  card.loadGraphic(AssetPaths.Mark__png);
		}
	}
	
	
	
	private function rand():Void
	{
		
	}
	
}