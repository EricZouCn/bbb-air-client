package org.bigbluebutton.model
{
	import org.bigbluebutton.model.chat.ChatMessages;
	import org.osflash.signals.ISignal;

	public class Interview
	{
		public static const MODERATOR:String = "MODERATOR";
		public static const VIEWER:String = "VIEWER";
		public static const PRESENTER:String = "PRESENTER";
		
		
		public static const UNKNOWN_USER:String = "UNKNOWN USER";
		
		/**
		 * Flag to tell that user is in the process of leaving the meeting.
		 */ 
		public var isLeavingFlag:Boolean = false;

		private var _interviewID:String = UNKNOWN_USER;

		public function get interviewID():String
		{
			return _interviewID;
		}

		public function set interviewID(value:String):void
		{
			_interviewID = value;
		}

		private var _logo:String;

		public function get logo():String
		{
			return _logo;
		}

		public function set logo(value:String):void
		{
			_logo = value;
		}

		private var _company:String;

		public function get company():String
		{
			return _company;
		}

		public function set company(value:String):void
		{
			_company = value;
		}
		
		private var _position:String = VIEWER;

		public function get position():String {
			return _position;
		}
		
		public function set position(position:String):void {
			_position = position;
		}
		
		private var _datetime:String;
		public function get datetime():String
		{
			return _datetime;
		}
		
		public function set datetime(value:String):void
		{
			_datetime = value;
		}
	}
}