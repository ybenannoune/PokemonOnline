package game.entities.hud 
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.text.engine.TextBlock;
	import flash.text.TextFieldType;
	import game.state.PlayState;
	import game.utils.Constants;
	import game.utils.TextInput;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author DemonYunther
	 */
	public class Chatbox extends FlxGroup
	{				
		[Embed(source = "../../../../lib/embed/envoyer.png")] public var buttonSend:Class;
		
		protected var _parent:FlxState;
		protected var bouton:FlxButton;				
		public var chatOut:TextInput;
		public var chatInput:TextInput;
		
		public function Chatbox(clickListener:Function,parent:*)
		{		
		_parent = parent;
		//Création du bouton envoyer
		bouton = createButton("", clickListener);
		chatOut = new TextInput(Constants.CHATBOX_X, Constants.CHATBOX_Y, Constants.CHATBOX_WIDTH, Constants.CHATBOX_HEIGHT, "");
		chatOut.type = TextFieldType.DYNAMIC;	
		chatOut.wordWrap = true;	
		chatInput = new TextInput(Constants.CHATBOX_X,Constants.CHATBOX_Y + Constants.CHATBOX_HEIGHT,Constants.CHATBOX_WIDTH - Constants.CHATBOX_HEIGHT,Constants.CHATBOX_HEIGHT - 80,"Entrer un message");					
		add(bouton);				
		}
		
		private function createButton(label:String, clickListener:Function):FlxButton 
		{
		var button:FlxButton = new FlxButton(350,290,label, clickListener);
		button.scrollFactor.x = button.scrollFactor.y = 0;
		button.loadGraphic(buttonSend, false, false, 50, 10);	
		return button;
		}		
		
		public function afficheMessage(username:String,message:String):void
		{
		chatOut.text += username + ": " + message + "\n";
		chatOut.scrollV = chatOut.maxScrollV;
		}
		
		public function chatboxInputFocus(e:Event):void
		{		
		PlayState(_parent).gamelib.eventManager.writing = true;
			if (chatInput.text == "Entrer un message")
			{
				chatInput.text = "";
			}		
		}		
		
		public function chatboxInputFocusOut(e:Event):void
		{		
		PlayState(_parent).gamelib.eventManager.writing = false;
		}				
	}	
}