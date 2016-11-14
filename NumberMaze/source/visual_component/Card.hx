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


class Card extends FlxTypedGroup<FlxSprite>
{
	private var _flip_card:FlxExtendedSprite;
	private var _flip_idx:Int;
	private var _flip_color:Int;
	private var _flip_Number:Int;
	
	private var _AI_pick:Int;
	private var _unpick:Array<Int>;
	private var _AI_color:Int;
	
	private var _add_card:FlxExtendedSprite;
	
	public var group( default, null ):FlxGroup;
	public var _arr:Array<FlxExtendedSprite> = new Array<FlxExtendedSprite>();
	
	private var _amount:Int = 16;//80;
	private var _RowCount:Int = 8;
	private var _arrNumer:Array<Int>;
	private var _color:Array<Int>;
	private var _check_point:Array<Int>;
	private var _CanFlip:Bool;
	
	private var _first_hand:Bool = true;
	private var _first_chose:Bool = true;
	private var _self_color:Int;
	
	//0 = self ,1 = AI
	private var _side:Int = 0;
	
	private var _green_total:Int;
	private var _blue_total:Int;
	
	public var effect_group:Array<FlxSprite> = new Array<FlxSprite>();
	
	public function new() 
	{
		super();
		
		_green_total = 0;
		_blue_total = 0;
		_flip_color = -1;
		_self_color = -1;
		_AI_color = -1;
		
		_CanFlip = true;
		_arrNumer = new Array<Int>();
		_color = new Array<Int>();
		_check_point = new Array<Int>();
		_unpick = new Array<Int>();
		group = new FlxGroup();
		for (i in 0...(_amount))
		{
			var p:Point = RegularSetting.row_po(i, _RowCount);
			
			var x:Float = 28 + (p.x * 128);		
			var y:Float = 300 + (p.y * 128);
			
			var item:FlxExtendedSprite = new FlxExtendedSprite(x, y);
			var arr:Array<Int> = gernerate_way(item,1,-1);
			_color.push(arr[0]);
			_arrNumer.push(arr[1]);
			
			add(item);
			
			item.ID = i;
			_unpick.push(i);
			#if flash
			item.mousePressedCallback = clcik;
			#end
			group.add(item);
			_arr.push(item);
			//RegularSetting.set_debug(item);
			
		}
		
		//event
		//Main._model.Menu.add(appear);
		//Main._model.playing.add(appear);
		//Main._model.Settle.add(disappear);
		//Main._model.credit.add(disappear);
		//
		disappear(1);
		Main._model.TurnOverNotify.add(turnOver);
		//Main._model.adjust_item.dispatch(_poker_mi_Target);
		
	}
	
	public function judge():String
	{
		if ( _self_color == 3 )
		{
			if ( _green_total > _blue_total) return "win";
			else if ( _green_total == _blue_total ) return "tie";
			else return "lost";
		}
		else
		{
			if ( _green_total > _blue_total) return "lost";
			else if ( _green_total == _blue_total ) return "tie";
			else return "win";
		}
		
	}
	
	private function turnOver(s:Dynamic):Void
	{
		var order:String = s[0];
		if ( order == "TurnOver")
		{
			_side = s[1];
			if ( _side == 1) 
			{
				if ( isover() ) 
				{
					FlxG.log.add("----------------  over t");
					return;
				}
				_AI_pick = Math.floor(Math.random() * _unpick.length);
				_AI_pick = _unpick[_AI_pick];
				while (_color[_AI_pick] != -1)
				{
					
					_AI_pick = Math.floor(Math.random() * _unpick.length);
					_AI_pick = _unpick[_AI_pick];
					
				}
				//玩家完換AI,_CanFlip 一直= FALSE
				FlxTween.tween(this, {  }, Math.ceil(Math.random()*3), { onComplete: AIpick });
				
			}
			else
			{
				//FlxG.log.add("---------------- left");
				_CanFlip = true;
				if ( isover() ) return;
			}
		}
		
	}
	
	override public function destroy():Void 
	{
		Main._model.TurnOverNotify.remove(turnOver);
	}
	
	public function isover():Bool
	{
		FlxG.log.add("---------------- unpick.lent"+_unpick.length);
		if ( _unpick.length == 0)
		{
			FlxG.log.add("---------------- is over");
			Main._model.GameOverNotify.dispatch(1);
			
			return true;
		}
		return false;
	}
	
	private function AIpick(Tween:FlxTween):Void
	{
		poker_turn(_arr[_AI_pick] );
	}
	
	private function appear(s:Dynamic):Void
	{		
		
	}
	
	private function disappear(s:Dynamic):Void
	{		
		
	}
	
	#if mobile
	override public function update(elapsed:Float):Void
	{
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed) 
			{ 
				FlxG.log.add("justPressed ============= ");
			}
			if (touch.pressed) 
			{
				
			}
			if (touch.justReleased) 
			{
				if ( !_CanFlip ) break;
				
				for (i in 0...(_amount))
				{
					if (touch.overlaps(_arr[i]))
					{
						poker_turn(_arr[i]);
					}
				}
			}
		}
		
		super.update(elapsed);
		
	}
	#end
	
	public function clcik(sp:FlxExtendedSprite, x:Int, y:Int):Void
	{
		FlxG.log.add(sp.ID);
		if ( !_CanFlip ) return;
		
		poker_turn(sp);
	}
	
	private function poker_turn(card:FlxExtendedSprite):Void
	{
		if (_color[card.ID] != -1) return;
		
		//unpick 減少
		var idx:Int = _unpick.indexOf(card.ID);
		_unpick.remove(card.ID);
		
		_CanFlip = false;
		_flip_card = card;
        FlxTween.tween(card.scale, { x: 0 }, 0.2 / 2, { onComplete: pickCard });
	}
	
	private function pickCard(Tween:FlxTween):Void
	{
		
		var flip_color:Int;
		if (_side == 0 && (_first_hand == true)) 
		{
			_self_color = Math.floor(Math.random() * 2 +3);
			flip_color = _self_color;
			_AI_color = _self_color == 3 ? 4:3;
		}
		else
		{
			if (_side == 0)
			{
				flip_color = _self_color;
			}
			else 
			{
				flip_color = _AI_color;
				
			}
		}
		var color_num:Array<Int> = gernerate_way(_flip_card,0,flip_color);
		FlxTween.tween(_flip_card.scale, { x: 1 }, 0.2 / 2);
		
		//FlxG.sound.play(AssetPaths.click__mp3);
		FlxG.sound.play("KK");
		
		//recode id & color
		_flip_idx = _flip_card.ID;
		_flip_color = _color[_flip_idx] = color_num[0];
		_flip_Number = _arrNumer[_flip_idx] = color_num[1];
		
		//first hand
		if ( _first_hand) 
		{
			Main._model.StaticNotify.dispatch(["first_hand", _flip_color,_flip_Number]);
			_first_hand = false;
			Main._model.probNotify.dispatch(["self_color", _flip_color]);
		}
		
		//翻完CHECK
		_check_point = rule_check(_flip_idx);
		
		//FlxG.log.add(_check_point);
		
		
		var updatelist:Array<Int> = new Array<Int>();
		for (i in 0...(_check_point.length))
		{
			var check_color:Int = _color[_check_point[i]];
			
			if (check_color != -1) updatelist.push(_check_point[i]);
		}
		
		//需要翻的idx
		_check_point = updatelist;
		if ( _check_point.length != 0)
		{
			_add_card = _arr[_check_point[0]];
			FlxTween.tween(_add_card.scale, { x: 0 }, 0.2 / 2, { onComplete: add_turn, startDelay: 0.5 } );
		}
		else
		{
			sum();
			Main._model.probNotify.dispatch(["update_vale", _green_total,_blue_total]);
			Main._model.StaticNotify.dispatch(["Flip_over", _green_total, _blue_total]);
		}
	}
	
	private function add_turn(Tween:FlxTween):Void
	{
		calculat_add(_add_card, 0);
		FlxTween.tween(_add_card.scale, { x: 1 }, 0.2 / 2);
		
		_check_point.shift();
		
		
		FlxG.sound.play("KK");
		
		if ( _check_point.length != 0)
		{
			_add_card = _arr[_check_point[0]];
			FlxTween.tween(_add_card.scale, { x: 0 }, 0.2 / 2, { onComplete: add_turn, startDelay: 0.1 } );
			FlxG.log.add("end = "+_unpick);
		}
		else
		{
			sum();
			Main._model.probNotify.dispatch(["update_vale", _green_total,_blue_total]);
			Main._model.StaticNotify.dispatch(["Flip_over", _green_total, _blue_total]);
			
		}
	}
	
	private function calculat_add(card:FlxExtendedSprite,num):Void
	{
		var num:Int = _arrNumer[_check_point[0]];
		var color:Int = _color[_check_point[0]];
		
		var flip_num:Int = _arrNumer[_flip_idx];
		
		if ( _flip_color == color)
		{
			num = (num + 1) % 10;
			_arrNumer[_check_point[0]] = num;
		}
		else {
			//num = num - flip_num   <= 0 ? -1: num - flip_num;
			num = num - 1   <= 0 ? -1: num - 1;
			_arrNumer[_check_point[0]] = num;
			
			
		}
		
		if ( num == -1 ) 
		{
			//還原成mark
			_color[_check_point[0]] =-1;
			card.loadGraphic(AssetPaths.rock__png);
			
			//unpick 加回去
			_unpick.push(_check_point[0]);
			FlxG.log.add(" add push = "+_check_point[0]);
		}
		else 
		{
			card.loadGraphic("assets/images/Number_Blocks_01_Set_" + color + "_128x128_" + num + ".png");
			
			var idx:Int = _unpick.indexOf(_check_point[0]);
			_unpick.remove(_check_point[0]);
			
		}
	}
	
	private function gernerate_way(card:FlxExtendedSprite,type:Int,open_color:Int):Array<Int>
	{
		var arr:Array<Int> = new Array<Int>();
		if ( type == 0)
		{
		  var num:Int = Math.floor(Math.random() *8)+1;
		  var color:Int = open_color;
		  card.loadGraphic("assets/images/Number_Blocks_01_Set_" + color + "_128x128_" + num + ".png");
		  arr.push(color);
		  arr.push(num);
		  return [color, num];// arr;
		}
		if ( type == 1)
		{
		  card.loadGraphic(AssetPaths.rock__png);
		  arr.push(-1);
		  arr.push(-1);
		  return [ -1, -1];// arr;
		}
		
		return arr;
	}
	
	private function sum():Void
	{
		var n:Int = _arrNumer.length;
		_green_total = 0;
		_blue_total = 0;
		for (i in 0...(n))
		{
			if ( _color[i] == 3) _green_total += _arrNumer[i];
			else if ( _color[i] == 4) _blue_total += _arrNumer[i];
		}
		
	}
	
	private function rule_check(idx:Int):Array<Int>
	{
		var arr:Array<Int> = new Array<Int>();
		
		//left
		if (idx  % _RowCount == 0)
		{
			//lefe corner
			if (idx == 0) 
			{
				arr.push(value_by_id(idx, 4));
				arr.push(value_by_id(idx, 6));
				return arr;
			}
			
			//left botton
			if ( idx == (_amount - _RowCount))
			{
				arr.push(value_by_id(idx, 2));
				arr.push(value_by_id(idx, 4));
				return arr;
			}
			
			arr.push(value_by_id(idx, 2));
			arr.push(value_by_id(idx, 4));
			arr.push(value_by_id(idx, 6));
			
			return arr;
		}
		
		//right
		if ( idx % _RowCount == (_RowCount - 1))
		{
			//right corner
			if ( idx == _RowCount - 1)
			{
				arr.push(value_by_id(idx, 8));
				arr.push(value_by_id(idx, 6));
				return arr;
			}
			
			//right button
			if (idx == _amount - 1)
			{
				arr.push(value_by_id(idx, 2));
				arr.push(value_by_id(idx, 8));
				return arr;
			}
			
			arr.push(value_by_id(idx, 2));
			arr.push(value_by_id(idx, 8));
			arr.push(value_by_id(idx, 6));
			
			return arr;
		}
		
		//top
		if (idx < _RowCount)
		{
			arr.push(value_by_id(idx, 4));
			arr.push(value_by_id(idx, 6));
			arr.push(value_by_id(idx, 8));
			return arr;
		}
		
		//button
		if (idx > (_amount -_RowCount))
		{
			arr.push(value_by_id(idx, 2));
			arr.push(value_by_id(idx, 4));
			arr.push(value_by_id(idx, 8));
			return arr;
		}
		
		
		//9 around
		arr.push(value_by_id(idx, 2));
		arr.push(value_by_id(idx, 4));
		arr.push(value_by_id(idx, 6));
		arr.push(value_by_id(idx, 8));
		
		return arr;
	}
	
	
	//  (n-m)-1  (n-m)  (n-m)+1      1   2   3
	//  (n-1)      n     (n+1)       8       4
	//  (n+m)-1  (n+m)  (n+m)+1      7   6   5
	private function value_by_id(value:Int, po:Int):Int
	{
		if (po == 1) return (value -_RowCount -1);
		if (po == 2) return (value -_RowCount);
		if (po == 3) return (value -_RowCount + 1);
		if (po == 4) return (value + 1);
		if (po == 5) return (value +_RowCount + 1);
		if (po == 6) return (value +_RowCount);
		if (po == 7) return (value +_RowCount - 1);
		if (po == 8) return (value - 1);
		
		return -1;
	}
	
}