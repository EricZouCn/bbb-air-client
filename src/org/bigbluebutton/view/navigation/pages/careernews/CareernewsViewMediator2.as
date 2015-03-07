package org.bigbluebutton.view.navigation.pages.careernews
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.net.URLRequest;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;

	import org.bigbluebutton.core.util.URLFetcher;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.Careernews;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class CareernewsViewMediator2 extends Mediator
	{
		[Inject]
		public var view: ICareernewsView2;
		
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
			
			view.list.addEventListener(IndexChangeEvent.CHANGE, onSelectParticipant);
			
			dicUserIdtoUser = new Dictionary();
			
			var createUrl:String = "http://www.17mian.cn/demo/careernews.js";
			var fetcher:URLFetcher = new URLFetcher();
			fetcher.successSignal.add(onSuccess);
			fetcher.unsuccessSignal.add(onUnsucess);
			fetcher.fetch(createUrl);
			
			setPageTitle();
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
		}
		
		private function onUnsucess(reason:String):void 
		{
		}
		
		protected function onSuccess(data:Object, responseUrl:String, urlRequest:URLRequest):void {
			var objs:Object = JSON.parse(data.toString());
			var news:Careernews;
			
			for each (var obj:Object in objs)
			{
				news = new Careernews();
				news.icon = obj.icon;
				news.title = obj.title;
				news.brief = obj.brief;
				news.page = obj.page;
				news.datetime = obj.datetime;
				
				addCareernews(news);
			}
		}
		
		private function addCareernews(news:Careernews):void
		{
			dataProvider.addItem(news);
			dataProvider.refresh();
			setPageTitle();
		}
		
		protected function onSelectParticipant(event:IndexChangeEvent):void
		{
			if (event.newIndex >= 0) {
				var news:Careernews = dataProvider.getItemAt(event.newIndex) as Careernews;
				userUISession.pushPage(PagesENUM.WEBVIEW, news, TransitionAnimationENUM.SLIDE_LEFT);
			}
		}
		
		/**
		 * Count participants and set page title accordingly
		 **/
		private function setPageTitle():void
		{
			if(dataProvider != null)
			{
				FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'careernews.title');
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