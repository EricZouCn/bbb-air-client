package org.bigbluebutton.model
{
	import org.bigbluebutton.model.chat.ChatMessages;
	import org.osflash.signals.ISignal;

	public class Careernews
	{
		
		/**
		 * Flag to tell that user is in the process of leaving the meeting.
		 */ 
		public var isLeavingFlag:Boolean = false;

		private var _careernewsID:String = "";

		public function get careernewsID():String
		{
			return _careernewsID;
		}

		public function set careernewsID(value:String):void
		{
			_careernewsID = value;
		}

		private var _icon:String;

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}

		private var _title:String;

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}
		
		private var _brief:String = "";

		public function get brief():String {
			return _brief;
		}
		
		public function set brief(position:String):void {
			_brief = position;
		}
		
		private var _page:String = "";

		public function get page():String {
			return _page;
		}
		
		public function set page(position:String):void {
			_page = position;
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