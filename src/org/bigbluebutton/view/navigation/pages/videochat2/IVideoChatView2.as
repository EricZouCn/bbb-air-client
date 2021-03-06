package org.bigbluebutton.view.navigation.pages.videochat2
{
	import flash.net.NetConnection;
	
	import org.bigbluebutton.core.view.IView;
	import org.osflash.signals.ISignal;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.Scroller;

	public interface IVideoChatView2 extends IView
	{
		function stopStream():void
		function startStream(connection:NetConnection, name:String, streamName:String, userID:String, width:Number, height:Number, screenHeight:Number, screenWidth:Number):void
		function stopStream2():void
		function startStream2(connection:NetConnection, name:String, streamName:String, userID:String, width:Number, height:Number, screenHeight:Number, screenWidth:Number):void
		function get noVideoMessage():Label
		function getDisplayedUserID():String
		function get videoGroup():Group
		function get group():Group
		function get streamlist():List
	}
}