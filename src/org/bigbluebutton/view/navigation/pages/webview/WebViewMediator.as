package org.bigbluebutton.view.navigation.pages.webview
{
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.command.RaiseHandSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class WebViewMediator extends Mediator
	{
		[Inject]
		public var view: IWebView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession
		
		[Inject] 
		public var raiseHandSignal: RaiseHandSignal;
		
		[Inject]
		public var disconnectUserSignal: DisconnectUserSignal;
			
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			
			var obj:Object = userUISession.currentPageDetails;
			
			FlexGlobals.topLevelApplication.pageName.text = obj.title; //ResourceManager.getInstance().getString('resources', 'profile.title');
			view.setUrl(obj.page);
			
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;			
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			view.dispose();
			view = null;
		}
	}
}
