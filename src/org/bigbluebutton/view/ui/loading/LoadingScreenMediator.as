package org.bigbluebutton.view.ui.loading
{
	import mx.core.FlexGlobals;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	
	public class LoadingScreenMediator extends Mediator
	{
		[Inject]
		public var userUISettings: IUserUISession;
				
		[Inject]
		public var view: ILoadingScreen;
		
		/**
		 * Initialize listeners and Mediator initial state
		 */
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			
//			view.setVisible(false);
//			view.includeInLayout = false;
			view.loginButton.addEventListener(MouseEvent.CLICK, doLogin);
			
			userUISettings.loadingSignal.add(update);
		}
		
		/**
		 * Destroy view and listeners
		 */
		override public function destroy():void
		{
			super.destroy();
			
			//view.dispose();
			
			view = null;
			
			userUISettings.loadingSignal.remove(update);
		}
		
		private function doLogin(event:Event):void
		{
			update(false);
			userUISettings.pushPage(PagesENUM.INTERVIEWS);
		}
		
		/**
		 * Update the view when there is a chenge in the model
		 */ 
		private function update(loading:Boolean):void
		{
			if(loading)
			{
				view.setVisible(true);
				view.includeInLayout = true;
			}
			else
			{
				view.setVisible(false);
				view.includeInLayout = false;
				FlexGlobals.topLevelApplication.mainshell.visible=true;
			}
		}
	}
}