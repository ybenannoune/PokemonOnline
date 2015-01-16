package game.entities
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author DemonYunther
	 */
	public class Pokemon extends FlxSprite
	{			   						
		//Paramètres d'un Pokemon
		private var PV:Number = 0;	
		private var FORCE:Number = 0;
	    private var EXPERIENCE:Number = 0;	
		private var TAUX_CAPTURE:Number = 0;	
		//STATS DU POKEMON
		private var STATS_Attaque:Number = 0;	
		private var STATS_Defense:Number = 0;	
		private var STATS_AttaqueSPE:Number = 0;
		private var STATS_DefenseSPE:Number = 0;
		private var STATS_Vitesse:Number = 0;		
		
		//Constructeur
		public function Pokemon():void
		{
			
		}
		
		public override function update():void
		{			
			super.update();
		}
		
		
	}

}
