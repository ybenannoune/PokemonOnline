package game.entities
{	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import game.state.LoadLevelState;
	import game.state.PlayState;	
	import game.utils.Constants;
	import game.utils.GameLibrary;
	import game.world.LevelLoader;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import socket.ServerConnection;
	/**
	 * ...
	 * @author ...
	 */
	public class EventManager
	{	
		private var gamelib:GameLibrary;	
		protected var player:Player;	
		protected var playstate:FlxState;	
				
		//Etat du player
		public var writing:Boolean;
		public var inEvent:Boolean;
		
		public function EventManager(gamelib_:*):void
		{
			gamelib = gamelib_;
		}	
		
		public function setEntites(playstate_:*, player_:*):void
		{
			player = player_;
			playstate = playstate_;
		}
		
		public function makeEvent(type:int):void
		{
		switch (type)
			{
				case 1:	
				switch_level("pokecenter");
				break;						
			}			
		}
		
		public function teleport_player(x:int,y:int):void
		{
		player.x = x * Constants.TILES_SIZE;
		player.y = y * Constants.TILES_SIZE;
		}		
		
		public function switch_level(name:String):void
		{					
			FlxG.flash(0xFFFFFF, 1);		
			var loadlevelstate:LoadLevelState = new LoadLevelState;
			loadlevelstate.gamelib = gamelib;
			loadlevelstate.nom_level = name;
			FlxG.switchState(loadlevelstate);
		}
		
		
		
		//////////////////////////////
		//CHATBOX
		//////////////////////////////
		
	}
}