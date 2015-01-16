package game.utils 
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author DemonYunther	 * 
	 */
	
	 //Classe que j'ai fait pour créer des champ de texte facilement	
	public class TextInput extends TextField
	{
		//On créer un compte de texte avec comme réglages les paramètres que on lui envoit, genre sa position , sa hauteur, largeur son contenu ect...
		public function TextInput(_x:int,_y:int,_width:int,_height:int,label:String)
		{
		text = label;			
		type = TextFieldType.INPUT;			
		x = _x;
		y = _y;
		width = _width;
		height = _height;
		background = true;		 
		border = true;		 	
		}		
	}

}