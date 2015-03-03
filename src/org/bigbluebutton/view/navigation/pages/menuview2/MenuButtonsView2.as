package org.bigbluebutton.view.navigation.pages.menuview2
{
	import org.bigbluebutton.view.ui.NavigationButton;
		
	public class MenuButtonsView2 extends MenuButtons2 implements IMenuButtonsView2
	{
		
		public function get menuVideoChatButton():NavigationButton
		{
			return videochatBtn0;
		}
		
		public function get menuParticipantsButton():NavigationButton
		{
			return participantsBtn0;
		}
	}
}