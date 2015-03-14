package org.bigbluebutton.view.ui.loading
{
	import mx.core.IUIComponent;
	import spark.components.Button;
	
	import org.bigbluebutton.core.view.IView;

	public interface ILoadingScreen extends IView, IUIComponent
	{
		function get loginButton():Button
	}
}