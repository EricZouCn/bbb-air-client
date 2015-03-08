package org.bigbluebutton.view.navigation.pages.videochat2
{
	import flash.net.NetConnection;
	
	import mx.core.FlexGlobals;
	import spark.components.Image;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	
	public class VideoChatView2 extends VideoChatViewBase2 implements IVideoChatView2
	{
		private var webcam:VideoChatVideoView2;
		private var webcam2:VideoChatVideoView2;
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
		}
		
		public function startStream(connection:NetConnection, name:String, streamName:String, userID:String, width:Number, height:Number, screenHeight:Number, screenWidth:Number):void 
		{
			if (webcam) stopStream();
			
			webcam = new VideoChatVideoView2();
			webcam.percentWidth = 100;
			webcam.percentHeight = 100;
			this.videoGroup.addElement(webcam);
//			webcam.depth = 0;
			var topActionBarHeight : Number = FlexGlobals.topLevelApplication.topActionBar.height;
			var bottomMenuHeight : Number = FlexGlobals.topLevelApplication.bottomMenu.height;
			webcam.startStream(connection, name, streamName, userID, width, height, screenHeight, screenWidth,topActionBarHeight, bottomMenuHeight);			
			webcam.setVideoPosition(name);
//			webcam.rotation = 30;
//			if(webcam2) {
//				this.videoGroup.removeElement(webcam2);
//				this.videoGroup.addElement(webcam2);
//			}
		}
		
		public function stopStream():void 
		{
			if(webcam)
			{
				webcam.close();
				
				if(this.videoGroup.containsElement(webcam))
				{
					this.videoGroup.removeElement(webcam);
				}
				
				webcam = null;
			}
		}
		
		public function get videoGroup():Group
		{
			return videoGroup0;
		}
		
		public function startStream2(connection:NetConnection, name:String, streamName:String, userID:String, width:Number, height:Number, screenHeight:Number, screenWidth:Number):void 
		{
			if (webcam2) stopStream2();
			
			webcam2 = new VideoChatVideoView2();
			webcam2.percentWidth = 100;
			webcam2.percentHeight = 100;
			this.videoGroup.addElement(webcam2);
//			webcam2.depth = 2;
			var topActionBarHeight : Number = FlexGlobals.topLevelApplication.topActionBar.height;
			var bottomMenuHeight : Number = FlexGlobals.topLevelApplication.bottomMenu.height;
			webcam2.startStream(connection, name, streamName, userID, width, height, screenHeight, screenWidth,topActionBarHeight, bottomMenuHeight);			
			webcam2.setVideoPosition2(name, videoGroup.width, videoGroup.height, (webcam == null ? (videoGroup.width-webcam2.videoWidth) : webcam.videoWidth));
		}
		
		public function stopStream2():void 
		{
			if(webcam2)
			{
				webcam2.close();
				
				if(this.videoGroup.containsElement(webcam2))
				{
					this.videoGroup.removeElement(webcam2);
				}
				
				webcam2 = null;
			}
		}
		
		public function dispose():void
		{
			stopStream();
			stopStream2();
		}
		
		public function get noVideoMessage():Label
		{
			return noVideoMessage0;
		}
		
		public function get streamlist():List
		{
			return videoStreamsList;
		}
		
		public function getDisplayedUserID():String {
			if (webcam != null) {
				return webcam.userID;
			} else {
				return null;
			}
		}
		
	}
}