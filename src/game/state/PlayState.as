package game.state
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.net.GroupSpecifier;
	import game.entities.EventManager;
	import game.entities.hud.Chatbox;
	import game.entities.HumanPlayer;
	import game.entities.Player;
	import game.utils.Constants;
	import game.utils.GameLibrary;
	import game.world.LevelLoader;
	import net.user1.reactor.IClient;
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	import socket.ServerConnection;
	
	public class PlayState extends FlxState
	{	
		//On crée un conteneur du joueur
		private var player:Player;		
		//Conteneur des joueurs réseau
		public var groupPlayers:FlxGroup = new FlxGroup();	
		private var groupHUD:FlxGroup = new FlxGroup();		
		//Sprite permettant de tester les collisions du joueur				

		//Créations des objets pour l'utilisation de leur fonction	
		public var chatbox:Chatbox;
		public var gamelib:GameLibrary;	
		
		//Création du tableau qui contiendra les joueurs online.
		public var listeJoueurs:Array = [];
		
		//Création de la caméra pour le scrolling qui suivra le personnage principal
		private var cam:FlxCamera;	
		
		override public function create():void
		{		
			clear();
			
			player = new HumanPlayer(gamelib.levelManager.playerSpawn.x, gamelib.levelManager.playerSpawn.y, this);			
			
			gamelib.eventManager.setEntites(this, player);
			
			//Ajout à la scène			
			add(gamelib.levelManager.layerSol);
			add(gamelib.levelManager.layerMid);			
			add(gamelib.levelManager.layerCollide);								
			add(gamelib.levelManager.layerEvents);
			//gamelib.levelManager.layerEvents.visible = false;
			
			//Joueur			
			add(groupPlayers); // Ajout du group de player qui permet de mettre les joueur reseau au même niveau que le joueur
			add(player);				
			add(player.username);
			add(player.testCollision);
			
			//Couche supérieur au personnage
			add(gamelib.levelManager.layerUp);		
					
			//Création et ajout du chat			
			chatbox = new Chatbox(sendChatMessage, this);
			groupHUD.add(chatbox);						
			add(groupHUD);
			
			//Camera
			var cam:FlxCamera = new FlxCamera(0,0, FlxG.width, FlxG.height - (Constants.CHATBOX_HEIGHT/2)); // we put the first one in the top left corner
			cam.follow(player);	
			
			//Limites du niveau
			cam.setBounds(0, 0, gamelib.levelManager.layerSol.width, gamelib.levelManager.layerSol.height, true);	
			
			//Ajout du chat 
			FlxG.stage.addChild(chatbox.chatInput);
			FlxG.stage.addChild(chatbox.chatOut);
			FlxG.addCamera(cam);				
			
			//Listener
			chatbox.chatInput.addEventListener(FocusEvent.FOCUS_IN, chatbox.chatboxInputFocus);
			chatbox.chatInput.addEventListener(FocusEvent.FOCUS_OUT, chatbox.chatboxInputFocusOut);		
			
			FlxG.play(gamelib.levelManager.musicLevel,1,true);
			
			super.create();		
		}

		override public function update():void
		{	
		super.update();	
		}			
		
		//Ajout d'un nouveau player dans la liste de joueurs
		public function newplayer(clientId:String, position:Point):void
		{		
			//Récupération des cordonnées pour créer le joueur et on vérifie qu'il existe pas déjà		
			if (listeJoueurs[clientId] == null)
			{			
			listeJoueurs[clientId] = new Player((position.x * 16), (position.y * 16), this);				
			//On rajoute les joueurs dans le group:FlxGroup		
			listeJoueurs[clientId].setUsername(clientId);
			groupPlayers.add(listeJoueurs[clientId].username);
			groupPlayers.add(listeJoueurs[clientId]);
			}
		}	
		
		//Suppression d'un joueur lors de sa deconnection ou autre.
		public function removePlayer(clientId:String):void
		{		
			groupPlayers.remove(listeJoueurs[clientId].username);
			groupPlayers.remove(listeJoueurs[clientId]);			
			delete listeJoueurs[clientId];	
		}
		
		//Envois le déplacement d'un joueur aux autres joueurs
		public function sendDeplacement(destination:Point):void
		{		
			gamelib.instanceSocket.sendDestination("DEPLACEMENT",destination);			
		}
		
		//Envois sa position actuelle
		public function sendPosition():void
		{			
			var point:Point = new Point(FlxU.floor(player.currentTile.x), FlxU.floor(player.currentTile.y));
			gamelib.instanceSocket.sendDestination("JOUEUR_CONNECTION", point);
		}
		
		//Permet l'envois de message du chat aux autres joueurs
		public function sendChatMessage():void
		{	
			FlxG.stage.focus = null;
			gamelib.eventManager.writing = false;
			//Si le champ de texte n'est pas vide alors on envois le message
			if (chatbox.chatInput.text != "")
				{
				gamelib.instanceSocket.sendMessage("CHAT", chatbox.chatInput.text);		
				}
			//Après l'envoi on efface le contenu du champ de texte
			chatbox.chatInput.text = "";			
		}
		
		//Permet d'afficher un message recu 
		public function affichageMessage(username:String,message:String):void
		{
			chatbox.afficheMessage(username,message);
		}
		
		//Permet de définir les destinations des autres joueurs réseau
		public function deplacementPlayer(clientId:String,destination:Point):void
		{	
			var player:Player = listeJoueurs[clientId] as Player;
			//Si le joueur existe alors on lui donne sa destination
			if (player)
				{			
				player.setDestination(destination);
				}
		}	
		
		//Evenements
		public function test_events():void
		{				
			var type:int = gamelib.levelManager.layerEvents.getTile(player.currentTile.x, player.currentTile.y); //get Current case of Player
			if ( type != 0)
			{				
				gamelib.eventManager.makeEvent(type);				
			}				
		}
		
	}
}