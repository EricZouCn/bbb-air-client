package org.bigbluebutton.view.navigation.pages.webview
{
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RadioButtonGroup;
	
	public class WebView extends WebViewBase implements IWebView
	{
		override protected function childrenCreated():void
		{
			super.childrenCreated();
		}
		
		public function setUrl(url:String):void
		{
			webviewcontrol.setUrl(url);
		}
		
		public function dispose():void
		{
			webviewcontrol.dispose();
		}
	}
}