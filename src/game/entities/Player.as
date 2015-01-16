package game.entities
{
	import flash.geom.Point;
	import game.state.PlayState;
	import game.utils.Constants;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author DemonYunther
	 */
	public class Player extends FlxSprite
	{
		//Besoin du constructeur
		[Embed(source = "../../../lib/embed/sasha.png")] private var Hero:Class;
		   
		protected var _parent:FlxState;
	
		//Variable de mouvement
		private var move_done:Number = 0;	
		public var sens:String = "";	
		private var tile_destination:Array = [];		
		protected var nextDestination:Point = new Point();
		
		//Variables de test
		protected var human_player:Boolean = false;
		protected var isMoving:Boolean = false;
		protected var inEvent:Boolean = false;
		
		//Points
		public var currentTile:Point;	
		
		//Pseudo du joueur , par défaut "VOUS"
		public var username:FlxText = new FlxText(10, 10, 100, "Vous");
		public var testCollision:FlxSprite = new FlxSprite();	
		
		public function Player(posX:int, posY:int, parent:*):void
		{
			//Position d'origine du player
			super(posX, posY);			
			
			//Chargement du spritesheet						
			loadGraphic(Hero, true, true, 16, 19);
			
			//Création des différentes animations
			addAnimation("walking_up", [3, 4, 5], 5, false);
			addAnimation("walking_down", [0, 1, 2], 5, false);
			addAnimation("walking_left", [6, 7, 8], 5, false);
			addAnimation("walking_right", [6, 7, 8], 5, false);		
			
			//La taille du personnage dépassant 16 en hauteur, on décale son coin gauche de 3 pixel et on refixe sa taille de collision.
			offset.y = 3;
			height = Constants.TILES_SIZE;			
			getCurrentTile();	
			//Permet d'initaliser sa prochaine destination a sa position, sinon le joueur fait un passage au cordonnée (0,0)
			nextDestination = currentTile;
			updateUsernameLocation();
			
			_parent = parent;
		}
		
		public override function update():void
		{					
			if (isMoving == true)
			{		
				move();
				play(sens);
				updateUsernameLocation();
			}		
			super.update();
		}
		
		public function move():void
		{			
			if ((nextDestination.x == currentTile.x && nextDestination.y == currentTile.y && !human_player))
			{		
				goNextTile();	
			}
			
			move_done += Constants.PLAYER_RUN_SPEED;	
			
			switch(sens)
			{
			case "walking_up":
			y -= Constants.PLAYER_RUN_SPEED;	
			break;
			case "walking_down":
			y += Constants.PLAYER_RUN_SPEED;		
			break;			
			case "walking_left":
			x -= Constants.PLAYER_RUN_SPEED;
			if (facing != LEFT)
				{
					facing = LEFT;
				}
			break;			
			case "walking_right":
			x += Constants.PLAYER_RUN_SPEED;		
			if ( facing != RIGHT)
				{
				 facing = RIGHT;
				}
			break;		
			}
			
			if (move_done >= Constants.TILES_SIZE)
				{	
					move_done = 0;						
					isMoving = false;							
					if (!human_player)
					{		
						getCurrentTile();	
						goNextTile();						
					}
					else
					{
						PlayState(_parent).test_events();
					}
				}	
		}
		
		//Permet d'obtenir la position du joueur
		public function getCurrentTile():void
		{			
			currentTile = new Point(this.x / Constants.TILES_SIZE, this.y / Constants.TILES_SIZE);						
		}
		
		//Permet de définir la prochaine déstination du joueur
		public function setDestination(destination:Point):void
		{				
			tile_destination.push(destination);		
			isMoving = true;		
		}
		
		public function goNextTile():void
		{					
			if (tile_destination.length != 0)
			{			
				isMoving = true;
				nextDestination = tile_destination.shift();	
				sensMove();		
			}
			else
			{				
				isMoving = false;
			}
		}
		
		public function sensMove():void
		{					
			if (nextDestination.x < currentTile.x)
			{				
				sens = "walking_left";
			}
			else if (nextDestination.x > currentTile.x)
			{
				sens = "walking_right";
			}						
			else if (nextDestination.y < currentTile.y)
			{
				sens = "walking_up";
			}
			else if (nextDestination.y > currentTile.y)
			{
				sens = "walking_down";
			}			
		}
		
		public function setUsername(pseudo:String):void
		{
			username.text = pseudo;		
		}
		
		public function updateUsernameLocation(): void
		{	
			username.x = (this.x - this.width + 7);
			username.y = (this.y - this.height);			
		}
	
		public function possible_Movement(result:Point,x:int, y:int):Boolean
		{						
			testCollision.x = (( result.x * 16) + x);		
			testCollision.y = (( result.y * 16) + y);			
			return FlxG.collide(testCollision, PlayState(_parent).gamelib.levelManager.layerCollide);					
		}	
	}

}
