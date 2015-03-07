package org.bigbluebutton.view.navigation.pages.webview
{
	import org.bigbluebutton.core.view.IView;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RadioButtonGroup;

	public interface IWebView extends IView
	{
		function setUrl(url:String):void;
	}
}