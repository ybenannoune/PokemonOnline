package game.utils 
{
	import game.entities.EventManager;
	import game.world.LevelLoader;
	import socket.ServerConnection;
	/**
	 * ...
	 * @author DemonYunther
	 */
	public class GameLibrary 
	{
		public var levelManager:LevelLoader;
		public var instanceSocket:ServerConnection;	
		public var eventManager:EventManager;	
		
		public function GameLibrary() 
		{
			levelManager = new LevelLoader();
			instanceSocket = new ServerConnection();
			eventManager = new EventManager(this);
		}		
		
	}

}