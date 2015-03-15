package org.bigbluebutton.view.navigation.pages.videochat2
{
	import flash.display.DisplayObject;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.mockito.integrations.currentMockito;
	import org.osmf.logging.Log;
	import org.bigbluebutton.command.CameraQualitySignal;
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.core.VideoConnection;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class VideoChatViewMediator2 extends Mediator
	{
		[Inject]
		public var view: IVideoChatView2;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var shareCameraSignal: ShareCameraSignal;			
		
		[Inject]
		public var shareMicrophoneSignal: ShareMicrophoneSignal;
		
		protected var dataProvider:ArrayCollection;
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			userSession.userList.userRemovedSignal.add(userRemovedHandler);
			userSession.userList.userAddedSignal.add(userAddedHandler);
			userSession.userList.userChangeSignal.add(userChangeHandler);
			
			userUISession.pageTransitionStartSignal.add(onPageTransitionStart);
			view.streamlist.addEventListener(IndexChangeEvent.CHANGE, onSelectStream);
			
//			checkVideo();
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'video.title2');
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			
			userUISession.videoConnectedSignal.add(videoConnected);
			
			dataProvider = new ArrayCollection();
			view.streamlist.dataProvider = dataProvider;
			
			if(userUISession.videoConnected)
				checkUserVideo();
		}
		
		/**
		 * Update the view when the video connection is connected
		 */ 
		private function videoConnected(videoConnected:Boolean):void
		{
			if(!videoConnected)
				return;
			
			checkUserVideo();
		}
		
		private function checkUserVideo():void
		{
			var users:ArrayCollection = userSession.userList.users;
			for each(var u:User in users)
			{
				if(u.hasStream && !dataProvider.contains(u))
				{
					dataProvider.addItem(u);
					if(view && view.getDisplayedUserID() == u.userID)
					{
						view.streamlist.selectedIndex = dataProvider.getItemIndex(u);
					}
					
					checkVideo(u);
				}
			}	
			
			userSession.videoConnection.selectedCameraQuality = VideoConnection.CAMERA_QUALITY_MEDIUM;	
			shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.FRONT);
			
			shareMic();
		}
		
		private function shareMic():void
		{
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = !userSession.userList.me.voiceJoined;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = false;
			shareMicrophoneSignal.dispatch(audioOptions);			
		}
		
		protected function getUserWithCamera():User
		{
			var users:ArrayCollection = userSession.userList.users;
			var userMe:User = null;
			
			for each(var u:User in users) 
			{
				if (u.hasStream) 
				{
					if (u.me)
					{
						userMe = u;		
					}
					else
					{
						return u;
					}
				}
			}
			
			return userMe;
		}
		
		private function onPageTransitionStart(lastPage:String):void
		{
			if(lastPage == PagesENUM.VIDEO_CHAT)
			{
				view.dispose();
			}
		}
		
		private function onSelectStream(event:IndexChangeEvent):void
		{
			if (event.newIndex >= 0) 
			{
				var user:User = dataProvider.getItemAt(event.newIndex) as User;
				if(user.hasStream)
				{
					if(view && view.getDisplayedUserID() != null)
					{
						stopStream(view.getDisplayedUserID());
					}
					startStream(user.name, user.streamName);
				}
			}
		}
		
		override public function destroy():void
		{
			userSession.userList.userRemovedSignal.remove(userRemovedHandler);
			userSession.userList.userAddedSignal.remove(userAddedHandler);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			
			userUISession.pageTransitionStartSignal.remove(onPageTransitionStart);
			
			view.dispose();
			view = null;
			
			userSession.logoutSignal.dispatch();
			
			super.destroy();
		}
		
		private function userAddedHandler(user:User):void 
		{
			if (user.hasStream)
			{
				checkVideo();
				dataProvider.addItem(user);		
			}
		}
		
		private function userRemovedHandler(userID:String):void 
		{
			if (view.getDisplayedUserID() == userID) 
			{
				stopStream(userID);
				checkVideo();
			}
			for(var item:int; item<dataProvider.length; item++)
			{
				if((dataProvider.getItemAt(item) as User).userID == userID)
				{
					dataProvider.removeItemAt(item);
					break;
				}
			}
			if(dataProvider.length==0)
			{
				view.noVideoMessage.visible = true;
			}
			else
			{
				view.noVideoMessage.visible = false;
			}			
		}
		
		private function userChangeHandler(user:User, property:int):void 
		{
			if (property == UserList.HAS_STREAM)
			{
				if (user.userID == view.getDisplayedUserID() && !user.hasStream)
				{
					stopStream(user.userID);
				}				
				
				if(dataProvider.contains(user) && !user.hasStream)
				{
					dataProvider.removeItemAt(dataProvider.getItemIndex(user));
				}
				else if(!dataProvider.contains(user) && user.hasStream)
				{
					dataProvider.addItem(user);
				}
				
				if(view.getDisplayedUserID()==null)
				{
					checkVideo();
				} else 
				{
					checkVideo(user);
				}
				
				if(dataProvider.length==0)
				{
					view.noVideoMessage.visible = true;
				}
				else
				{
					view.noVideoMessage.visible = false;
					view.streamlist.selectedIndex = dataProvider.getItemIndex(userSession.userList.getUserByUserId(view.getDisplayedUserID()));
				}
			}
		}
		
		private function startStream(name:String, streamName:String):void 
		{
			var resolution:Object = getVideoResolution(streamName);
			
			if (resolution) 
			{
				trace(ObjectUtil.toString(resolution));
				var width:Number = Number(String(resolution.dimensions[0]));
				var length:Number = Number(String(resolution.dimensions[1]));
				if (view) 
				{
					view.startStream(userSession.videoConnection.connection, name, streamName, resolution.userID, width, length, view.videoGroup.height, view.videoGroup.width);
				}
			}
		}
		
		private function startStream2(name:String, streamName:String):void 
		{
			var resolution:Object = getVideoResolution(streamName);
			
			if (resolution) 
			{
				trace(ObjectUtil.toString(resolution));
				var width:Number = Number(String(resolution.dimensions[0]));
				var length:Number = Number(String(resolution.dimensions[1]));
				if (view) 
				{
					view.startStream2(userSession.videoConnection.connection, name, streamName, resolution.userID, width, length, view.videoGroup.height/2, view.videoGroup.width/2);
				}
			}
		}
		
		private function stopStream(userID:String):void 
		{
			if (view) 
			{
				view.stopStream();
			}
		}
		
		private function stopStream2(userID:String):void 
		{
			if (view) 
			{
				view.stopStream2();
			}
		}
		
		private function checkVideo(changedUser:User = null):void 
		{
			// get id of the user that is currently displayed
			var currentUserID:String = view.getDisplayedUserID();
			
			// get user that was selected 
			var selectedUser:User = userUISession.currentPageDetails as User;
			
			// get presenter user
			var presenter:User = userSession.userList.getPresenter();
			
			// get any user that has video stream
			var userWithCamera:User = getUserWithCamera();
			
			var newUser:User;
					
			if (changedUser)
			{
				// Priority state machine
				if (changedUser.hasStream)
				{
					if (changedUser.me)
					{
						if (view) view.stopStream2();	
						startStream2(changedUser.name, changedUser.streamName);
					}
					else
					{
						if (view) view.stopStream();	
						startStream(changedUser.name, changedUser.streamName);
					}
				} 
			}
			else
			{	
				// Priority state machine
				
				if (presenter != null && presenter.hasStream)
				{
					newUser = presenter;
				}
					// any user with camera is the last priority
				else if (userWithCamera != null)
				{
					newUser = userWithCamera;
				}
					// otherwise, nobody transmitts video at this moment
				else
				{
					return;
				}
								
				if (newUser)
				{
					if (newUser.me)
					{
						if (view) view.stopStream2();	
						startStream2(newUser.name, newUser.streamName);
					} 
					else 
					{
						if (view) view.stopStream();	
						startStream(newUser.name, newUser.streamName);
						view.noVideoMessage.visible = false;
					}
				}	
			}
		}
		
		protected function getVideoResolution(stream:String):Object
		{
			var pattern:RegExp = new RegExp("(\\d+x\\d+)-([A-Za-z0-9]+)-\\d+", "");
			if (pattern.test(stream))
			{
				trace("The stream name is well formatted [" + stream + "]");
				trace("Stream resolution is [" + pattern.exec(stream)[1] + "]");
				trace("Userid [" + pattern.exec(stream)[2] + "]");
				return {userID: pattern.exec(stream)[2], dimensions:pattern.exec(stream)[1].split("x")};
			}
			else
			{
				trace("The stream name doesn't follow the pattern <width>x<height>-<userId>-<timestamp>. However, the video resolution will be set to 320x240");
				return null;
			}
		}
	}
}