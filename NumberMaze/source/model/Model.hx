package model;

import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import parser.*;
import flixel.FlxG;

import flixel.addons.display.FlxExtendedSprite;
import haxe.Json;


/**
 * ...
 * @author hhg4092
 */

@:allow(Slot)
class Model extends FlxObject
{
    //interface
	public var _parser:IParser;	
	
	//model
	public var _credit:String;
	public var _player_uuid:String;
	public var _gamelist:Array<String> = new Array();
	
	public var _game_id:String;
	public var _game_type:String;
	public var _game_round:String;
	public var _game_state:String;
	public var _remain_time:Int;
	public var _recode_hisotry:Dynamic;
	public var _coin_select_idx:Int;
	public var _zone_un_comfirm_bet:Array<Float> = new Array<Float>();
	public var _zone_comfirm_bet:Array<Float> = new Array<Float>();
	public var _zone_settle_bet:Array<Float> = new Array<Float>();
	public var _win_type:Int;
	
	
	public var _bigwin_prob:Array<Float> = new Array<Float>();
	public var _bigwin_opencard_type:String;
	public var _bigwin_banker_card:Array<String> = new Array<String>();
	public var _bigwin_player_card:Array<String> = new Array<String>();
	public var _bigwin_river_card:Array<String> = new Array<String>();
	
	public var _coin_list:Array<Int> = new Array<Int>();
	public var _res_list:Array<String> = new Array<String>();
	public var _betzone_name:Array<String> = new Array<String>();
	
	public var _char_id:Int;
	
	//base event
	public var send_pack = new Signal<Dynamic>();
	
	//sys event
	public var socket_error = new Signal<Dynamic>();
	public var creditUpdate = new Signal<Dynamic>();
	public var join_game_success = new Signal<Dynamic>();
	public var time_tick = new Signal<Dynamic>();
	public var recode_po = new Signal<Dynamic>();
	
	public var _po_list:Array<FlxExtendedSprite> = new Array<FlxExtendedSprite>();
	public var _po_info:Array<String> = new Array<String>();
	public var file_load_ok = new Signal<Dynamic>();
	
	public var Menu = new Signal<Dynamic>();
	public var SelectRole = new Signal<Dynamic>();
	public var playing = new Signal<Dynamic>();
	public var Settle = new Signal<Dynamic>();
	public var credit = new Signal<Dynamic>();
	
	// event
	public var hintmsgNotify = new Signal<Dynamic>();
	public var scoreNotify = new Signal<Dynamic>();
	public var probNotify = new Signal<Dynamic>();
	public var StaticNotify = new Signal<Dynamic>();
	public var TurnOverNotify = new Signal<Dynamic>();
	public var GameOverNotify = new Signal<Dynamic>();
	//for test
	public var _packlist:Array<String> = new Array();
	public var _packlist_idx:Int = 0;
	
	public var adjust_item = new Signal<Dynamic>();
	
	
	
	public function new() 
	{
		super();
		
		//customer
		//_parser = new Dk_Parser();
		
		reset_model();		
		
		_coin_list.push(5);
		_coin_list.push(500);
		_coin_list.push(1000);
		_coin_list.push(5000);
		_coin_list.push(10000);
		
		
		_res_list.push("assets/images/share/coin/tt-1.png");
		_res_list.push("assets/images/share/coin/ft-1.png");
		_res_list.push("assets/images/share/coin/ot-1.png");
		_res_list.push("assets/images/share/coin/fh-1.png");
		_res_list.push("assets/images/share/coin/five-1.png");		
		
		
		_betzone_name.push("BetBWPlayer");
		_betzone_name.push("BetBWBanker");
		_betzone_name.push("BetBWTiePoint");
		_betzone_name.push("BetBWBankerPair");
		_betzone_name.push("BetBWPlayerPair");
		_betzone_name.push("BetBWSpecial");
		
		_bigwin_prob.push(0);
		_bigwin_prob.push(0);
		_bigwin_prob.push(0);
		_bigwin_prob.push(0);
		_bigwin_prob.push(0);
		_bigwin_prob.push(0);		
		
		_char_id = 1;
	}
	
	public function reset_model():Void
	{
		_zone_un_comfirm_bet.splice(0, _zone_un_comfirm_bet.length);			
		_zone_comfirm_bet.splice(0, _zone_comfirm_bet.length);
		
		_zone_un_comfirm_bet.push(0);
		_zone_un_comfirm_bet.push(0);
		_zone_un_comfirm_bet.push(0);
		_zone_un_comfirm_bet.push(0);
		_zone_un_comfirm_bet.push(0);
		_zone_un_comfirm_bet.push(0);
		
		_zone_comfirm_bet.push(0);
		_zone_comfirm_bet.push(0);
		_zone_comfirm_bet.push(0);
		_zone_comfirm_bet.push(0);
		_zone_comfirm_bet.push(0);
		_zone_comfirm_bet.push(0);
	}
	
	public function pack_parse(pack:Dynamic):Void
	{
		//check which game ,lobby or game
		//FlxG.log.add("lobby pack parse "+pack);
		
		if ( pack.message_type == "echo_join")
		{
			Main._model.creditUpdate.dispatch("100");
			return;
		}
		
		if ( pack.message_type == "MsgLogin")
		{			
			_credit = pack.player_info.player_credit;
			_player_uuid = pack.player_info.player_uuid;
			//dynamic field
			for (n in Reflect.fields(pack.game_list))
			{
				var item:Dynamic = Reflect.field(pack.game_list, n);
				//FlxG.log.add("gamelist " + Reflect.field(pack.game_list, n));
				//FlxG.log.add("gamelist " + item.game_id);
				_gamelist.push(item.game_id);
			}				
			
			Main._model.creditUpdate.dispatch(_credit);
			return;
		}
		
		if ( pack.message_type == "MsgKeepLive")
		{
			//FlxG.log.add("lobby pack MsgKeepLive not handle");
			return;
		}
		
		_parser.parser(pack);
	}
	
	public function bet_in(zone:Int):Void
	{
		var total:Float = _zone_un_comfirm_bet[zone];
		total += Std.parseFloat(bet_amount());
		
		_zone_un_comfirm_bet[zone] = total;
		
		//FlxG.log.add(_zone_un_comfirm_bet);
	}
	
	public function bet_total(zone:Int):String
	{
		return Std.string(_zone_un_comfirm_bet[zone] + _zone_comfirm_bet[zone]);
	}	
	
	public function send_un_comfirm_bet():Void
	{		
		var len:Int = _zone_un_comfirm_bet.length;
		var non_zero_idx:Int = -1;
		for (i in 0...(len))
		{
			//find non zero idx	
			if ( _zone_un_comfirm_bet[i] != 0)
			{
				non_zero_idx = i;
				break;
			}			
		}
		
		if (non_zero_idx == -1) return;
		
		var bet_type:String = _betzone_name[non_zero_idx];
		var bet_amount:Float = _zone_un_comfirm_bet[non_zero_idx];
		var total_bet_amount:Float = _zone_un_comfirm_bet[non_zero_idx] + _zone_comfirm_bet[non_zero_idx];		
		
		
		var bet = { "id": Model.uuid(),
			        "timestamp":1111,
					"message_type":"MsgPlayerBet", 
			        "game_id":Main._model._game_id,
					"game_type":Main._model._game_type,
					"game_round":Main._model._game_round,
					"bet_type": bet_type,
					"bet_amount":bet_amount,
					"total_bet_amount":total_bet_amount
		};
		
		FlxG.log.add("====my bet ob ="+bet);
		//Main._model.send_pack.dispatch(bet);
		
	}
	
	public function un_comfirm_bet_to_comfirm():Void
	{
		//move un comfirme to comfirm
		var len:Int = _zone_un_comfirm_bet.length;
		for (i in 0...(len))
		{
			_zone_comfirm_bet[i] += _zone_un_comfirm_bet[i];
			_zone_un_comfirm_bet[i] = 0;
		}
		
	}
	
	public function un_comfirm_bet_drop():Void
	{
		//move un comfirme to comfirm
		var len:Int = _zone_un_comfirm_bet.length;
		for (i in 0...(len))
		{			
			_zone_un_comfirm_bet[i] = 0;
		}
		
	}
	
	
	public function bet_amount():String
	{		
		return Std.string(_coin_list[Main._model._coin_select_idx]);
	}
	
	public static function Format(digit:Int,lenth:Int):String
	{
		var str:String = "";
		var digLenth:Int = Std.string(digit).length;
		
		var len:Int = lenth - digLenth;
		for (i in 0...(len))
		{
			str += "0";
		}
		return str + Std.string(digit);
	}

	public static function uuid():String
	{
        // Based on https://gist.github.com/LeverOne/1308368
        var uid = new StringBuf(), a = 8;
        uid.add(StringTools.hex(Std.int(Date.now().getTime()), 8));
        while((a++) < 36) {
            uid.add(a*51 & 52 != 0
                ? StringTools.hex(a^15 != 0 ? 8^Std.int(Math.random() * (a^20 != 0 ? 16 : 4)) : 4)
                : "-"
            );
        }
        return uid.toString().toLowerCase();
    }
	
	public static function font_format(target:FlxText,size:Int,color:FlxColor = FlxColor.WHITE, alig:String = "center"):Void
	{
		
		target.setFormat(AssetPaths.arial__ttf, size, color, alig);
		
		//_text = new FlxText(20, 20,500, "1234567890AbCdEfGh 看看：中文显示是否正常！m(^_*)$", 8, true);
		//_text.setFormat("/system/fonts/DroidSansFallback.ttf", 50, 0xFF0000);
	}
	
	public static function font_Chinese_format(target:FlxText, size:Int, color:FlxColor = FlxColor.WHITE, alig:String = "center"):Void
	{
		#if mobile
		target.setFormat("/system/fonts/DroidSansFallback.ttf", size, color, alig);
		#end
	}
	
	
	
}

class Signal<T> {
    private var callbacks = new Array<T -> Void>();

    public function new() {
    }

    public function dispatch(?value:T) {
        for (cb in callbacks) {
            cb(value);
        }
    }

    public function add(callback:T -> Void):T -> Void {
        callbacks.push(callback);
        return callback;
    }

    public function remove(callback:T -> Void):Void {
        callbacks.remove(callback);
    }
}