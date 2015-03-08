package org.bigbluebutton.view.navigation.pages.login
{
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.ILoginService;
	import org.bigbluebutton.core.util.URLFetcher;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.model.Interview;
	import org.bigbluebutton.view.navigation.IPagesNavigatorView;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.flexunit.internals.namespaces.classInternal;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.components.Application;

	public class LoginPageViewMediator extends Mediator
	{
		[Inject]
		public var view: ILoginPageView;

		[Inject]
		public var joinMeetingSignal: JoinMeetingSignal;

		[Inject]
		public var loginService: ILoginService;

		[Inject]
		public var userSession: IUserSession;

		[Inject]
		public var userUISession: IUserUISession;
		
		static var isBusy:int;


		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));

			//loginService.unsuccessJoinedSignal.add(onUnsucess);
			userUISession.unsuccessJoined.add(onUnsucess);

			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent2);
			userUISession.videoSignal.add(onInvokeEvent);
			
			userSession.logoutSignal.add(logout);
			
			isBusy = 0;
		}

		private function onUnsucess(reason:String):void 
		{
			Log.getLogger("org.bigbluebutton").info(String(this) + ":onUnsucess() " + reason);
			FlexGlobals.topLevelApplication.topActionBar.visible=false;
			FlexGlobals.topLevelApplication.bottomMenu.visible=false;

			switch(reason) {
				case "emptyJoinUrl":
					view.currentState = LoginPageViewBase.STATE_NO_REDIRECT;
					break;
				case "invalidMeetingIdentifier":
					view.currentState = LoginPageViewBase.STATE_INVALID_MEETING_IDENTIFIER;
					break;
				case "checksumError":
					view.currentState = LoginPageViewBase.STATE_CHECKSUM_ERROR;
					break;
				case "invalidPassword":
					view.currentState = LoginPageViewBase.STATE_INVALID_PASSWORD;
					break;
				case "invalidURL":
					view.currentState = LoginPageViewBase.STATE_INAVLID_URL;
					break;
				case "genericError":
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
				default:
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
			}
			// view.messageText.text = reason;
		}
		
		public function logout():void
		{
			isBusy = 0;
		}

		public function onInvokeEvent(interview:Interview):void 
		{
			if(isBusy == 0) {
				NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);
				
				var createUrl:String = "http://bbb.17mian.cn:80/bigbluebutton/api/create?meetingID=Demo+Meeting&attendeePW=ap&moderatorPW=mp&welcome=Welcome+to+17mian+meeting%21&checksum=406f9df41be2309d9a79f7c990f54c2c52de0f3e";
				var fetcher:URLFetcher = new URLFetcher();
				fetcher.successSignal.add(onSuccess);
				fetcher.unsuccessSignal.add(onUnsucess);
				fetcher.fetch(createUrl);
				
//				isBusy = 1;
			}
		}

		public function onInvokeEvent2(invocation:InvokeEvent):void 
		{
			userUISession.loading = false;
			userUISession.pushPage(PagesENUM.INTERVIEWS);
		}
		
		protected function onSuccess(data:Object, responseUrl:String, urlRequest:URLRequest):void {
//			try {
//				var xml:XML = new XML(data);
//				if (xml.returncode == XML_RETURN_CODE_FAILED) {
//					onUnsuccess(xml.messageKey);
//					return;
//				}
//			} catch (e:Error) {
//				switch(e.name)
//				{
//					case URL_REQUEST_ERROR_TYPE:
//						onUnsuccess(URL_REQUEST_INVALID_URL_ERROR);
//						break;
//					default:
//						onUnsuccess(URL_REQUEST_GENERIC_ERROR);
//				}
//				
//				trace("The response is probably not a XML. " + e.message);
//				return;
//			}
			
//			var url:String = invocation.arguments.toString();

//			if(Capabilities.isDebugger)
//			{
				// test-install server no longer works with 0.9 mobile client

//				url = "bigbluebutton://test-install.blindsidenetworks.com/bigbluebutton/api/join?fullName=Air&meetingID=Demo+Meeting&password=ap&checksum=5126http://bbb.17mian.cn:80/bigbluebutton/api/join?meetingID=Demo+Meeting&fullName=Android&redirectClient=false&password=ap&checksum=5ffce4cc12bdc350fd64cabd78220179852dadd6fe0665a48bcb852a3c0afac";
			var url:String = "http://bbb.17mian.cn:80/bigbluebutton/api/join?meetingID=Demo+Meeting&fullName=Android&redirectClient=false&password=ap&checksum=5ffce4cc12bdc350fd64cabd7820bab8b032dae3";
//				url = "http://bbb.17mian.cn:80/bigbluebutton/api/join?meetingID=Demo+Meeting&fullName=Android&redirectClient=false&password=ap&checksum=5ffce4cc12bdc350fd64cabd7820bab8b032dae3";
				//url = "bigbluebutton://lab1.mconf.org/bigbluebutton/api/join?fullName=Air+client&meetingID=Test+room+4&password=prof123&checksum=5805753edd08fbf9af50f9c28bb676c7e5241349"
//			}

			if (url.lastIndexOf("://") != -1)
			{
				NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent2);	

				url = getEndURL(url);
			}
			else
			{

			}

			joinMeetingSignal.dispatch(url);
		}
		
		/**
		 * Replace the schema with "http"
		 */ 
		protected function getEndURL(origin:String):String
		{
			return origin.replace('bigbluebutton://', 'http://');
		}

		override public function destroy():void
		{
			super.destroy();

			//loginService.unsuccessJoinedSignal.remove(onUnsucess);
			userUISession.unsuccessJoined.remove(onUnsucess);

			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);

			view.dispose();
			view = null;
		}
	}
}

