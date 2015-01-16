package game
{
    import org.flixel.system.FlxPreloader;	
	
	public class Preloader extends FlxPreloader
	{
		//Lance l'écran de chargement du jeu au tout début
		public function Preloader()
		{			
			//La classe qui doit lancer en premier
			className = "game.GameLauncher";
			//le temps minimum d'affichage de l'écran de chargement
			minDisplayTime = 2;
			super.create();
		}
	}
}