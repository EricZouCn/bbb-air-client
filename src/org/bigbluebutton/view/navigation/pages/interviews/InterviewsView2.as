package org.bigbluebutton.view.navigation.pages.interviews
{
	import flash.events.MouseEvent;
	
	public class InterviewsView2 extends InterviewsViewBase2 implements IInterviewsView2 
	{
		
		//private var _buttonTestSignal: Signal = new Signal();
		//public function get buttonTestSignal(): ISignal
		//{
		//	return _buttonTestSignal;
		//}
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			//this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		import spark.components.List;
		
		public function get list():List
		{
			return interviewslist;
		}
		/*
		public function onClick(e:MouseEvent):void
		{
			//buttonTestSignal.dispatch();
		}
		*/
		public function dispose():void
		{

		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}