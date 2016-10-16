package model;

import flixel.FlxObject;
import flixel.FlxG;

import flash.net.FileReference;
import flash.net.FileFilter;
import flash.events.Event;
import flash.utils.ByteArray;

/**
 * ...
 * @author hhg4092
 */

#if (flash )
class FileStream extends FlxObject
{	
	
	private var _openfile:FileReference = new FileReference();
	
	public function new() 
	{
		super();
	}
	
	public function load():Void
	{			
		_openfile.addEventListener(Event.SELECT, onFileSelected); 
		var textTypeFilter:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", 
                        "*.txt;*.rtf"); 
        _openfile.browse([textTypeFilter]);
	}
		
	public function onFileSelected(evt:Event):Void 
    {            
        _openfile.addEventListener(Event.COMPLETE, onComplete); 
        _openfile.load(); 
    } 
		
	public function onComplete(evt:Event):Void
    {
		var ba:ByteArray = _openfile.data; 
		var utf8Str:String = ba.readMultiByte(ba.length, 'utf8');
		FlxG.log.add("jjjjj = "+utf8Str); 
		//var result:Object  = JSON.decode(utf8Str);
		Main._model.file_load_ok.dispatch(1);
    }
	
	public function save(data:String,filename:String):Void
	{
		var file:FileReference = new FileReference();
		file.save(Main._model._po_info.join('\n'), "po.txt");
	}
	
}
#end
