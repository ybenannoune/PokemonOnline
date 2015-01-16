package game 
{		
	import debug.SWFProfiler;
	import flash.events.Event;	
	import game.state.MenuState;	
	import game.utils.Constants;
	import org.flixel.*;
	
	
	//Création d'une fenêtre de 800 pixel de large pour 600 de hauteur, avec comme couleur d'arrière plan : NOIR
	[SWF(width = "800" , height = "600", backgroundColor = "#000000"  , framerate="30") ] 
	[Frame(factoryClass = "game.Preloader")] // Lance la classe Preloader qui s'occupe du chargement du jeu	
	/**
	 * ...
	 * @author DemonYunther
	 */
	public class GameLauncher extends FlxGame 
	{	
		public function GameLauncher()
		{					
		super(Constants.FLIXEL_HEIGHT, Constants.FLIXEL_WIDTH, MenuState, 2); //Créer un Jeu issu du FlxGame avec comme classe de début MenuState. 400 pixel de large, 300 de haut et un zoom de 2.
		}
		
	//Function qui permet de désactiver la pause de Flixel.
	override protected function create(FlashEvent:Event):void
        {
			SWFProfiler.init(FlxG.stage,this);
            super.create(FlashEvent);
            stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
        }		

	}
}