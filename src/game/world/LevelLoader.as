package game.world 
{
	import ch.capi.net.CompositeMassLoader;
	import ch.capi.net.DataType;
	import ch.capi.net.ILoadableFile;
	import ch.capi.net.ILoadInfo;
	import ch.capi.net.LoadableFileType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;	
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;	
	import game.utils.Constants;
	/**
	 * ...
	 * @author DemonYunther
	 */
	public class LevelLoader 
	{			
		[Embed(source = "../../../lib/embed/tiles.png")] public var tilesWorld:Class;		
		[Embed(source = "../../../bin/levels/pokecenter/pokecenter.png")] public var tilesCenter:Class;				
		[Embed(source = "../../../lib/embed/events.png")] public var tilesEvents:Class;			
		
		public var layerSol:FlxTilemap = new FlxTilemap();
		public var layerMid:FlxTilemap = new FlxTilemap();
		public var layerCollide:FlxTilemap = new FlxTilemap();
		public var layerUp:FlxTilemap = new FlxTilemap();				
		public var layerEvents:FlxTilemap = new FlxTilemap();			
		
		public var cml:CompositeMassLoader = new CompositeMassLoader();	
		private var levels:ILoadableFile;
		private var music:ILoadableFile;
		private var tileset:ILoadableFile;
		public var musicLevel:Class;
		
		public var playerSpawn:FlxPoint = new FlxPoint();
		
		private var nom:String;
		
		public function LevelLoader() 
		{
	
		}
		
		//////////////////////////////
		/*
		 * 
		 * LOADER REVISION ----------------------------------
		 * 
		 * LOAD FILE => loader[i] = new IlodableFile;
		 * 
		 * if(!already_loaded)
		 * loader[i].cml.addFile("        ");
		 * 
		 * 
		 * 
		 * NEW LOAD :
			 * 
			 * for each (var i:int in loader[])
			 * {
			 * if(loader[i].nameFile == "newload")
			 * already_loaded = true;
			 * }
		 * 
		 * 		
		protected function ajoutesXML(fichiers:Array):void
			{
				var file:ILoadableFile;
 
				for each(var o:Object in fichiers)
				{
					file = cml.addFile(o.fichier, o.type);			
					file.addEventListener(Event.COMPLETE, handleComplete);
				}							
			}
			
					
		protected function ajoutesTileset(fichiers:Array):void
			{
				var file:ILoadableFile;
 
				for each(var o:Object in fichiers)
				{
					file = cml.addFile(o.fichier, o.type);			
					file.addEventListener(Event.COMPLETE, handleComplete);
				}							
			}
					
		protected function ajoutesMusic(fichiers:Array):void
			{
				var file:ILoadableFile;
 
				for each(var o:Object in fichiers)
				{
					file = cml.addFile(o.fichier, o.type);			
					file.addEventListener(Event.COMPLETE, handleComplete);
				}							
			}
				protected function handleComplete(e:Event):void
			{
				ta.text += (e.target as ILoadableFile).urlRequest.url + " chargé \n";	
			}
		 * 	  
		 * 
		 * ajouteFichiers(["levels/" + nom_map + "/data.xml", "levels/music/music_pack1.swf", "levels/" + nom_map + "/" + nom_map + ".png");
		 */
		
		public function loadLevel(nom_map:String):void
		{ 			
		levels = cml.addFile("levels/" + nom_map + "/" + nom_map + ".xml");		
		music = cml.addFile("levels/music/music_pack1.swf");			
		tileset = cml.addFile("levels/" + nom_map + "/" + nom_map + ".png");		
		cml.start();		
		nom = nom_map;
		}		
		
		
		public function Loaded():void 
		{ 					
			var xmlData:XML = levels.getData("XML"); //récupération au format XML
		
			var ldr:LoaderInfo = music.getData(DataType.LOADER).contentLoaderInfo; //Recuperation des musiques dans music_pack
			musicLevel = ldr.applicationDomain.getDefinition(nom) as Class;			
			
			//var tileset:Class = tileset.getData() as Class; //récupération au format XML				
			
			if ( nom == "bourgenvol")
			{
			layerSol.loadMap(xmlData.layer[0], tilesWorld, Constants.TILES_SIZE, Constants.TILES_SIZE);				
			layerMid.loadMap(xmlData.layer[1], tilesWorld, Constants.TILES_SIZE, Constants.TILES_SIZE);				
			layerCollide.loadMap(xmlData.layer[2], tilesWorld, Constants.TILES_SIZE, Constants.TILES_SIZE);				
			layerUp.loadMap(xmlData.layer[3], tilesWorld, Constants.TILES_SIZE, Constants.TILES_SIZE);							
			layerEvents.loadMap(xmlData.layer[4], tilesEvents, Constants.TILES_SIZE, Constants.TILES_SIZE);	
			}
			else
			{
			layerSol.loadMap(xmlData.layer[0], tilesCenter, Constants.TILES_SIZE, Constants.TILES_SIZE);				
			layerMid.loadMap(xmlData.layer[1], tilesCenter, Constants.TILES_SIZE, Constants.TILES_SIZE);				
			layerCollide.loadMap(xmlData.layer[2], tilesCenter, Constants.TILES_SIZE, Constants.TILES_SIZE);				
			layerUp.loadMap(xmlData.layer[3], tilesCenter, Constants.TILES_SIZE, Constants.TILES_SIZE);							
			layerEvents.loadMap(xmlData.layer[4], tilesCenter, Constants.TILES_SIZE, Constants.TILES_SIZE);	
			}	
			
			playerSpawn.x = xmlData.player.x;
			playerSpawn.y = xmlData.player.y;
		}
	
	}

}