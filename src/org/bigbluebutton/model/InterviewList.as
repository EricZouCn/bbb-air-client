package org.bigbluebutton.model
{
	import mx.collections.ArrayCollection;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	
	import spark.collections.Sort;
	
	public class InterviewList
	{
		public static const HAS_STREAM:int = 1;
		public static const PRESENTER:int = 2;
		public static const JOIN_AUDIO:int = 3;
		public static const MUTE:int = 4;
		public static const RAISE_HAND:int = 5;
		public static const LOCKED:int = 6;
		public static const LISTEN_ONLY:int = 7;
		
		private var _interviews:ArrayCollection;	
		
		[Bindable]
		public function get interviews():ArrayCollection
		{
			return _interviews;
		}
		
		private function set interviews(value:ArrayCollection):void
		{
			_interviews = value;
		}

		private var _sort:Sort;
		
		public function UserList()
		{
			_interviews = new ArrayCollection();
			_sort = new Sort();
			_sort.compareFunction = sortFunction;
			_interviews.sort = _sort;
		}
		
		/**
		 * Dispatched when all participants are added
		 */
		private var _allInterviewsAddedSignal: Signal = new Signal();
		
		public function get allInterviewsAddedSignal(): ISignal
		{
			return _allInterviewsAddedSignal;
		}
		
		/**
		 * Get a interview based on a InterviewId 
		 * 
		 * @param InterviewId
		 */
		public function getInterviewById(interviewId:String):Interview
		{
			if (interviews != null)
			{
				for each(var interview:Interview in interviews)
				{	
					if (interview.interviewID == interviewId)
					{
						return interview;
					}
				}
			}
			
			return null;		
		}
		
		/** 
		 * Custom sort function for the users ArrayCollection. Need to put dial-in users at the very bottom.
		 */ 
		private function sortFunction(a:Object, b:Object, array:Array = null):int {
			var au:User = a as User, bu:User = b as User;
			/*if (a.presenter)
			return -1;
			else if (b.presenter)
			return 1;*/
			if (au.role == User.MODERATOR && bu.role == User.MODERATOR) {
				// do nothing go to the end and check names
			} else if (au.role == User.MODERATOR)
				return -1;
			else if (bu.role == User.MODERATOR)
				return 1;
			else if (au.raiseHand && bu.raiseHand) {
				// do nothing go to the end and check names
			} else if (au.raiseHand)
				return -1;
			else if (bu.raiseHand)
				return 1;
			else if (au.phoneUser && bu.phoneUser) {
				
			} else if (au.phoneUser)
				return -1;
			else if (bu.phoneUser)
				return 1;
			
			/** 
			 * Check name (case-insensitive) in the event of a tie up above. If the name 
			 * is the same then use userID which should be unique making the order the same 
			 * across all clients.
			 */
			if (au.name.toLowerCase() < bu.name.toLowerCase())
				return -1;
			else if (au.name.toLowerCase() > bu.name.toLowerCase())
				return 1;
			else if (au.userID.toLowerCase() > bu.userID.toLowerCase())
				return -1;
			else if (au.userID.toLowerCase() < bu.userID.toLowerCase())
				return 1;
			
			return 0;
		}
		
		private var _interviewAddedSignal: Signal = new Signal();
		
		public function get interviewAddedSignal(): ISignal
		{
			return _interviewAddedSignal;
		}
		
		public function addInterview(newinterview:Interview):void {
			trace("Adding new interview [" + newinterview.interviewID + "]");
			if (! hasInterview(newinterview.interviewID)) {
				_interviews.addItem(newinterview);
				_interviews.refresh();
				
				interviewAddedSignal.dispatch(newinterview);
			}					
		}
		
		public function hasInterview(interviewID:String):Boolean {
			var p:Object = getInterviewIndex(interviewID);
			if (p != null) {
				return true;
			}
			
			return false;		
		}
		
		public function getUser(userID:String):User {
			var p:Object = getInterviewIndex(userID);
			if (p != null) {
				return p.participant as User;
			}
			
			return null;				
		}
		
		/**
		 * Get the an object containing the index and User object for a specific userid 
		 * @param userID
		 * @return null if userID id not found
		 * 
		 */		
		private function getInterviewIndex(interviewID:String):Object {
			var aInterview:Interview;
			
			for (var i:int = 0; i < _interviews.length; i++) {
				aInterview = _interviews.getItemAt(i) as Interview;
				
				if (aInterview.interviewID == interviewID) {
					return {index:i, interview:aInterview};
				}
			}				
			
			return null;
		}
		
	}
}