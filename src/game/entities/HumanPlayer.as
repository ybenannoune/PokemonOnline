package game.entities 
{
	import flash.geom.Point;
	import game.state.PlayState;
	import game.utils.Constants;
	import mx.core.FlexSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author DemonYunther
	 */
	public class HumanPlayer extends Player
	{		
		public function HumanPlayer(posX:int, posY:int, parent:*) 
		{
			super(posX, posY, parent);
			human_player = true;
			//Objects de test collisions
			testCollision.height = testCollision.width = Constants.TILES_SIZE;			
			testCollision.visible = false;				
		}
		
		public override function update():void		
		{    			
            //INPUT liés au mouvement		
			if (!isMoving && !PlayState(_parent).gamelib.eventManager.writing)	
			{					
				if (FlxG.keys.LEFT || FlxG.keys.Q) 				
				{						
					if (!possible_Movement(currentTile,-1,0))
					{				
					sens = "walking_left";
					isMoving = true;		
					nextDestination.x = (currentTile.x -1); 
					nextDestination.y =  currentTile.y; // For send packet
					PlayState(_parent).sendDeplacement(nextDestination);
					}			
					else
						{
						super.play("walking_left");
						super.facing = LEFT;
						}
				}
				else if (FlxG.keys.RIGHT || FlxG.keys.D)
				{					
					if (!possible_Movement(currentTile,1,0))	
					{							
					sens = "walking_right";
					isMoving = true; 										
					nextDestination.x = (currentTile.x + 1);
					nextDestination.y =  currentTile.y; // For send packet
					PlayState(_parent).sendDeplacement(nextDestination);
					}
					else
						{
						super.play("walking_right");
						super.facing = RIGHT;
						}
				}
				else if (FlxG.keys.UP || FlxG.keys.Z) 
				{				
					if (!possible_Movement(currentTile,0,-1))	
					{			
					sens = "walking_up";
					isMoving = true; 				
					nextDestination.x = currentTile.x; 
					nextDestination.y = (currentTile.y - 1); // For send packet
					PlayState(_parent).sendDeplacement(nextDestination);	
					}
					else
						{
						super.play("walking_up");						
						}					
				}
				else if (FlxG.keys.DOWN || FlxG.keys.S)
				{				
					if (!possible_Movement(currentTile,0,1))	
					{			
					sens = "walking_down";
					isMoving = true;				
					nextDestination.x = currentTile.x; 
					nextDestination.y =  (currentTile.y + 1 ); // For send packet
					PlayState(_parent).sendDeplacement(nextDestination);
					}
					else
						{
						super.play("walking_down");					
						}
				}  	
				else if (FlxG.keys.justPressed("ENTER"))			
				{					
					FlxG.stage.focus = PlayState(_parent).chatbox.chatInput;				
				}
				else if (FlxG.keys.justPressed("SHIFT"))
				{
					trace("menu");
				}
			}		
			else if (FlxG.keys.justPressed("ENTER") && PlayState(_parent).gamelib.eventManager.writing)			
				{					
					PlayState(_parent).sendChatMessage();	
				}			
           
			super.update();
		}		
	}
}