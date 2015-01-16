package game.state
{
	import ch.capi.net.ILoadInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import game.utils.GameLibrary;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import game.world.LevelLoader;
	import org.flixel.FlxText;
	import socket.ServerConnection;
	
	public class LoadLevelState extends FlxState
	{		
		public var gamelib:GameLibrary;	
		
		private var progress:FlxText;
		
		public var nom_level:String; 		
		
		override public function create():void
		{		
			if (!nom_level)
			{
				nom_level = "bourgenvol";
			}		
			
			//Create New Loader
			gamelib.levelManager = new LevelLoader();	
			gamelib.levelManager.loadLevel(nom_level);
			
			var leveltxt:FlxText = new FlxText(0, 90, FlxG.width, "Loading Level...");
			progress = new FlxText(0, 110, FlxG.width, "");
					
			
			leveltxt.setFormat(null, 14, 0xFFFFFFFF, "center");
			progress.setFormat(null, 14, 0xFFFFFFFF, "center");
			
			add(leveltxt);
			add(progress);			
			
			gamelib.levelManager.cml.massLoader.addEventListener(Event.COMPLETE, Loaded);		
			gamelib.levelManager.cml.massLoader.addEventListener(ProgressEvent.PROGRESS, handleProgress);			
			
			super.create();			
		}
		
		private function handleProgress(evt:ProgressEvent):void
		{
		//Affiche la progression en temps réel du chargement
		var infos:ILoadInfo = gamelib.levelManager.cml.massLoader.loadInfo;	
		progress.text = "Progression:" +infos.percentLoaded;
		}
		
		public function Loaded(e:Event):void
		{		
			//Une fois les elements de la map chargé on créer une nouvelle instance de jeu.
			gamelib.levelManager.Loaded();							
			gamelib.instanceSocket.joinRoom(nom_level);			
			var playstate:PlayState = new PlayState();	
			playstate.gamelib = gamelib;			
			gamelib.instanceSocket.instanceGame = playstate; 	
			FlxG.switchState(playstate);
		}
		
		override public function update():void
		{
				super.update();
		}
	}
}