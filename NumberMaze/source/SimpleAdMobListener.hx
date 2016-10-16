package ;

#if admobads

import extension.admob.AdMobListener;
import flixel.FlxState;
import flixel.FlxG;

class SimpleAdMobListener extends AdMobListener {

	private var _onReflashOK:String->Void = null;
	
	public function new(OnReady:String->Void) {
		super();
		
		_onReflashOK = OnReady;
	}
	
	private function resumeGame():Void {
		FlxG.log.add("Calling resumeGame");
		//if (game.subState == game.adFocusSubState) {
			FlxG.log.add("Closing ad focus substate");
		//	game.openSubState(game.sampleSubState); // Note this works fine for now but won't work if there were nested substates
		//}
	}
	
	override private function log(text:String):Void {
		FlxG.log.add(text);
		
	}
	
	override public function onBannerClosed(unitId:String):Void {
		FlxG.log.add("onBannerClosed " + unitId);
		resumeGame();
	}
	
	override public function onBannerFailedToLoad(unitId:String):Void {
		FlxG.log.add("onBannerFailedToLoad " + unitId);
		resumeGame();
	}
	
	override public function onBannerLeftApplication(unitId:String):Void {
		FlxG.log.add("onBannerLeftApplication " + unitId);
		resumeGame();
	}
	
	override public function onBannerOpened(unitId:String):Void {
		FlxG.log.add("onBannerOpened " + unitId);
	}
	
	override public function onBannerLoaded(unitId:String):Void {
		FlxG.log.add("onBannerLoaded " + unitId);
		if ( _onReflashOK != null) _onReflashOK(unitId);
	}
	
	override public function onInterstitialClosed(unitId:String):Void {
		FlxG.log.add("onInterstitialClosed " + unitId);
		resumeGame();
	}
	
	override public function onInterstitialFailedToLoad(unitId:String):Void {
		FlxG.log.add("onInterstitialFailedToLoad " + unitId);
		resumeGame();
	}
	
	override public function onInterstitialLeftApplication(unitId:String):Void {
		FlxG.log.add("onInterstitialLeftApplication " + unitId);
		resumeGame();
	}
	
	override public function onInterstitialOpened(unitId:String):Void {
		FlxG.log.add("onInterstitialOpened " + unitId);
	}
	
	override public function onInterstitialLoaded(unitId:String):Void {
		FlxG.log.add("onInterstitialLoaded " + unitId);
	}
}

#end