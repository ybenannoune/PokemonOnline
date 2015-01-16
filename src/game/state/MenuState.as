package game.state
{
  
  import flash.events.Event;
  import game.GameLauncher;
  import game.utils.Constants;
  import game.utils.GameLibrary;
  import game.utils.TextInput;
  import net.user1.reactor.ReactorEvent;
  import net.user1.reactor.UserAccount;
  import org.flixel.*;
  import socket.ServerConnection;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.text.TextFieldType;
  import flash.text.TextFormat;
  import flash.text.TextFormatAlign;  
  	
	public class MenuState extends FlxState
	{		
		//Création des ressources du menu
		[Embed(source = "../../../lib/embed/titlescreen.png")] public var MenuBg:Class;		
		[Embed(source = "../../../lib/embed/menu_theme.mp3")] public var MusicMenu:Class;	
		
		private var bg:FlxSprite = new FlxSprite; //fond
		private var gamelib:GameLibrary;		
		
		//==============================================================================
		// VARIABLES
		//==============================================================================
		private var useridInput:TextInput;
		private var passwordInput:TextInput;
		private var createAccountButton:FlxButton;
		private var removeAccountButton:FlxButton;
		private var loginButton:FlxButton;
		private var logoffButton:FlxButton;	
		private var output:FlxText;		
		private var guest:FlxButton;	
		
		override public function create():void
		{
			//On active la souris pour les menu
			FlxG.mouse.show(null, 1, 0, 0);
			
			//Création de la GameLib
			gamelib = new GameLibrary();	
			
			wait_connect();				
			
			//load_menu(null);	//ByPASS LOGIN
			
			gamelib.instanceSocket.reactor.addEventListener(ReactorEvent.READY, load_menu);			
		} 
		
		public function wait_connect():void
		{
			var text:FlxText = new FlxText(Constants.FLIXEL_HEIGHT/2 - 50, Constants.FLIXEL_WIDTH/2, 150, "En attente de la connection...", true);
			add(text);
		}
 
		public function load_menu(e:Event):void
		{		
			//On vide Flixel
			clear();
			
			//Lancement de la musique			
			FlxG.play(MusicMenu, 1, false);		
			
			//Fond de Menu
			bg.loadGraphic(MenuBg, true, true, 400, 300);
            add(bg);
			
			//UI Login/Pass
			createUI();	
		} 
			
		
		override public function update():void
		{
			super.update();
		} 

	//==============================================================================
	// UI CREATION
	//==============================================================================
		
		public function createUI ():void {
		  useridInput         = createInputField("Login");
		  passwordInput       = createInputField("Password");
		  createAccountButton = createButton("Create Account", 
											 createAccountClickListener);
		  removeAccountButton = createButton("Remove Account", 
											 removeAccountClickListener);
		  loginButton         = createButton("Login", loginClickListener);
		  logoffButton        = createButton("Logoff", logoffClickListener);		
		  output              = createOutputField();
		  guest        		  = createButton("Guest", guestClickListener);	
		  
		  guest.x = 240;
		  guest.y = 120;
		  useridInput.y = 290;
		  useridInput.x = 320;
		  passwordInput.x = 320;
		  passwordInput.y = 330;		  
		  createAccountButton.x = 150;
		  createAccountButton.y = 90;
		  removeAccountButton.x = 230;
		  removeAccountButton.y = 90;
		  loginButton.x = 160;
		  loginButton.y = 120;
		  logoffButton.x = 230;
		  logoffButton.y = 110;		
		  output.y = 150;		  
		  FlxG.stage.addChild(useridInput);
		  FlxG.stage.addChild(passwordInput);
		  //add(createAccountButton);
		  //add(removeAccountButton);
		  //add(loginButton); 
		  //add(logoffButton);
		  add(guest);
		  add(output);	
		}
		
		//Création du champ de texte
		public function createInputField (text:String):TextInput {
		  var textfield:TextInput = new TextInput(10, 10, 120, 30, text);		  
		  return textfield;
		}		
		//Création des zones de text
		public function createOutputField ():FlxText {
		  var textfield:FlxText = new FlxText(10,350,350,"");	
		  return textfield;
		}		
		
		public function createButton (label:String, clickListener:Function):FlxButton 
		{
		  var button:FlxButton = new FlxButton(0,150,label, clickListener);
		  return button;
		}
	//==============================================================================
	// UI CONTROL
	//==============================================================================
		
    public function out (message:String):void {
      output.text += message + "\n";   
    }
		
	//==============================================================================
	// UI LISTENERS
	//==============================================================================
		
    public function createAccountClickListener ():void 
	{
      gamelib.instanceSocket.accountManager.createAccount(useridInput.text,passwordInput.text);
    }
    
    public function removeAccountClickListener ():void 
	{
      gamelib.instanceSocket.accountManager.removeAccount(useridInput.text,passwordInput.text);
    }
    
    public function loginClickListener ():void 
	{
		FlxG.stage.removeChild(useridInput);
		FlxG.stage.removeChild(passwordInput);
		guest.exists = false;
		loginButton.exists = false;
		clear();
		gamelib.instanceSocket.accountManager.login(useridInput.text, passwordInput.text);
		
    }
    
    public function logoffClickListener ():void 
	{
      gamelib.instanceSocket.accountManager.logoff(useridInput.text,passwordInput.text);
    }
	
	public function guestClickListener ():void 
	{		
	FlxG.stage.removeChild(useridInput);
	FlxG.stage.removeChild(passwordInput);
	guest.exists = false;
	loginButton.exists = false;
	clear();
			var loadlevelstate:LoadLevelState = new LoadLevelState()	
			loadlevelstate.gamelib = gamelib;
			FlxG.switchState(loadlevelstate);			
    }

  }
}

