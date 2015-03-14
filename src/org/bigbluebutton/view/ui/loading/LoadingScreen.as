package org.bigbluebutton.view.ui.loading
{
	import flash.events.MouseEvent;
	import spark.components.Button;
	
	public class LoadingScreen extends LoadingScreenBase implements ILoadingScreen
	{
		public function LoadingScreen()
		{
			super();
		}	
		
		public function dispose():void
		{

		}
		
		public function get loginButton():Button
		{
			return loginButton0;
		}
	}
}