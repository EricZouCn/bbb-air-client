package org.bigbluebutton.view.navigation.pages.interviews
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.Interview;
	import org.bigbluebutton.model.InterviewList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class InterviewsViewMediator2 extends Mediator
	{
		[Inject]
		public var view: IInterviewsView2;
		
		[Inject]
		public var userSession: IUserSession
		
		[Inject]
		public var userUISession: IUserUISession

		
		protected var dataProvider:ArrayCollection;
		protected var dicUserIdtoUser:Dictionary
		protected var usersSignal:ISignal; 
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			dataProvider = new ArrayCollection();
			view.list.dataProvider = dataProvider;
			
			view.list.addEventListener(IndexChangeEvent.CHANGE, onSelectInterview);
			
			dicUserIdtoUser = new Dictionary();
			
//			var interviews:ArrayCollection = userSession.userList.users;
			var interviews:ArrayCollection = new ArrayCollection();
			var interview1:Interview = new Interview();
			interview1.position = "软件工程师";
			interview1.datetime = "2015.3.5 10:30";
			interviews.addItem(interview1);
			interview1 = new Interview();
			interview1.position = "测试工程师";
			interview1.datetime = "2015.3.6 16:15";
			interviews.addItem(interview1);
			
			for each (var interview:Interview in interviews)
			{
				addInterview(interview);
			}
			
			setPageTitle();
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
		}
		
		private function addInterview(interview:Interview):void
		{
			dataProvider.addItem(interview);
			dataProvider.refresh();
//			dicInterviewIdtoInterview[interview.interviewID] = interview;
			setPageTitle();
		}
		
		protected function onSelectInterview(event:IndexChangeEvent):void
		{
//			if (event.newIndex >= 0) {
//				var user:User = dataProvider.getItemAt(event.newIndex) as User;
//				userUISession.pushPage(PagesENUM.USER_DETAIS, user, TransitionAnimationENUM.SLIDE_LEFT);
//			}
		}
		
		/**
		 * Count participants and set page title accordingly
		 **/
		private function setPageTitle():void
		{
			if(dataProvider != null)
			{
				FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'interviews.title');
			}
		}
			
		override public function destroy():void
		{
			super.destroy();
			
			view.dispose();
			view = null;
		}
	}
}