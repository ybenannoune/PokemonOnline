package socket
{  
  import debug.Debug;
  import flash.geom.Point;
  import game.state.LoadLevelState;
  import game.state.MenuState;
  import game.state.PlayState;
  import org.flixel.FlxG;

  import net.user1.reactor.IClient;
  import net.user1.reactor.Reactor;
  import net.user1.reactor.ReactorEvent;
  
  // Import the Room class
  import net.user1.reactor.Room;
  import net.user1.reactor.RoomEvent;
  
    // Import Account Class
  import net.user1.reactor.AccountManager;
  import net.user1.reactor.AccountEvent;
  import net.user1.reactor.UserAccount;
  import net.user1.reactor.AccountManagerEvent;
  import net.user1.reactor.AttributeEvent;
  import net.user1.reactor.ClientEvent;
  import net.user1.reactor.Status;
 
  public class ServerConnection 
  {
	public var reactor:Reactor;		
	public var instanceGame:PlayState;
	public var accountManager:AccountManager;	
	
	private var pokemonRoom:Room;  	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////Fonctions de connection/deconnection                   //////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//Connection au serveur à l'initialisation de l'objet
	public function ServerConnection () 
	{					
      reactor = new Reactor();       
	  // Register account manager listeners
      accountManager = reactor.getAccountManager();
      accountManager.addEventListener(AccountManagerEvent.CREATE_ACCOUNT_RESULT,createAccountResultListener);
      accountManager.addEventListener(AccountManagerEvent.REMOVE_ACCOUNT_RESULT, removeAccountResultListener);
      accountManager.addEventListener(AccountEvent.LOGIN_RESULT,loginResultListener);
      accountManager.addEventListener(AccountEvent.LOGIN,loginListener);
      accountManager.addEventListener(AccountEvent.LOGOFF_RESULT,logoffResultListener);
      accountManager.addEventListener(AccountEvent.LOGOFF,logoffListener);
	  reactor.connect("tryunion.com", 80);

	}

	public function joinRoom(name_room:String) : void
	{
		//Si une room est déjà active alors on la quitte
		if (pokemonRoom != null)
		{			
			pokemonRoom.removeMessageListener("JOUEUR_CONNECTION", connectMessageListener);
			pokemonRoom.removeMessageListener("DEPLACEMENT", deplacementMessageListener);
			pokemonRoom.removeMessageListener("CHAT" , chatMessageListener);
			pokemonRoom.removeEventListener(RoomEvent.JOIN, onRoomJoined);
			pokemonRoom.removeEventListener(RoomEvent.REMOVE_OCCUPANT, removeClientListener);	
			pokemonRoom.leave();
			pokemonRoom = null;	
		}
		
		//On demande au serveur de créer/de rejoindre une room du nom de la map
		pokemonRoom = reactor.getRoomManager().createRoom(name_room);
		//On rajoute les listeners associés à la ROOM
		pokemonRoom.addMessageListener("JOUEUR_CONNECTION", connectMessageListener);
		pokemonRoom.addMessageListener("DEPLACEMENT", deplacementMessageListener);
		pokemonRoom.addMessageListener("CHAT" , chatMessageListener);
		pokemonRoom.addEventListener(RoomEvent.JOIN, onRoomJoined);
		pokemonRoom.addEventListener(RoomEvent.REMOVE_OCCUPANT,removeClientListener);
		
		pokemonRoom.join(); // Join the room	
	}	
	
	private function onRoomJoined(e:RoomEvent):void 
	{		
		sendMessage("JOUEUR_CONNECTION", "connected"); 			
	}
	
	protected function removeClientListener (e:RoomEvent):void
	{
		instanceGame.removePlayer(e.getClientID());    
    }
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////Fonctions d'envois                                     //////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////

	public function sendMessage(listener:String,message:String):void
	{
		pokemonRoom.sendMessage(listener, true, null, message);			
	}
	
	public function sendDestination(listener:String,destinationPoint:Point):void
	{
		var message:String = "" + destinationPoint.x + "." + destinationPoint.y ;	
		pokemonRoom.sendMessage(listener, false, null, message);		
	}
	  
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////Fonctions de Receptions                                //////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//Récuperation des cordonnées des joueurs 
	protected function deplacementMessageListener (fromClient:IClient,message:String):void
		{				
		var splitter:Array = message.split(".");		
		var destinationPoint:Point = new Point(splitter[0], splitter[1]);
		instanceGame.deplacementPlayer(fromClient.getClientID(), destinationPoint);
		}
	
	//Récupération des messages du chat
	protected function chatMessageListener (fromClient:IClient,messageText:String):void
		{								
		instanceGame.affichageMessage(getUserName(fromClient), messageText);
		}		
		
	//Récupération du pseudo pour le chat
	protected function getUserName (client:IClient):String 
	{
      var username:String = client.getAttribute("username");
        if (username == null) {
          return "Guest" + client.getClientID();
        } else {
          return username;
        }
	}	
	
	//Récupération de la liste des joueurs déjà connectés
	public function getListPlayers():Array
	{
		return pokemonRoom.getOccupants();
	}
		
	//Récuperation de notre id personnel
	public function getOurId():String
	{			
		return reactor.self().getClientID();
	}

	//Récupération des messages lié a la connection d'un joueur
	protected function connectMessageListener(fromClient:IClient,message:String):void
	{
		switch (message)
		{		
		case "connected": //Quand quelqu'un se connecte
			if (instanceGame)
			{			
				instanceGame.sendPosition(); //Quand on recois la connection de quelqu'un, chaqun envois ses positions pour le nouveau joueur
			}
		break;					
		default:	
		//Ici on recois les positions pour chaque joueurs.
		var splitter:Array = message.split(".");			
		var destinationPoint:Point = new Point(splitter[0], splitter[1]);
		//On créer chaque nouveau players avec sa position envoyé
		if (fromClient.getClientID() != getOurId())
			{			
			instanceGame.newplayer(fromClient.getClientID(), destinationPoint);
			}
		break;
		}		
	}
	
//==============================================================================
// ACCOUNT MANAGER EVENT LISTENERS
//==============================================================================

    protected function createAccountResultListener (e:AccountManagerEvent):void {
      trace("Create account result for [" + e.getUserID() + "]: " + e.getStatus());
    }

    protected function removeAccountResultListener (e:AccountManagerEvent):void {
      trace("Remove account result for [" + e.getUserID() + "]: " + e.getStatus());
    }
    
//==============================================================================
// ACCOUNT EVENT LISTENERS
//==============================================================================
    //Résultat de la tentavite de loggin
    protected function loginResultListener (e:AccountEvent):void {		
      trace("Login result for [" + e.getUserID() + "]: " + e.getStatus());	  
	  if (e.getStatus() == "SUCCESS")
	  {	
		//Une fois connecté plus besoin des listener de type compte.	
		accountManager.removeEventListener(AccountManagerEvent.CREATE_ACCOUNT_RESULT,createAccountResultListener);
		accountManager.removeEventListener(AccountManagerEvent.REMOVE_ACCOUNT_RESULT, removeAccountResultListener);
		accountManager.removeEventListener(AccountEvent.LOGIN_RESULT,loginResultListener);
		accountManager.removeEventListener(AccountEvent.LOGIN,loginListener);
		accountManager.removeEventListener(AccountEvent.LOGOFF_RESULT,logoffResultListener);
		accountManager.removeEventListener(AccountEvent.LOGOFF, logoffListener);	
	  }
    }
	
    //Joueur qui est entrain de se log
    protected function loginListener (e:AccountEvent):void {   
      // Display a login message
      trace("Account logged in [" + e.getUserID() + "]");      
      // Register for attribute assignment result
      e.getAccount().addEventListener(AttributeEvent.SET_RESULT, 
                                      setAttributeResultListener);     
    }
	
    //Joueur déconnecté -
    protected function logoffResultListener (e:AccountEvent):void {
      trace("Logoff result for [" + e.getUserID() + "]: " + e.getStatus());
    }
    
	//Resultat de la deconnection
    protected function logoffListener (e:AccountEvent):void {
      trace("Account logged off [" + e.getUserID() + "]");
      // Unregister for attribute assignment result
      e.getAccount().removeEventListener(AttributeEvent.SET_RESULT, 
                                         setAttributeResultListener);
    }
    
	//==============================================================================
	// CLIENT EVENT FOR ATTRIBUTE ACCOUNT
	//==============================================================================
		
    protected function setAttributeResultListener (e:AttributeEvent):void
	{
		
	}
	
   }
}
